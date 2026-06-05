# 升级后重新汉化

Hermes Desktop 升级后，官方安装包通常会覆盖 `/Applications/Hermes.app/Contents/Resources/app.asar`，因此中文补丁需要重新应用。

## 推荐流程

1. 先安装或升级官方 Hermes Desktop。
2. 打开 Hermes 一次，确认官方版本可以正常启动。
3. 关闭 Hermes。
4. 回到本项目目录重新运行：

```bash
./scripts/apply-macos.sh
```

## 如果补丁失败

补丁失败通常说明官方新版本的源码结构或文案发生了变化。

处理方式：

1. 更新本机 Hermes 源码目录。
2. 查看失败文件，手工合并中文文案。
3. 构建并验证桌面端。
4. 运行 `./scripts/export-patch.sh` 导出新版本补丁。
5. 把新补丁命名为类似 `hermes-desktop-0.15.2-zh-cn.patch`。

## 版本策略

- `patches/hermes-desktop-0.15.1-zh-cn.patch` 只承诺适配 Hermes Desktop `0.15.1`。
- 新官方版本应新增 patch 文件，不直接覆盖旧 patch。
- README 里的适配版本要同步更新。

