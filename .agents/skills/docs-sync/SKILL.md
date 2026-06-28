---
name: docs-sync
description: Check and reconcile gaps across `docs/project-spec.md`, `README.md`, and `ARCHITECTURE.md`. Use when updating project docs, reviewing drift after implementation, or confirming which document should be the source of truth.
---
<!-- managed-by: agent-rules -->
<!-- source-repo: https://github.com/1008k/agent-rules -->
<!-- source-path: .agents/skills/docs-sync/SKILL.md -->

# Docs Sync

このskillは、仕様、利用案内、構造説明の役割を混同せずに差分確認するための手順です。
このリポジトリでは、正本の優先順位は `docs/policy-index.yaml` と `AGENTS.md` に従います。

## 使う場面
- 実装着手前後に文書の整合を確認したいとき
- `README.md` に実装詳細が増えすぎていないか見たいとき
- `ARCHITECTURE.md` にテンプレート構成または実装構造の説明を追加すべきか判断したいとき
- `docs/project-spec.md` と他文書の責務境界を見直したいとき

## 手順
1. 最初に `docs/policy-index.yaml` を読み、正本と優先順位を確認する。
2. `docs/project-spec.md` を読み、対象範囲、非目的、受け入れ条件の変更有無を確認する。
3. `README.md` を読み、セットアップ、導線、全体概要に限定されているか確認する。
4. `ARCHITECTURE.md` を読み、テンプレート構成または実装済み構造の説明に収まっているか確認する。
5. 差分を以下の観点で分類する。
   - 観察: どの文書にどの情報があり、何が重複または欠落しているか
   - 判断: 正本に照らして不整合か、単なる未更新か
   - 提案: どの文書を直すべきか、どの文書には書かないべきか
6. 修正する場合は、最小差分で更新する。

## 判断基準
- `docs/project-spec.md`: 何を作るか、何を対象外にするか、受け入れ条件
- `README.md`: 人とエージェントの入口、セットアップ、参照導線
- `ARCHITECTURE.md`: テンプレート自身の構成、または実装済み/実装中の構造、責務分割、依存関係
- `docs/policy-index.yaml`: 優先順位、状態、静的に扱える項目

## 避けること
- 理由説明や例外をYAMLに増やしすぎない
- 実装がない段階で、コピー後プロジェクトの実装構造を推測して `ARCHITECTURE.md` を具体化しすぎない
- `README.md` に運用ルールや仕様詳細を重複記載しない

## 出力の型
- 結論を先に示す
- 必要なら `観察 / 判断 / 提案` を分ける
- 修正対象ファイルを明示する
