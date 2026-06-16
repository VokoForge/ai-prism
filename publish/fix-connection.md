# Wechatsync 连接问题修复

## 当前错误
```
连接超时: 已有实例正在运行但 Chrome Extension 未连接
请确保 Chrome 扩展已启用「同步桥接」并且 Token 正确
```

## 解决步骤

### 1. 在浏览器扩展中启用「同步桥接」

1. 点击 Chrome/Edge 右上角的 Wechatsync 扩展图标
2. 进入「设置」或「高级设置」
3. 找到「同步桥接」或「MCP 连接」选项
4. **启用开关**
5. 复制显示的 Token（应该与您的 Token 一致：`7f7393c4-11af-45c2-aa2f-ad6f8e6e3202`）

### 2. 确认扩展已连接

在扩展面板中应该看到：
- ✅ 同步桥接：已启用
- ✅ 连接状态：已连接
- ✅ Token：显示正确

### 3. 重新运行发布命令

```bash
cd github-trending-articles-2026

# 文章1：OpenClaw
WECHATSYNC_TOKEN="7f7393c4-11af-45c2-aa2f-ad6f8e6e3202" wechatsync sync \
  publish/article11/wechat/openclaw-wechat.md \
  -p "wechat,zhihu,juejin,weibo,toutiao,csdn" \
  --title "248K Star！黄仁勋说它是'下一个Linux'，60天刷新GitHub纪录！" \
  --cover article11/images/cover.png

# 文章2：System Prompts Leaks
WECHATSYNC_TOKEN="7f7393c4-11af-45c2-aa2f-ad6f8e6e3202" wechatsync sync \
  publish/article15/wechat/prompts-leak-wechat.md \
  -p "wechat,zhihu,juejin,weibo,toutiao,csdn" \
  --title "20K Star！撕开AI的遮羞布，所有大模型的'底层剧本'全泄露！" \
  --cover article15/images/cover.png
```

### 4. 如果仍有问题

尝试重启扩展：
1. 右键点击扩展图标 → 「管理扩展程序」
2. 关闭扩展开关，等待 3 秒
3. 重新打开扩展开关
4. 再次启用「同步桥接」
5. 重新运行命令

## 备选：使用 Playwright 自动化

如果 Wechatsync 连接问题无法解决，可以使用浏览器自动化脚本：

```bash
cd github-trending-articles-2026/publish
npm install playwright
npx playwright install chromium
node auto-publish-browser.js
```

此脚本会：
1. 打开可视化浏览器窗口
2. 自动跳转到各平台发布页面
3. 自动填写标题、正文、上传封面图
4. 您只需手动登录各平台（首次）
