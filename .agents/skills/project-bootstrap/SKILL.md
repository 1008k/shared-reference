---
name: project-bootstrap
description: Concretize a new project from `docs/initial-brief.md` into the frontmatter and body of `docs/project-spec.md`. Use when starting from this template or when the project direction is still underspecified.
---
<!-- managed-by: shared-reference -->
<!-- source-repo: https://github.com/1008k/shared-reference -->
<!-- source-path: .agents/skills/project-bootstrap/SKILL.md -->

# Project Bootstrap

このskillは、このテンプレートで実装前の基本文書を具体化するための手順です。
方針は `docs-first` で、スタックが未確定なら文書整理を優先します。

## 前提
- 最初に `docs/policy-index.yaml` を読む
- 次に `docs/project-spec.md` を確認する
- 必要に応じて `README.md` と `AGENTS.md` を参照する

## 目的
- `docs/initial-brief.md` の内容から、最低限のプロジェクト定義を作る
- 未確定事項と決定事項を分ける
- 実装に進んでよい段階か、まだ文書を詰めるべき段階かを判断する

## 手順
1. `docs/initial-brief.md` から、プロジェクト名、種別、目的、対象ユーザー、必須機能、非目的、制約、未定事項を抽出する。
2. `docs/project-spec.md` 冒頭の YAML frontmatter に、短く安定した事実だけを入れる。
3. `docs/project-spec.md` に、以下を具体化する。
   - プロジェクト概要
   - 非目的
   - 技術方針
   - 設計方針
   - 受け入れ条件
4. まだ決める材料が足りない場合は、未定事項を明示し、推測で埋めすぎない。
5. スタックが未確定なら、実装コマンドや技術固有ルールを増やさない。

## 記入ルール
- `docs/project-spec.md` 冒頭の YAML frontmatter には理由や長文を書かない
- 理由、判断材料、例外は `docs/project-spec.md` 本文に寄せる
- 初期段階では、詳細設計や運用拡張を早く決めすぎない
- 仕様が曖昧なままテンプレート既定を事実のように書かない

## 完了の目安
- `docs/project-spec.md` 冒頭の YAML frontmatter の基本項目が埋まっている
- `docs/project-spec.md` の非目的が書かれている
- `docs/initial-brief.md` の未定事項が識別できる
- 実装開始前に詰めるべき論点が残っていれば明示されている

## リポジトリ scaffold 時の Hygiene
新規プロジェクトを作る・テンプレートから展開する際は、以下を最初に含める。
- `.gitignore` に `.kilo/`（Agent-Manager の worktree 等のローカルツール状態）を除外する。これがないと `biome lint .` が worktree 内の `biome.json` を nested config とみなして失敗する。
- `.gitattributes` を追加し、改行を `eol=lf` に固定する（`* text=auto eol=lf`）。未設定だと共有管理ファイル（YAML の lock 等）で CRLF/BOM の差分ノイズが発生し、YAML の先頭 BOM は厳密なパーサで警告の原因になる。

## 出力の型
- 先に結論を示す
- 未定事項がある場合は明示する
- 更新した文書と残課題を短く示す
