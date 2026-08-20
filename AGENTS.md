# AGENTS.md

This repository distributes a source patch for the DeepSeek Harness native session split feature.

## Scope

- Keep the patch focused on one behavior: a sidebar Session-menu action opens one fixed, complete secondary conversation pane.
- The patch targets DeepSeek Harness source revision `99f6f02fecdb7dff40c3fbc9470f5907c29f74ca` unless `README.md` states a later compatible revision.
- Do not replace this feature with a dynamic Cordis overlay. A dynamic plugin cannot re-mount a second complete product session tree with the current public Client APIs.

## Patch maintenance

- Regenerate `patches/dsh-native-session-split.patch` from a clean DeepSeek Harness checkout after every implementation change.
- Include tracked modifications with `git diff --binary`; include new files using `git diff --binary --no-index /dev/null <path>`.
- Verify the patch applies with `git apply --whitespace=nowarn --check` against the documented target revision before publishing. The source patch preserves upstream Chinese prose whitespace in context lines.
- Do not include build outputs, `node_modules`, credentials, user profiles, or systemd files in the patch.

## Behavior requirements

- The sidebar Session `…` menu exposes **Split session** / **分屏会话** for non-blank sessions.
- Selecting an id opens that session's history without changing the primary selected session.
- The secondary pane renders the existing `conversation` Slot under the addressed session bundle. It therefore keeps the native header, messages, tool cards, composer, approvals, theme, and session-scoped state.
- The pane is fixed beside the primary conversation, closes from its control or a repeat selection, is transient, and hides below the documented narrow viewport threshold.

## Validation

Run from the patched DeepSeek Harness checkout:

```sh
pnpm run build:lib:host
pnpm run build:lib:client
pnpm --filter @deepseek-ai/dsh-web-frontend build
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

For systemd deployments, ensure `dsh-web.service` runs the patched checkout or a release built from it. Restarting an unrelated npx-installed DSH does not load this patch.
