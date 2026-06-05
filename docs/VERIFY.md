# 验证清单

应用补丁后建议检查以下内容。

## 应用状态

```bash
open -a Hermes
codesign --verify --deep --strict /Applications/Hermes.app
```

## 可见界面

- 首次启动或欢迎页显示中文。
- 左侧会话栏和会话操作菜单显示中文。
- 设置页导航和主要配置项显示中文。
- 模型、Provider、MCP、Gateway、会话、外观设置显示中文。
- 聊天输入区、附件、语音、工具调用和审批提示显示中文。
- 状态栏、更新提示、错误提示没有明显英文漏点。

## 命令验证

如果本机已配置 Hermes CLI 和模型：

```bash
hermes -z '只回复：OK'
```

预期输出：

```text
OK
```

