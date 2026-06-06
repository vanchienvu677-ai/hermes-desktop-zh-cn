#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

check_release_update() {
  if [ "${HERMES_ZH_SKIP_UPDATE_CHECK:-0}" = "1" ]; then
    return
  fi

  /usr/bin/python3 - "$DIR/resources/release.json" 2>/dev/null <<'PY' || true
import json
import re
import sys
import urllib.request

metadata_path = sys.argv[1]
with open(metadata_path, "r", encoding="utf-8") as f:
    metadata = json.load(f)

repo = metadata["repo"]
current = str(metadata["release"])
request = urllib.request.Request(
    f"https://api.github.com/repos/{repo}/releases/latest",
    headers={
        "Accept": "application/vnd.github+json",
        "User-Agent": "hermes-desktop-zh-cn-update-check",
    },
)
with urllib.request.urlopen(request, timeout=5) as response:
    latest = str(json.load(response)["tag_name"])

def version_key(value: str) -> list[int]:
    return [int(part) for part in re.findall(r"\d+", value)]

if version_key(latest) > version_key(current):
    print(f"检测到新版中文补丁 {latest}，当前版本为 {current}。建议先更新本项目。")
PY
}

check_release_update

echo "Hermes Desktop 中文补丁"
echo "目录: $DIR"
echo
echo "请选择操作："
echo "  [1] 安装 / 重新应用中文补丁"
echo "  [2] 恢复最近一次汉化前备份"
echo "  [3] 打开项目说明"
echo "  [4] 退出"
echo
read -rp "请输入选项 [1/2/3/4，默认 1]: " choice

case "${choice:-1}" in
  2)
    "$DIR/scripts/restore-macos.sh"
    ;;
  3)
    open "$DIR/README.md"
    ;;
  4)
    exit 0
    ;;
  *)
    "$DIR/scripts/apply-macos.sh"
    ;;
esac

echo
echo "完成。按回车退出。"
read -r _

