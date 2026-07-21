#!/usr/bin/env bash
# Export a print HTML to a print-quality PDF (vector text + QR, no browser UI).
# Usage:
#   ./export-pdf.sh leaflet   -> leaflet.pdf  (from leaflet-palette.html)
#   ./export-pdf.sh card      -> card.pdf     (from card.html)
#   ./export-pdf.sh           -> both
set -euo pipefail

cd "$(dirname "$0")"

find_browser() {
  local c
  for c in google-chrome chromium chromium-browser; do
    if command -v "$c" >/dev/null 2>&1; then command -v "$c"; return 0; fi
  done
  local p
  for p in \
    "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" \
    "/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" \
    "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
    "/mnt/c/Program Files/Microsoft/Edge/Application/msedge.exe"; do
    if [ -x "$p" ]; then echo "$p"; return 0; fi
  done
  return 1
}

render() {
  local html="$1" pdf="$2"
  local browser
  browser="$(find_browser)" || { echo "No Chrome/Edge found."; exit 1; }

  if [[ "$browser" == /mnt/c/* ]]; then
    # Windows browser can't read WSL paths: stage in Windows temp with assets
    local wintmp stage stage_win
    wintmp="$(wslpath "$(cmd.exe /c 'echo %TEMP%' 2>/dev/null | tr -d '\r')")"
    stage="$wintmp/vampify-print"
    rm -rf "$stage"; mkdir -p "$stage/assets"
    cp "$html" "$stage/"
    cp assets/*.png assets/*.jpg assets/*.svg "$stage/assets/" 2>/dev/null || true
    stage_win="$(wslpath -w "$stage")"
    "$browser" --headless --disable-gpu --no-pdf-header-footer \
      --virtual-time-budget=10000 \
      --print-to-pdf="$stage_win\\out.pdf" \
      "file:///$(echo "$stage_win" | sed 's|\\|/|g')/$html"
    cp "$stage/out.pdf" "./$pdf"
  else
    "$browser" --headless --disable-gpu --no-pdf-header-footer \
      --virtual-time-budget=10000 \
      --print-to-pdf="$PWD/$pdf" "file://$PWD/$html"
  fi
  echo "Wrote $(pwd)/$pdf"
}

target="${1:-both}"
case "$target" in
  leaflet) render leaflet-palette.html leaflet.pdf ;;
  card)    render card.html card.pdf ;;
  both)    render leaflet-palette.html leaflet.pdf; render card.html card.pdf ;;
  *) echo "Usage: ./export-pdf.sh [leaflet|card|both]"; exit 1 ;;
esac

echo "Print at 100% scale (actual size). Cards: 85x55mm, double-sided."
