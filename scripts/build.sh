#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$ROOT_DIR/ApplePhotos.lrdevplugin"
BUILD_DIR="$ROOT_DIR/build"
STAGE_ROOT="$BUILD_DIR/stage"
PLUGIN_DIR_NAME="ApplePhotos.lrplugin"
PLUGIN_STAGE_DIR="$STAGE_ROOT/$PLUGIN_DIR_NAME"

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Source plugin folder not found: $SRC_DIR" >&2
  exit 1
fi

# Read semantic version from Info.lua VERSION table.
major="$(sed -nE "s/.*major=([0-9]+).*/\1/p" "$SRC_DIR/Info.lua" | head -n1)"
minor="$(sed -nE "s/.*minor=([0-9]+).*/\1/p" "$SRC_DIR/Info.lua" | head -n1)"
revision="$(sed -nE "s/.*revision=([0-9]+).*/\1/p" "$SRC_DIR/Info.lua" | head -n1)"

if [[ -z "$major" || -z "$minor" || -z "$revision" ]]; then
  echo "Could not parse version from $SRC_DIR/Info.lua" >&2
  exit 1
fi

version="$major.$minor.$revision"
zip_name="ApplePhotos-$version.lrplugin.zip"
zip_path="$BUILD_DIR/$zip_name"

rm -rf "$STAGE_ROOT"
mkdir -p "$PLUGIN_STAGE_DIR"

# Copy plugin files while excluding macOS metadata artifacts.
rsync -a --exclude '.DS_Store' "$SRC_DIR/" "$PLUGIN_STAGE_DIR/"

rm -f "$zip_path"
(
  cd "$STAGE_ROOT"
  zip -rq "$zip_path" "$PLUGIN_DIR_NAME"
)

# Keep a direct-install folder in build/ and remove staging leftovers.
rm -rf "$BUILD_DIR/$PLUGIN_DIR_NAME"
mv "$PLUGIN_STAGE_DIR" "$BUILD_DIR/$PLUGIN_DIR_NAME"
rm -rf "$STAGE_ROOT"

echo "Build complete"
echo "Plugin folder: $BUILD_DIR/$PLUGIN_DIR_NAME"
echo "Zip archive: $zip_path"
