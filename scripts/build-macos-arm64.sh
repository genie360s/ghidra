#!/usr/bin/env bash
# Build Ghidra for macOS Apple Silicon (mac_arm_64) and copy the release zip to output/.
# Needs: JDK 25, Python 3.9-3.15 with pip, Xcode command line tools, internet (first run).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

[[ "$(uname -s)/$(uname -m)" == "Darwin/arm64" ]] || { echo "Must run on an Apple Silicon Mac." >&2; exit 1; }
export JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home -v 25)}"

./gradlew -I gradle/support/fetchDependencies.gradle
./gradlew buildGhidra   # builds natives for the host platform only

# Gradle names the zip ghidra_<ver>_DEV_<date>.zip; tag it with the platform it was built for.
ZIP="$(ls -t build/dist/ghidra_*.zip | head -1)"
OUT="output/$(basename "$ZIP" .zip)_mac_arm_64.zip"
mkdir -p output
cp "$ZIP" "$OUT"
echo "Built: $OUT"
