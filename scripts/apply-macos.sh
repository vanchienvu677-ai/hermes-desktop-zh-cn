#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HERMES_APP="${HERMES_APP:-/Applications/Hermes.app}"
HERMES_REPO="${HERMES_REPO:-$HOME/.hermes/hermes-agent}"
VERSION="${HERMES_VERSION:-0.15.1}"
PATCH_FILE="${PATCH_FILE:-$ROOT_DIR/patches/hermes-desktop-${VERSION}-zh-cn.patch}"
ASAR_BIN="${ASAR_BIN:-$HOME/.hermes/tools/asar/node_modules/.bin/asar}"

APP_ASAR="$HERMES_APP/Contents/Resources/app.asar"
INFO_PLIST="$HERMES_APP/Contents/Info.plist"
DESKTOP_DIR="$HERMES_REPO/apps/desktop"

fail() {
  echo "Error: $*" >&2
  exit 1
}

need_file() {
  [ -f "$1" ] || fail "missing file: $1"
}

need_dir() {
  [ -d "$1" ] || fail "missing directory: $1"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "missing command: $1"
}

need_dir "$HERMES_APP"
need_file "$APP_ASAR"
need_file "$INFO_PLIST"
need_dir "$HERMES_REPO/.git"
need_dir "$DESKTOP_DIR"
need_file "$PATCH_FILE"
need_cmd git
need_cmd npm
need_cmd shasum
need_cmd plutil
need_cmd codesign

if [ ! -x "$ASAR_BIN" ]; then
  fail "asar CLI not found: $ASAR_BIN. Install it with: npm install --prefix $HOME/.hermes/tools/asar @electron/asar"
fi

APP_VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$INFO_PLIST" 2>/dev/null || true)"
if [ "$APP_VERSION" != "$VERSION" ]; then
  echo "Warning: installed Hermes version is $APP_VERSION, patch targets $VERSION." >&2
  echo "Continuing anyway. If patching fails, update the patch for this Hermes version." >&2
fi

echo "Applying zh-CN patch to Hermes source..."
if git -C "$HERMES_REPO" apply --check "$PATCH_FILE"; then
  git -C "$HERMES_REPO" apply "$PATCH_FILE"
else
  if git -C "$HERMES_REPO" apply --reverse --check "$PATCH_FILE"; then
    echo "Patch already appears to be applied; continuing."
  else
    fail "patch does not apply cleanly. Update the patch for this Hermes version."
  fi
fi

echo "Building Hermes Desktop..."
npm --prefix "$DESKTOP_DIR" run build

STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_ASAR="$APP_ASAR.bak_zh_$STAMP"
TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/hermes-zh-cn.XXXXXX")"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Backing up app.asar to $BACKUP_ASAR"
cp "$APP_ASAR" "$BACKUP_ASAR"

echo "Unpacking app.asar..."
"$ASAR_BIN" extract "$APP_ASAR" "$TMP_DIR/app"

echo "Writing localized build files..."
rm -rf "$TMP_DIR/app/dist" "$TMP_DIR/app/electron"
cp -R "$DESKTOP_DIR/dist" "$TMP_DIR/app/dist"
cp -R "$DESKTOP_DIR/electron" "$TMP_DIR/app/electron"
cp "$DESKTOP_DIR/package.json" "$TMP_DIR/app/package.json"

echo "Packing app.asar..."
"$ASAR_BIN" pack "$TMP_DIR/app" "$APP_ASAR"

HASH="$(shasum -a 256 "$APP_ASAR" | awk '{print $1}')"
echo "Updating ElectronAsarIntegrity hash..."
/usr/libexec/PlistBuddy -c "Set :ElectronAsarIntegrity:Resources/app.asar:hash $HASH" "$INFO_PLIST"

echo "Re-signing Hermes.app..."
codesign --force --deep --sign - "$HERMES_APP" >/dev/null
codesign --verify --deep --strict "$HERMES_APP"

echo "Launching Hermes..."
open -a "$HERMES_APP"

echo "Done. Backup: $BACKUP_ASAR"
