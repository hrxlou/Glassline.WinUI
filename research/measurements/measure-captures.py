"""Measure control geometry from verified AppleReferenceLab captures.

Ledger rows must be reproducible, so this is committed alongside them: given the private capture
set, re-running it reproduces every Observed value.

Two rules govern what it will report.

Scale is never assumed. It is measured from the 200 pt calibration rule inside each capture, so a
capture whose rule cannot be located produces nothing.

A value is reported only if it is stable. Every measurement is repeated across several mask
thresholds and across independent captures of the same control. A quantity whose value moves with
the threshold is a property of the threshold, not of the control, and is reported unmeasurable
instead of being rounded into the ledger.

Usage:
    python measure-captures.py <capture-directory>

The capture directory is private research material and is never committed.
"""

import statistics
import sys
from pathlib import Path

import numpy as np
from PIL import Image

SEGMENT_POINTS = 10.0
SEGMENT_COUNT = 20
MASK_THRESHOLDS = (18, 24, 36, 48)

# A quantity is Observed only if it lands inside this band across every threshold and capture.
STABILITY_TOLERANCE_PT = 0.25


def _edge_positions(row, threshold):
    diff = np.abs(np.diff(row.astype(np.int16)))
    idx = np.flatnonzero(diff > threshold)
    if idx.size == 0:
        return []
    groups, current = [], [idx[0]]
    for value in idx[1:]:
        if value - current[-1] <= 2:
            current.append(value)
        else:
            groups.append(current)
            current = [value]
    groups.append(current)
    return [float(np.mean(g)) + 0.5 for g in groups]


def find_calibration_rule(gray):
    """Locate the rule and return (px_per_pt, row_y, x_start, x_end).

    Monospaced caption text also produces long runs of roughly even edges, so uniformity is the
    discriminator: the rule's segments are identical by construction, glyph spacing is not.
    """
    height = gray.shape[0]
    best = None

    for y in range(0, int(height * 0.45)):
        for threshold in (60, 90):
            edges = _edge_positions(gray[y], threshold)
            if len(edges) < SEGMENT_COUNT - 2:
                continue

            gaps = np.diff(edges)
            start = 0
            while start < len(gaps):
                end = start + 1
                while end < len(gaps) and abs(gaps[end] - gaps[start]) <= max(1.0, gaps[start] * 0.12):
                    end += 1
                run = gaps[start:end]
                if len(run) >= SEGMENT_COUNT - 3:
                    median_gap = statistics.median(run)
                    spread = (max(run) - min(run)) / median_gap
                    if spread <= 0.08 and 5.0 <= median_gap <= 60.0:
                        candidate = (
                            len(run), -spread, y,
                            float(median_gap), edges[start], edges[end],
                        )
                        if best is None or candidate[:2] > best[:2]:
                            best = candidate
                start = end

    if best is None:
        return None

    _, _, y, median_gap, x_start, x_end = best
    return median_gap / SEGMENT_POINTS, y, x_start, x_end


def _components(mask, min_w, min_h):
    """Label 4-connected regions without SciPy by merging overlapping row runs."""
    height, width = mask.shape
    labels = np.zeros((height, width), dtype=np.int32)
    parent = {0: 0}

    def find(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    def union(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[max(ra, rb)] = min(ra, rb)

    nxt = 1
    for y in range(height):
        x = 0
        while x < width:
            if not mask[y, x]:
                x += 1
                continue
            start = x
            while x < width and mask[y, x]:
                x += 1
            above = labels[y - 1, start:x] if y > 0 else np.zeros(0, dtype=np.int32)
            hits = sorted({int(v) for v in above if v})
            if hits:
                label = hits[0]
                for other in hits[1:]:
                    union(label, other)
            else:
                label = nxt
                parent[label] = label
                nxt += 1
            labels[y, start:x] = label

    boxes = {}
    for y in range(height):
        row = labels[y]
        for x in np.flatnonzero(row):
            root = find(int(row[x]))
            box = boxes.setdefault(root, [x, y, x, y])
            box[0] = min(box[0], x)
            box[2] = max(box[2], x)
            box[3] = y

    result = [
        (x0, y0, x1, y1)
        for x0, y0, x1, y1 in boxes.values()
        if (x1 - x0 + 1) >= min_w and (y1 - y0 + 1) >= min_h
    ]
    return sorted(result, key=lambda b: (b[1], b[0]))


def content_region(gray, rule):
    """Anchor the search region to the calibration rule rather than to fixed pixel coordinates.

    Captures vary in window and shadow size, so absolute coordinates do not survive across a set.
    """
    px_per_pt, rule_y, rule_x0, _ = rule
    x0 = int(rule_x0)
    y0 = int(rule_y + 12 * px_per_pt)
    x1 = min(gray.shape[1], x0 + int(700 * px_per_pt))
    y1 = min(gray.shape[0], y0 + int(120 * px_per_pt))
    return x0, y0, x1, y1


def control_row(rgb, region, threshold, px_per_pt):
    """The most populated horizontal band of control-sized shapes below the header."""
    x0, y0, x1, y1 = region
    window = rgb[y0:y1, x0:x1]
    base = np.median(window.reshape(-1, 3), axis=0)
    mask = np.abs(window - base).sum(axis=2) > threshold

    boxes = _components(mask, min_w=int(20 * px_per_pt), min_h=int(15 * px_per_pt))
    if not boxes:
        return mask, []

    bands = {}
    for box in boxes:
        bands.setdefault(round(box[1] / (5 * px_per_pt)), []).append(box)
    band = max(bands.values(), key=len)
    return mask, sorted(band, key=lambda b: b[0])


def radius_estimate(mask, box):
    """Rows at the top whose left edge is inset from the flat edge; equals r on a rounded rect.

    This shares a mask with the height measurement, so agreement between shape estimators does not
    validate the threshold. Only spread across thresholds and captures does.
    """
    x0, y0, x1, y1 = box
    sub = mask[y0:y1 + 1, x0:x1 + 1]
    lefts = []
    for row in sub:
        hit = np.flatnonzero(row)
        lefts.append(int(hit[0]) if hit.size else None)
    solid = [v for v in lefts if v is not None]
    if not solid:
        return None
    base = min(solid)
    count = 0
    for value in lefts:
        if value is None or value <= base:
            break
        count += 1
    return count


def measure_scene(paths):
    """Collect per-control samples across every capture and threshold."""
    heights, radii, scales = {}, {}, []

    for path in paths:
        with Image.open(path) as img:
            rgb = np.asarray(img.convert("RGB"), dtype=np.int16)
            gray = np.asarray(img.convert("L"), dtype=np.uint8)

        rule = find_calibration_rule(gray)
        if rule is None:
            print(f"  {path.stem}: calibration rule not found — skipped")
            continue

        px_per_pt = rule[0]
        scales.append(px_per_pt)
        region = content_region(gray, rule)

        for threshold in MASK_THRESHOLDS:
            mask, boxes = control_row(rgb, region, threshold, px_per_pt)
            if not boxes:
                continue
            for index, box in enumerate(boxes):
                heights.setdefault(index, []).append((box[3] - box[1] + 1) / px_per_pt)
                r = radius_estimate(mask, box)
                if r is not None:
                    radii.setdefault(index, []).append(r / px_per_pt)

    return heights, radii, scales


def report(label, samples):
    for index in sorted(samples):
        values = samples[index]
        if not values:
            continue
        low, high, median = min(values), max(values), statistics.median(values)
        spread = high - low
        verdict = "OBSERVED " if spread <= STABILITY_TOLERANCE_PT else "UNSTABLE "
        print(f"  {verdict} {label}[{index}] = {median:.2f} pt  "
              f"range=[{low:.2f}, {high:.2f}] spread={spread:.2f} n={len(values)}")


def main():
    root = Path(sys.argv[1])

    scenes = ["buttons", "toggle-slider", "text-input", "pickers"]
    variants = [
        "light__active__default", "light__inactive__default",
        "dark__active__default", "dark__inactive__default",
        "light__active__reduce-transparency", "dark__active__reduce-transparency",
    ]

    for scene in scenes:
        paths = []
        for variant in variants:
            found = list(root.rglob(f"{scene}__{variant}.png"))
            paths.extend(found)

        print(f"\n=== {scene} ({len(paths)} captures) ===")
        if not paths:
            print("  no captures")
            continue

        heights, radii, scales = measure_scene(paths)
        if scales:
            print(f"  measured scale: {statistics.median(scales):.4f} px/pt "
                  f"(range {min(scales):.4f}–{max(scales):.4f})")
        report("height", heights)
        report("radius", radii)


if __name__ == "__main__":
    main()
