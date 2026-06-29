<!-- managed-by: agent-rules -->
<!-- source-repo: https://github.com/1008k/agent-rules -->
<!-- source-path: docs/integrations/web-a11y-review.md -->
# Web Accessibility Review Skill

このメモは、デジタル庁のウェブアクセシビリティ導入ガイドブックを参考にした、コーディングエージェント向けレビューskillの導入判断です。

## 位置付け

- 採用区分: 任意だが、Web UI、LP、記事、WordPressテーマ、React/Astroコンポーネントでは推奨。
- 共有skill正本: `.agents/skills/web-a11y-review/`
- プロジェクトへの同期先: `.shared/skills/web-a11y-review/`
- 参照元: デジタル庁「ウェブアクセシビリティ導入ガイドブック」2025年10月16日更新版 https://www.digital.go.jp/resources/introduction-to-web-accessibility-guidebook
- 目的: 公式資料の考え方を、実装レビュー、修正提案、納品前確認で使える観点に再構成する。

## 適用条件

- HTML/CSS/JavaScript、React、Astro、WordPressテーマなどのUIを扱う。
- フォーム、ナビゲーション、モーダル、タブ、アコーディオンなど操作を伴う部品を扱う。
- LP、ブログ記事、Markdown、CMS投稿など、内容の分かりやすさも品質に含めたい。
- 自動チェックだけでなく、キーボード操作、フォーカス、意味構造、代替情報、文言も確認したい。

## 境界

- このskillは正式なWCAG/JIS適合性評価や認証を行うものではない。
- PDF本文の長い転載は避け、実務向けの要約とレビュー観点として扱う。
- 常時読むルールにはせず、詳細が必要な作業でだけ読み込む。
- 外部通信は、公式資料や最新ツール仕様を確認する場合に限る。

## 保守

- デジタル庁資料や関連ガイドが更新された場合は、参照日と要約の前提を見直す。
- 具体的なツール導入は各プロジェクトのスタック決定後に行い、このテンプレートでは候補と使い分けに留める。
- 短い恒久ルールに昇格できる内容は `docs/rules-ux.md`、詳細手順はskill側に置く。
