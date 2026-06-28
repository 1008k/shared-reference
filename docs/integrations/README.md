<!-- managed-by: agent-rules -->
<!-- source-repo: https://github.com/1008k/agent-rules -->
<!-- source-path: docs/integrations/README.md -->
# Integrations And Skills

このディレクトリは、拡張機能や補助運用を導入するかどうかを判断する入口です。
実装前に機械的に全部入れず、プロジェクトの方向が固まった段階で必要なものだけを選びます。

## いつ検討するか
- `docs/initial-brief.md` の未確定事項がある程度整理されたあと
- `docs/project-spec.md` の概要、非目的、技術方針が固まったあと
- 実装着手前または実装初期に、導入効果を判断できるタイミング

## 何を検討するか
- MCP
- GitHubや外部ドキュメント参照の補助
- 軽量メモリ
- 自前Skillやエージェント補助資産
- 補助的な運用ルールや導入手順

## 判断軸
- 効果: 何が速くなるか、何のミスが減るか
- 適用条件: どの種類のプロジェクトで有効か
- コスト: セットアップ、保守、依存、学習コスト
- 境界: 権限、外部通信、監査、セキュリティ影響

## エージェントへの依頼例
- このプロジェクトで導入候補の拡張を挙げて
- 各候補を `推奨 / 任意 / 不要` で分類して
- 理由、前提条件、外部通信、採用時の記録先を示して

## 既存メモ
- `mcp-baseline.md`: 汎用案件で最初に検討しやすい基本MCP
- `context-tools.md`: Serena / Context7 / Headroom / Context Mode などのコンテキスト削減系ツールを試すための補助メモ
- `gitmcp.md`: 外部GitHubリポジトリや文書参照の補助
- `modern-web-guidance.md`: ブラウザ向けUI案件で、最新のWeb Platform実践を参照する導入候補
- `okf.md`: MarkdownとYAML frontmatterで知識カタログを作る任意フォーマット候補
- Markdown 文書が増えて横断参照のコストが目立ってきたら、`markdown-query` のような局所検索系skillの導入を検討する
- `openmemory-lite.md`: 軽量なローカルメモリ拡張
- `skills.md`: 常時ルール、パス限定ルール、skill、subagent、hook、automation、MCPの切り分け
- `web-a11y-review.md`: Webアクセシビリティレビューskillの導入判断と適用範囲
