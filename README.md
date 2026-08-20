# DSH Native Session Split

为 [DeepSeek Harness](https://github.com/deepseek-ai/deepseek-harness) 提供 VS Code 风格的完整会话分屏补丁。

```text
侧边栏 | 主会话 A | 完整会话 B
```

这是 **DSH 源码补丁**，不是简化消息预览热插件。它复用 DSH 既有的完整 `conversation` 渲染树，因此右侧会话拥有与主会话一致的会话头、消息与 Markdown、工具卡、输入框、审批、主题、滚动和逐会话状态。

## 功能

- 在非空白会话的 `…` 菜单新增 **分屏会话**。
- 点击后将该会话固定在主会话右侧。
- 主会话的全局导航不变；右栏拥有独立会话状态。
- 再次选择同一会话或点击右栏关闭按钮可关闭分屏。
- 分屏状态不持久化，刷新后回到单会话布局。
- 窗口宽度小于 920px 时自动隐藏右栏，避免压缩主会话。

## 兼容性

当前补丁基于 DeepSeek Harness 源码 revision：

```text
99f6f02fecdb7dff40c3fbc9470f5907c29f74ca
```

其他 revision 可能无法直接应用。请先运行 `scripts/check.sh`；若失败，请基于新的 DSH 版本 rebase `patches/dsh-native-session-split.patch`。

## 安装

### 1. 获取 DSH 源码

```bash
git clone https://github.com/deepseek-ai/deepseek-harness.git
cd deepseek-harness
git checkout 99f6f02fecdb7dff40c3fbc9470f5907c29f74ca
pnpm install
```

### 2. 获取本项目并检查补丁

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL> dsh-native-session-split
./dsh-native-session-split/scripts/check.sh .
```

### 3. 应用补丁

```bash
./dsh-native-session-split/scripts/apply.sh .
```

脚本要求目标 DSH checkout 的工作树干净；它会先执行 `git apply --check`，然后应用补丁。

### 4. 构建

```bash
pnpm run build:lib:host
pnpm run build:lib:client
pnpm --filter @deepseek-ai/dsh-web-frontend build
```

### 5. 启动或部署

开发环境：

```bash
pnpm dsh --profile web
```

如果使用 systemd，服务必须运行这个已打补丁的 checkout 或由它构建出的发布版本。仅重启另一个 npx / npm 安装的 `dsh web` 不会加载补丁。

一个源码部署服务的 `ExecStart` 示例：

```ini
[Service]
WorkingDirectory=/absolute/path/to/deepseek-harness
ExecStart=
ExecStart=/path/to/node --import tsx/esm /absolute/path/to/deepseek-harness/apps/cli/src/bin.ts web
```

修改 systemd 后执行：

```bash
sudo systemctl daemon-reload
sudo systemctl restart dsh-web
```

## 使用

1. 打开一个已有内容的会话。
2. 在左侧会话列表点击该会话的 `…`。
3. 选择 **分屏会话**。
4. 右侧显示该会话的完整原生 DSH 会话页面。
5. 点击右侧关闭按钮，或再次为同一会话选择 **分屏会话**，关闭右栏。

## 卸载

```bash
./dsh-native-session-split/scripts/unapply.sh /path/to/deepseek-harness
```

卸载后重新执行构建步骤，再重启实际提供 Web UI 的 DSH 服务。

## 验证

在应用补丁的 DSH checkout 中运行：

```bash
pnpm vitest run \
  packages/client/ui-layout/tests/apply.client.spec.ts \
  packages/client/ui-layout/tests/layout-store.client.spec.ts \
  packages/client/ui-layout/tests/service.client.spec.ts \
  packages/client/ui-layout/tests/app-frame.client.spec.tsx \
  packages/client/ui-workspace/tests/apply.client.spec.ts \
  packages/client/ui-workspace/tests/rows.client.spec.tsx \
  packages/client/ui-workspace/tests/workspace-browser.client.spec.tsx \
  packages/client/runtime/tests/sessions-service.client.spec.ts \
  packages/client/runtime/tests/slots-service.client.spec.ts \
  packages/client/web-react/tests/scoped-slots.client.spec.tsx
```

本补丁开发时，上述分屏相关测试共覆盖菜单、session 路由、第二栏绑定、关闭、布局以及完整 conversation Slot 复用。

## 项目结构

```text
.
├── AGENTS.md
├── LICENSE
├── README.md
├── patches/
│   └── dsh-native-session-split.patch
└── scripts/
    ├── apply.sh
    ├── check.sh
    └── unapply.sh
```

## 许可证

MIT。DeepSeek Harness 本身遵循其上游仓库的许可证和发布规则。
