<!-- managed-by: agent-rules -->
<!-- source-repo: https://github.com/1008k/agent-rules -->
<!-- source-path: docs/integrations/modern-web-guidance.md -->
# Modern Web Guidance

Chrome for Developers の `Modern Web Guidance` を、ブラウザ向けプロジェクトで最新のWeb実践を確認するための導入候補として扱うメモです。
このテンプレートでは常設必須にはせず、Web UI を持つ案件で必要性が見えた段階で検討します。

## 何に効くか
- アクセシビリティ、パフォーマンス、セキュリティを、機能実装と切り離さずに判断しやすくする
- `dialog`、Popover API、container queries など、現代的なWeb Platform機能を使うかどうかの比較材料にする
- 新規UIの設計、レガシーUIのモダナイズ、LCP や INP の改善、CSP や WebAuthn まわりの初期検討を早める
- AIエージェントに「最新のWebのベストプラクティスを前提に考えてほしい」ときの共通入口にする

## このテンプレートでの位置づけ
- 正本の仕様は `docs/project-spec.md` に残す
- 実装判断の既定は `docs/rules-coding.md` と `docs/rules-ux.md` に最小限だけ反映する
- この文書は、導入の要否、使いどころ、外部参照先を整理する補助文書として扱う

## 推奨度
- `推奨`: ユーザー向けWeb UIがあり、アクセシビリティや性能を継続的に気にする案件
- `任意`: 管理画面、社内ツール、静的サイトなどで、複雑なUIは少ないが最新の実践を参照したい案件
- `不要`: Web UI を持たない CLI、ライブラリ、バックエンド専用プロジェクト

## 導入タイミング
- 画面要件が見え始めたとき
- UI実装前に、標準機能で置き換えられる箇所を洗いたいとき
- パフォーマンス、アクセシビリティ、セキュリティ改善をまとめて見直したいとき

## 判断軸
- 効果: 独自実装を減らし、最新のWeb実践に沿った判断をしやすくなるか
- 適用条件: 対象がブラウザ向けUIか、主要導線の体験品質を継続的に見たいか
- コスト: 外部ドキュメント参照や追加の確認フローを受け入れられるか
- 境界: 外部ドキュメント参照が前提であること、内容を無条件の命令ではなく観測として扱うこと

## 使い方の目安
- まず `docs/project-spec.md` で主要導線と非機能要件を固める
- 次に `docs/rules-ux.md` に沿って、ユーザー目標、主要状態、破綻してはいけない操作を確認する
- そのうえで、標準機能や最新のWeb APIで単純化できる箇所、LCP / INP / CSP などの改善観点にこのガイダンスを使う
- 実装後は、可能なら DevTools や Lighthouse などの実計測で仮説を確認する

## Codex での扱い
- 参照する場合も、プロジェクトの仕様、制約、対象ブラウザより優先しない
- 同じ観点を繰り返し使うようになったら、repo固有skill化やチェックリスト化を検討してよい
- 単なるリンク集にはせず、この文書か `docs/tracks/` に「どの観点を採用したか」を短く残す

## 参考
- Chrome for Developers: [Modern Web Guidance](https://developer.chrome.com/docs/modern-web-guidance?hl=ja)
