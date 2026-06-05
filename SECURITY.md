# 安全说明

本项目只提供 Hermes Desktop 中文补丁、脚本和文档，不应包含任何私有凭据或官方二进制产物。

## 请不要公开提交

- `.env`
- API Key、token、cookie
- 私钥、证书、签名材料
- `app.asar`
- `.dmg`、`.zip`、`.app` 等官方或重打包产物
- 个人聊天记录、客户资料或本地配置

## 报告问题

如果发现补丁脚本可能泄露凭据、错误修改系统文件、破坏官方应用签名校验，或引入不必要的远程下载行为，请优先用私密渠道联系维护者。

## 脚本边界

`scripts/apply-macos.sh` 只应修改：

- 本机 Hermes 源码目录中的桌面端源码
- `/Applications/Hermes.app/Contents/Resources/app.asar`
- `/Applications/Hermes.app/Contents/Info.plist` 中的 `ElectronAsarIntegrity`
- `/Applications/Hermes.app` 的本地代码签名

