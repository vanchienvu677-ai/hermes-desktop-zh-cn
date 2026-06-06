#!/usr/bin/env bash
set -euo pipefail

HERMES_APP="${HERMES_APP:-/Applications/Hermes.app}"
APP_ASAR="$HERMES_APP/Contents/Resources/app.asar"
INFO_PLIST="$HERMES_APP/Contents/Info.plist"

fail() {
  echo "Error: $*" >&2
  exit 1
}

[ -d "$HERMES_APP" ] || fail "missing app: $HERMES_APP"
[ -f "$INFO_PLIST" ] || fail "missing Info.plist: $INFO_PLIST"

BACKUP="$(ls -t "$APP_ASAR".bak_zh_* 2>/dev/null | head -1 || true)"
[ -n "$BACKUP" ] || fail "no zh backup found beside app.asar"

echo "Restoring backup: $BACKUP"
cp "$BACKUP" "$APP_ASAR"

HASH="$(shasum -a 256 "$APP_ASAR" | awk '{print $1}')"
/usr/libexec/PlistBuddy -c "Set :ElectronAsarIntegrity:Resources/app.asar:hash $HASH" "$INFO_PLIST"

codesign --force --deep --sign - "$HERMES_APP" >/dev/null
codesign --verify --deep --strict "$HERMES_APP"
open -a "$HERMES_APP"

echo "Restored Hermes.app from $BACKUP"

