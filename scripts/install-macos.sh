#!/usr/bin/env bash
# Install the newest Ghidra zip from output/ into a folder (default: ~/Applications).
# Usage: scripts/install-macos.sh [dest_dir]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${1:-$HOME/Applications}"

ZIP="$(ls -t "$ROOT"/output/ghidra_*_mac_arm_64.zip 2>/dev/null | head -1)"
[[ -n "$ZIP" ]] || { echo "No zip in output/. Run scripts/build-macos-arm64.sh first." >&2; exit 1; }

NAME="$(unzip -Z1 "$ZIP" | awk -F/ 'NR==1{print $1}')"   # read all input: head would SIGPIPE unzip under pipefail
TARGET="$DEST/$NAME"
[[ ! -e "$TARGET" ]] || { echo "$TARGET already exists; remove it first." >&2; exit 1; }

mkdir -p "$DEST"
unzip -q "$ZIP" -d "$DEST"
xattr -dr com.apple.quarantine "$TARGET" 2>/dev/null || true

echo "Installed to $TARGET"
echo "Launch with: \"$TARGET/ghidraRun\"   (requires JDK 25)"
