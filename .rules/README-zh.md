# Continue 代理与规则

此仓库使用具有严格作用域和可重用规则的本地 Continue 代理。

- 代理位于 `.continue/agents/*.yaml`，可在 Continue 面板中选择。
- 规则位于 `.continue/rules/*.yaml`，通过 `rules: - uses: repo/<name>` 被代理导入。
- 如果代理未出现，请在代理选择器中点击"重新加载配置"。

提升迁移的流水线工作流程：

1. DeepSeek — 提升脚手架：创建 `lifted/<fn>/index.ts` + `index.test.ts`。
2. DeepSeek — 测试审查员：仅改进测试的正确性和覆盖率。
3. DeepSeek — 导入与分组：修复导入分组/顺序和空行。
4. DeepSeek — 使者注释修复器：添加/修正使者注释（仅注释）。
5. DeepSeek — 单子实现器：实现严格的 FP 单子版本以通过测试（不编辑测试）。
6. DeepSeek — 最终审查员：进行小型外科修复以通过所有关卡。

防护栏：

- 每个代理在其 YAML 规则中列出明确的允许/禁止更改；保持在作用域内。
- 预提交钩子仍然是硬关卡（契约、FP 检查、测试、格式化、类型、别名策略、覆盖率忽略审计）。

提示：

- 保持提示简短并包含要更改的确切文件夹。
- 使用前一步的简短"交接"摘要作为下一个代理的起始提示。

## 使用工作树与云代理

您可以将特定步骤卸载到云模型（Anthropic/OpenAI），而主工作树使用本地 DeepSeek：

- 提供的云代理变体：
  - `Claude — 导入与分组`
  - `Claude — 最终审查员`
  - `GPT — 测试审查员`
- 在 `.continue/config.json` 中为匹配的提供商添加您的 API 密钥。

### API 密钥（Anthropic/OpenAI）

- Anthropic：单个 Anthropic API 密钥适用于您账户/区域中的所有 Anthropic 模型。您可以对下面的 Sonnet 和 Opus 条目使用相同的密钥。
  - 在 `.continue/config.json` 中定义的模型：
    - `Claude Opus 4.1 (Anthropic)` → `claude-opus-4.1`
    - `Claude Sonnet 4 (Anthropic)` → `claude-sonnet-4`
  - 将您的 Anthropic 密钥粘贴到每个模型的 `apiKey` 字段中，或设置 `ANTHROPIC_API_KEY` 环境变量（如果支持，Continue 将自动获取）。
- OpenAI：将您的 OpenAI 密钥粘贴到 `GPT-5 (OpenAI)` 模型的 `apiKey` 字段中，或设置 `OPENAI_API_KEY`。

### 防护栏使用与切换

- 所有云代理现在首先包含 `repo/stable-header` 和 `repo/guardrails` 以增加缓存命中率并强制执行安全作用域。
- 要临时禁用防护栏进行实验，请注释掉特定代理 YAML 中的 `- uses: repo/guardrails` 行；最好创建单独的 "-experimental" 代理而不是编辑主代理。
- 如果您修改了防护栏文本，请添加新的版本文件（例如 `guardrails-v2.yaml`）以保留现有代理的缓存。

## 故障排除

### 禁用内联"幽灵文本"建议

- Continue 制表符自动完成：在 `.continue/config.json` 中移除（无 `tabAutocompleteModel`）。
- VS Code：设置 `"editor.inlineSuggest.enabled": false`（我们在 `.vscode/settings.json` 中设置了此项）。
- Copilot（如果已安装）：在工作区设置中设置 `"github.copilot.inlineSuggest.enable": false`。
- 其他提供商（如果已安装）：
  - Codeium：禁用或在工作区设置中设置 `"codeium.enable_search": false`。
  - TabNine：禁用内联功能，例如 `"tabnine.experimentalAutoImports": false`。

如果建议仍然存在，请运行"开发者：显示运行扩展"并临时禁用可能的来源以隔离问题。

- 运行 `deno run -A scripts/setupWorktrees/syncContinueConfig.ts` 将 `.continue` 复制到每个工作树并设置钩子。
- 使用一个工作树（例如 `ai/toolsmith`）与本地 DeepSeek 代理，并为其他工作树分配作用域明确的并行任务，使用云代理（仅导入、仅测试或最终审查员）。保持作用域紧凑以减少冲突。

集成指导：

- 在每个工作树中优先使用相同的微代理流水线；避免重叠作用域。
- 让主工作树执行"单子实现器"步骤以保持核心逻辑集中化。
- 使用现有的 `integrate` 任务将已完成的工作树串行合并回 `main`。

### 脚本文件夹重构（Claude 流水线）

按顺序运行这些代理，针对 `scripts/` 使用小型、文件/文件夹作用域的提示：

1) Claude — 脚本重构步骤 1：提取命名函数
2) Claude — 脚本重构步骤 2：提取常量与类型
3) Claude — 脚本重构步骤 3：测试通过与覆盖
4) Claude — 脚本重构步骤 4：样式清理
5) Claude — 脚本重构步骤 5：使者注释

说明：

- 步骤 1 将创建子文件夹（每个文件夹一个函数）并用命名的默认导出替换内联 lambda，将共享的帮助函数放在最低公共祖先。
- 步骤 2 将常量/类型移动到 `constants/index.ts` 和 `types/index.ts` 作为命名导出。
- 步骤 3-5 对生产逻辑是只读的（分别仅测试、仅样式、仅注释）。

## GPT API 成本估算器

使用内置估算器预测每月支出（美元/新西兰元）：

- 基础（您的费率）：

  ```sh
  deno task estimate:gpt -- --in-rate 1.25 --out-rate 10 --light 30 --medium 10 --heavy 2 --fx 1.7
  ```

- 使用提示缓存（示例：70% 缓存，0.125 美元/M）：

  ```sh
  deno task estimate:gpt -- --in-rate 1.25 --out-rate 10 --cached-in-rate 0.125 --cached-in-share 0.7 --light 30 --medium 10 --heavy 2 --fx 1.7
  ```

- 估算器假设每次运行的 token 占用：轻量=20K/2K，中等=60K/6K，重度=150K/12K（输入/输出）。

### 提示缓存说明

- 新的规则块 `repo/stable-header` 首先包含在云代理中以最大化缓存命中。保持字节完全相同。
- 如果更改了标题文本，请创建新的版本文件而不是编辑现有文件，以保持缓存有效性。
- 在估算器中，使用 `--cached-in-rate` 和 `--cached-in-share` 来模拟节省；如果不确定，请将份额设置为 0。
