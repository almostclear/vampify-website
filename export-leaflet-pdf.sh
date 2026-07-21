#!/usr/bin/env bash
# Export the A5 leaflet to a print-quality PDF (vector text, no browser UI).
# Usage: ./export-leaflet-pdf.sh  ->  writes leaflet.pdf next to this script.
set -euo pipefail

cd "$(dirname "$0")"

# Find a Chromium-based browser (WSL-native first, then Windows side)
find_browser() {
  local c
  for c in google-chrome chromium chromium-browser; do
    if command -v "$c" >/dev/null 2>&1; then
      command -v "$c"
      return 0
    fi
  done
  local p
  for p in \
    "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" \
    "/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" \
    "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
    "/mnt/c/Program Files/Microsoft/Edge/Application/msedge.exe"; do
    if [ -x "$p" ]; then
      echo "$p"
      return 0
    fi
  done
  return 1
}

BROWSER="$(find_browser)" || { echo "No Chrome/Edge found."; exit 1; }
echo "Using: $BROWSER"

if [[ "$BROWSER" == /mnt/c/* ]]; then
  # Windows browser can't read WSL paths reliably: stage in Windows temp
  WINTMP_WSL="$(wslpath "$(cmd.exe /c 'echo %TEMP%' 2>/dev/null | tr -d '\r')")"
  STAGE="$WINTMP_WSL/vampify-leaflet"
  rm -rf "$STAGE"
  mkdir -p "$STAGE/assets"
  cp leaflet-palette.html "$STAGE/"
  cp assets/vampify-transparent.png assets/vampify-small-transparent.png "$STAGE/assets/"
  STAGE_WIN="$(wslpath -w "$STAGE")"
  "$BROWSER" --headless --disable-gpu --no-pdf-header-footer \
    --virtual-time-budget=10000 \
    --print-to-pdf="$STAGE_WIN\\leaflet.pdf" \
    "file:///$(echo "$STAGE_WIN" | sed 's|\\|/|g')/leaflet-palette.html"
  cp "$STAGE/leaflet.pdf" ./leaflet.pdf
else
  "$BROWSER" --headless --disable-gpu --no-pdf-header-footer \
    --virtual-time-budget=10000 \
    --print-to-pdf="$PWD/leaflet.pdf" \
    "file://$PWD/leaflet-palette.html"
fi

echo "Wrote $(pwd)/leaflet.pdf"
echo "Print it at 100% scale (actual size), A5, double-sided, flip on long edge."
