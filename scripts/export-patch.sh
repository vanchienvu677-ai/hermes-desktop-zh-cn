#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HERMES_REPO="${HERMES_REPO:-$HOME/.hermes/hermes-agent}"
VERSION="${HERMES_VERSION:-0.15.1}"
PATCH_FILE="$ROOT_DIR/patches/hermes-desktop-${VERSION}-zh-cn.patch"

if [ ! -d "$HERMES_REPO/.git" ]; then
  echo "Hermes source repo not found: $HERMES_REPO" >&2
  exit 1
fi

mkdir -p "$ROOT_DIR/patches"
git -C "$HERMES_REPO" diff -- apps/desktop > "$PATCH_FILE"

if [ ! -s "$PATCH_FILE" ]; then
  echo "No desktop changes were found. Patch was not updated." >&2
  rm -f "$PATCH_FILE"
  exit 1
fi

echo "Exported patch: $PATCH_FILE"

