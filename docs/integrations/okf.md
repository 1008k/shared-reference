<!-- managed-by: shared-reference -->
<!-- source-repo: https://github.com/1008k/shared-reference -->
<!-- source-path: docs/integrations/okf.md -->
# OKF Knowledge Catalog

## 位置づけ
OKF (Open Knowledge Format) は、Markdown と YAML frontmatter を使って知識をカタログ化するための軽量な形式です。
このテンプレートでは、リポジトリ全体の標準Markdown形式としてではなく、プロジェクトごとの知識カタログを作るときの任意候補として扱います。

## 推奨度
任意。

## 使うとよい場面
- API、外部サービス、用語、運用手順、意思決定などを横断参照したい
- 人間とエージェントが同じ知識断片を読み、検索し、更新する必要がある
- `docs/` 配下の自由記述が増え、索引や分類がないと追いにくくなってきた

## 使わないほうがよい場面
- 小さいプロジェクトで、通常の `README.md` と `docs/project-spec.md` だけで十分な場合
- すべてのMarkdownに frontmatter や `type` を要求すると、テンプレートが重くなる場合
- 仕様、設計、運用ルールの正本を `docs/policy-index.yaml` から移したくなる場合

## 試すときの置き場所
まずはコピー後プロジェクトで、必要になった場合だけ `docs/knowledge/` などのサブディレクトリを作り、その範囲だけをOKF風の知識カタログとして扱います。
リポジトリルート全体や既存の正本文書をOKF準拠に寄せる必要はありません。

## 最小運用案
- `docs/knowledge/index.md`: カタログの入口
- `docs/knowledge/log.md`: 重要な追加、変更、削除の短い記録
- `docs/knowledge/*.md`: 個別の知識断片
- 各知識断片には、必要な範囲で `title`、`type`、`summary`、`status`、`updated` などを置く

## 境界
- 正本の優先順位は引き続き `docs/policy-index.yaml` に従う
- OKF風のファイルは、仕様やルールを上書きするものではなく、観測、参照、補助知識として扱う
- 外部仕様を採用する場合も、必要な部分だけをこのリポジトリの文書体系に合わせて使う

## 採用判断
知識断片が増え、通常のMarkdown検索だけでは探しにくくなったら試す。
効果が薄い場合は、通常の `docs/` 文書に戻してよい。
