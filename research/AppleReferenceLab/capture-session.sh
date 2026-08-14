#!/bin/bash
# Guided capture session for AppleReferenceLab.
#
# The operator never types a filename. Every previous delivery's defects came from the gap between
# what was on screen and what the file was called: 1x captures named as if measurable, active
# windows named inactive, contrast captures never taken because the required state did not exist.
# This walks the manifest in an order that minimises system-settings changes, states exactly what
# must be true before each shot, and writes the file under the manifest's own capture_id.
#
# It cannot verify what it captured. Run verify-captures.py afterwards; this script offers to.
#
# Usage:
#   research/AppleReferenceLab/capture-session.sh [output-directory] [--delay N] [--redo]
#
# Existing captures are skipped so an interrupted session can be resumed. --redo retakes everything.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MANIFEST="$REPO_ROOT/research/AppleReferenceLab/capture-manifest.csv"
OUT="${1:-$HOME/glassline-captures}"
DELAY=8
REDO=0

shift || true
while [ $# -gt 0 ]; do
    case "$1" in
        --delay) DELAY="$2"; shift 2 ;;
        --redo) REDO=1; shift ;;
        *) echo "unknown option: $1" >&2; exit 2 ;;
    esac
done

[ -f "$MANIFEST" ] || { echo "manifest not found: $MANIFEST" >&2; exit 1; }
mkdir -p "$OUT"

echo "manifest:  $MANIFEST"
echo "output:    $OUT"
echo "delay:     ${DELAY}s between confirming and the shutter"
echo

cat <<'INTRO'
Before starting, confirm all three. A session that violates any of them is not measurable.

  1. The probe window is on a Retina display. Its header must read backing_scale=2.00.
  2. The whole probe window is visible and unobstructed.
  3. The build is current:
       swift build --package-path research/AppleReferenceLab -c release
       .build/release/AppleReferenceLab

The header prints the capture_id it resolves from the live environment. Before every shot, check
that it matches the id this script names. If the header reads NONE, the state is wrong - fix it
rather than capturing.

INTRO
read -r -p "Press Enter to begin, Ctrl-C to abort. "

# Group by the settings that are slow to change, so appearance and accessibility flip once each.
GROUPS=$(tail -n +2 "$MANIFEST" | awk -F, '{print $3","$5}' | sort -u)

total=0
taken=0
skipped=0

for group in $GROUPS; do
    appearance="${group%%,*}"
    mode="${group##*,}"

    rows=$(tail -n +2 "$MANIFEST" | awk -F, -v a="$appearance" -v m="$mode" '$3==a && $5==m {print $0}')
    [ -n "$rows" ] || continue

    pending=0
    while IFS=, read -r capture_id _scene _appearance _window _mode _interaction; do
        [ -n "$capture_id" ] || continue
        if [ $REDO -eq 0 ] && [ -f "$OUT/$capture_id.png" ]; then continue; fi
        pending=$((pending + 1))
    done <<< "$rows"

    if [ "$pending" -eq 0 ]; then
        echo "== $appearance / $mode - already complete, skipping"
        continue
    fi

    echo
    echo "================================================================"
    echo "  Set system appearance to: $appearance"
    case "$mode" in
        default)
            echo "  Accessibility: Reduce Transparency OFF, Increase Contrast OFF" ;;
        reduce-transparency)
            echo "  Accessibility: Reduce Transparency ON, Increase Contrast OFF" ;;
        increase-contrast)
            echo "  Accessibility: Increase Contrast ON"
            echo "  macOS will force Reduce Transparency on and lock it. That is correct." ;;
    esac
    echo "  $pending capture(s) in this group"
    echo "================================================================"
    read -r -p "Set it, then press Enter. "

    while IFS=, read -r capture_id scene _appearance window _mode interaction; do
        [ -n "$capture_id" ] || continue
        target="$OUT/$capture_id.png"
        total=$((total + 1))

        if [ $REDO -eq 0 ] && [ -f "$target" ]; then
            skipped=$((skipped + 1))
            continue
        fi

        echo
        echo "--- $capture_id"
        echo "    scene:  $scene   (select it in the sidebar)"

        case "$window" in
            active)
                echo "    window: ACTIVE - click the probe window, header must read window=active" ;;
            inactive)
                echo "    window: INACTIVE - click away from the probe (this terminal will do)."
                echo "            Header must read window=inactive. Do NOT click the probe after this." ;;
        esac

        case "$interaction" in
            normal) ;;
            hover)
                echo "    state:  HOVER - rest the pointer on the probe control and hold it still"
                echo "            (Default button / Toggle / TextField / Menu Picker)" ;;
            focused)
                echo "    state:  FOCUSED - Tab to the probe control, then do not click anything" ;;
            pressed)
                echo "    state:  PRESSED - press and HOLD the mouse on the probe control"
                echo "            through the countdown, and keep holding until the shutter fires" ;;
        esac

        echo "    header: capture_id=$capture_id"
        read -r -p "    Ready? Enter to arm the ${DELAY}s timer, or 's' to skip. " answer
        if [ "$answer" = "s" ]; then
            skipped=$((skipped + 1))
            echo "    skipped"
            continue
        fi

        echo "    capturing in ${DELAY}s - set the state now"
        screencapture -T "$DELAY" -x "$target"

        if [ -f "$target" ]; then
            taken=$((taken + 1))
            echo "    saved $capture_id.png"
        else
            echo "    NOT SAVED - screencapture produced no file"
        fi
    done <<< "$rows"
done

echo
echo "================================================================"
echo "  attempted $total   saved $taken   skipped $skipped"
echo "================================================================"

VERIFY="$REPO_ROOT/research/measurements/verify-captures.py"
if [ -f "$VERIFY" ]; then
    echo
    read -r -p "Run verification now? [Y/n] " answer
    if [ "$answer" != "n" ] && [ "$answer" != "N" ]; then
        python3 "$VERIFY" "$OUT" || {
            echo
            echo "Verification failed. Retake the captures it names before sending the set:"
            echo "  $0 $OUT --redo"
            exit 1
        }
    fi
fi
