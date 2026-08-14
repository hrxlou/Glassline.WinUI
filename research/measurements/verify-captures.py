"""Verify a capture set before anything is measured from it.

Written after a delivery passed a filename-and-scale review while nine captures were byte-identical
copies of their active counterparts. Correct names and a correct calibration rule say nothing about
whether a file holds the state its name claims, so those checks are necessary and were not
sufficient.

Checks:
  1. every manifest capture is present, and every present file is named after a manifest id;
  2. the 200 pt calibration rule is locatable and every capture measures the same scale;
  3. no two captures are identical - a duplicate is a state that was never captured;
  4. active and inactive captures of the same scene differ - the window state must be real.

Usage:
    python verify-captures.py <capture-directory> [manifest.csv]
"""

import csv
import hashlib
import statistics
import sys
from pathlib import Path

import numpy as np
from PIL import Image

sys.path.insert(0, str(Path(__file__).parent))

_measure = __import__("importlib").import_module("importlib.util")
_spec = _measure.spec_from_file_location("mc", Path(__file__).parent / "measure-captures.py")
_mc = _measure.module_from_spec(_spec)
_spec.loader.exec_module(_mc)

REQUIRED_SCALE = 2.0

# The header prints the state the probe actually saw, so two captures claiming different states must
# have different headers. Comparing whole images does not work: a genuinely inactive window can
# differ from its active counterpart by very little, while a re-encoded copy of the same state
# differs by a pixel of noise. The header is the part that must change.
HEADER_CHANGED_PIXELS = 200


def header_band(path):
    """The capture_id and context lines, anchored to the calibration rule.

    Anchoring matters: captures differ in window and shadow size, so a fixed crop compares different
    content and reports a difference that is really a misalignment.
    """
    with Image.open(path) as img:
        gray = np.asarray(img.convert("L"), dtype=np.uint8)
        rule = _mc.find_calibration_rule(gray)
        if rule is None:
            return None
        px_per_pt, rule_y, rule_x0, _ = rule
        x0 = int(rule_x0)
        y0 = max(0, int(rule_y - 40 * px_per_pt))
        y1 = max(y0 + 1, int(rule_y - 4 * px_per_pt))
        x1 = min(img.width, x0 + int(600 * px_per_pt))
        return np.asarray(img.convert("RGB").crop((x0, y0, x1, y1)), dtype=np.int16)


def load_manifest(path):
    with path.open(newline="", encoding="utf-8") as handle:
        return {row["capture_id"]: row for row in csv.DictReader(handle)}


def main():
    root = Path(sys.argv[1])
    manifest_path = Path(sys.argv[2]) if len(sys.argv) > 2 else (
        Path(__file__).parents[1] / "AppleReferenceLab" / "capture-manifest.csv"
    )

    manifest = load_manifest(manifest_path)
    files = sorted(p for p in root.rglob("*.png") if "__MACOSX" not in str(p))
    by_id = {p.stem: p for p in files}

    failures, warnings = [], []

    # 1. coverage
    missing = sorted(set(manifest) - set(by_id))
    extra = sorted(set(by_id) - set(manifest))
    print(f"coverage: {len(set(by_id) & set(manifest))}/{len(manifest)} manifest captures present")
    for capture_id in missing:
        failures.append(f"missing required capture: {capture_id}")
    for name in extra:
        warnings.append(f"not a manifest capture (extra observation): {name}")

    # 2. scale
    scales = {}
    for capture_id, path in sorted(by_id.items()):
        if capture_id not in manifest:
            continue
        with Image.open(path) as img:
            gray = np.asarray(img.convert("L"), dtype=np.uint8)
        rule = _mc.find_calibration_rule(gray)
        if rule is None:
            failures.append(f"{capture_id}: calibration rule not found")
            continue
        scales[capture_id] = rule[0]
        if abs(rule[0] - REQUIRED_SCALE) > 0.01:
            failures.append(f"{capture_id}: measured {rule[0]:.4f} px/pt, required {REQUIRED_SCALE:.1f}")

    if scales:
        values = list(scales.values())
        print(f"scale: median {statistics.median(values):.4f} px/pt "
              f"across {len(values)} captures (range {min(values):.4f}-{max(values):.4f})")

    # 3. duplicates
    digests = {}
    for capture_id, path in by_id.items():
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        digests.setdefault(digest, []).append(capture_id)
    duplicates = [group for group in digests.values() if len(group) > 1]
    print(f"duplicates: {len(duplicates)} group(s)")
    for group in duplicates:
        failures.append("identical files, so at least one state was never captured: "
                        + ", ".join(sorted(group)))

    # 4. the header states the state the file's name claims
    checked = 0
    for capture_id, row in manifest.items():
        if row["window_state"] != "inactive":
            continue
        counterpart = capture_id.replace("__inactive__", "__active__")
        if capture_id not in by_id or counterpart not in by_id:
            continue

        band_a = header_band(by_id[capture_id])
        band_b = header_band(by_id[counterpart])
        checked += 1

        if band_a is None or band_b is None:
            failures.append(f"{capture_id}: header band could not be located for comparison")
            continue
        if band_a.shape != band_b.shape:
            failures.append(f"{capture_id}: header band size differs from {counterpart}")
            continue

        changed = int((np.abs(band_a - band_b).max(axis=2) > 32).sum())
        if changed < HEADER_CHANGED_PIXELS:
            failures.append(f"{capture_id}: its header is identical to {counterpart}, so both files "
                            f"record the same window state and this one is a mislabelled copy")
    print(f"window-state headers: {checked} inactive capture(s) compared")

    print()
    for warning in warnings:
        print(f"WARN  {warning}")
    for failure in failures:
        print(f"FAIL  {failure}")

    if failures:
        print(f"\n{len(failures)} failure(s); this set is not ready to measure.")
        raise SystemExit(1)

    print("\nCapture set verified.")


if __name__ == "__main__":
    main()
