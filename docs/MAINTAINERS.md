# 维护说明

这个仓库按“补丁项目”维护，不直接分发官方 Hermes Desktop。

## 每次 Hermes 官方升级后

1. 安装官方新版 Hermes Desktop。
2. 更新本机 Hermes 源码。
3. 在 `apps/desktop` 中重新合并中文文案。
4. 构建并验证可见界面。
5. 运行：

```bash
HERMES_VERSION=新版本号 ./scripts/export-patch.sh
```

6. 更新 `README.md`、`docs/UPGRADE.md` 和 `CHANGELOG.md`。
7. 提交并推送。

## 每次提交前

```bash
bash -n scripts/apply-macos.sh
bash -n scripts/export-patch.sh
bash -n scripts/restore-macos.sh
find . -type f \( -name '*.asar' -o -name '.env' -o -name '*.key' -o -name '*.pem' -o -name '*.p12' -o -name '*.dmg' -o -name '*.zip' \) -print
```

最后一条命令应没有输出。

## 自动化

- `CI`：每次 push 和 PR 检查脚本、补丁、敏感文件和明显密钥。
- `Maintenance`：每周检查仓库结构，并确认官方 Hermes Desktop 页面可访问。
- `Pages`：发布 `docs/index.html` 作为项目页。
- Dependabot：每周检查 GitHub Actions 版本更新。
