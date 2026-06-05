# Hermes Desktop 中文补丁

这是一个面向 **官方 Hermes Desktop** 的非官方中文补丁项目。

项目目标是把官方桌面端的主要可见界面汉化，同时尽量保持官方应用本体、品牌名、模型 ID、环境变量名、命令名和技术标识不变。

## 当前状态

- 适配版本：Hermes Desktop `0.15.1`
- 支持平台：macOS 已实测
- 补丁文件：`patches/hermes-desktop-0.15.1-zh-cn.patch`
- 安装方式：基于本机官方 Hermes 源码构建后写回 `/Applications/Hermes.app`
- 验证结果：本机已验证侧边栏、设置页、语音页、主界面欢迎文案、状态栏为中文

## 重要说明

本项目不分发 Hermes 官方安装包、`app.asar`、私有配置或 API Key。你需要先从官方渠道安装 Hermes Desktop，再在本机应用补丁。

升级 Hermes 后，官方应用会覆盖 `app.asar`，需要重新应用本项目补丁。详见 [升级后重新汉化](docs/UPGRADE.md)。

## 快速使用

默认路径适用于 macOS：

```bash
cd hermes-desktop-zh-cn
./scripts/apply-macos.sh
```

脚本会做这些事：

1. 检查 `/Applications/Hermes.app`
2. 检查本机 Hermes 源码目录，默认 `~/.hermes/hermes-agent`
3. 应用中文补丁
4. 构建桌面端
5. 备份当前 `app.asar`
6. 写回构建后的中文资源
7. 更新 `ElectronAsarIntegrity` 哈希
8. 重新签名并启动 Hermes

如果你的路径不同：

```bash
HERMES_APP="/Applications/Hermes.app" \
HERMES_REPO="$HOME/.hermes/hermes-agent" \
./scripts/apply-macos.sh
```

## 项目结构

```text
hermes-desktop-zh-cn/
├── patches/
│   └── hermes-desktop-0.15.1-zh-cn.patch
├── scripts/
│   ├── apply-macos.sh
│   └── export-patch.sh
├── docs/
│   ├── UPGRADE.md
│   └── VERIFY.md
├── LICENSE
├── NOTICE
└── README.md
```

## 汉化范围

已覆盖的主要区域：

- 欢迎页与首次启动引导
- 聊天输入区、上下文菜单、附件和语音相关提示
- 侧边栏、会话菜单、文件预览和右侧面板
- 设置页、模型页、Provider、MCP、Gateway、会话与外观设置
- 命令面板、任务计划、消息接入、Profiles、Artifacts、Skills
- 工具调用、审批、错误提示、通知和状态栏

保留英文的内容：

- Hermes、Nous Research 等品牌名
- 模型 ID、Provider ID、环境变量、命令、文件路径
- 开发者协议、日志字段、内部枚举值

## 开发

从当前本机改动重新导出 patch：

```bash
./scripts/export-patch.sh
```

导出前请确认 `~/.hermes/hermes-agent/apps/desktop` 里只包含你想公开的中文补丁改动。

## 许可证

本项目的脚本和文档使用 MIT License。

Hermes 官方项目本身由 Nous Research 维护并使用 MIT License。详见 `NOTICE`。本项目不是 Nous Research 官方项目。

