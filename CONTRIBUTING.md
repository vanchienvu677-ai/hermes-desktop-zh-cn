# 贡献指南

感谢你愿意改进 Hermes Desktop 中文补丁。

## 基本原则

- 不提交 Hermes 官方安装包、`app.asar`、构建产物或完整上游源码。
- 不提交 `.env`、API Key、token、cookie、私钥或个人配置。
- 保留 Hermes、Nous Research、模型 ID、Provider ID、环境变量和命令名等技术标识。
- 优先翻译用户可见界面，不改动业务逻辑和运行协议。

## 开发流程

1. 安装官方 Hermes Desktop。
2. 准备本机 Hermes 源码目录，默认路径为 `~/.hermes/hermes-agent`。
3. 在 `apps/desktop` 中修改中文文案。
4. 构建并运行官方桌面端验证。
5. 回到本项目导出 patch：

```bash
./scripts/export-patch.sh
```

6. 更新 README 中的适配版本、汉化范围和验证说明。

## 提交前检查

```bash
bash -n scripts/apply-macos.sh
bash -n scripts/export-patch.sh
find . -type f \( -name '*.asar' -o -name '.env' -o -name '*.key' -o -name '*.pem' -o -name '*.p12' \) -print
```

最后一条命令应没有输出。

