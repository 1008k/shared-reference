<!-- managed-by: shared-reference -->
<!-- source-repo: https://github.com/1008k/shared-reference -->
<!-- source-path: docs/install-in-project.md -->
# Install Or Update Shared Reference In A Project

Use these prompts with a coding agent when installing `shared-reference` into an existing project or updating an already adopted project.

## Install Prompt

Use this when the project does not have `.shared/shared-reference.lock.yaml` yet.

### Full Prompt

````md
# shared-reference をこのプロジェクトに導入してください

このプロジェクトに、共有参照 repo `https://github.com/1008k/shared-reference.git` の vendor 同期運用を導入してください。

## Goal

- `shared-reference` の共有 docs / skills を、このプロジェクトの `.shared/` 配下に vendor コピーとして取り込む。
- プロジェクト固有の docs / rules / skills は残し、共有版で代替できる古い重複ルールや skill は整理する。
- 共有管理ファイルは直接編集せず、正本編集フローを使える状態にする。

## First

1. `git status --short --branch` と `git remote -v` を確認する。
2. `docs/policy-index.yaml` があれば読み、文書の正本と読み順を確認する。
3. `AGENTS.md`, `docs/rules-*.md`, `.agents/skills/`, `.shared/` の既存状態を確認する。
4. 既存の未コミット変更がある場合は巻き戻さず、今回の変更と混ぜてよいか慎重に判断する。

## Install

- `shared-reference` repo が隣接ディレクトリにあればそれを使う。
- なければ `https://github.com/1008k/shared-reference.git` を適切な場所に clone する。
- `shared-reference/scripts/adopt-shared-reference.ps1` を使って導入する。
- 導入後、以下が存在することを確認する。

```txt
.shared/shared-reference.lock.yaml
.shared/shared-index.yaml
.shared/docs/rules-coding.md
.shared/docs/rules-ux.md
.shared/docs/rules-writing.md
.shared/skills/skills-index.md
scripts/sync-shared-reference.ps1
scripts/propose-shared-reference-change.ps1
```

## Cleanup

- 旧 `agent-rules` / `.agents/shared-rules/` / `.shared/docs/shared-rules/` / `.shared/docs/integrations/` が残っていれば、共有管理ファイルかどうかを確認して整理する。
- 共有版で代替できる一般論、古い運用メモ、重複 skill は削除または短縮する。
- プロジェクト固有の仕様、互換性、ドメイン知識、公開仕様、既存UI/保存形式に関わるルールは残す。
- 判断に迷うものは削除せず、最終報告で「要確認」として挙げる。

## Project Docs

- `docs/rules-coding.md`, `docs/rules-ux.md`, `docs/rules-writing.md` はプロジェクト固有の入口として残す。
- 各ファイルから共有ルールを参照する。

```md
共有ルールは `.shared/docs/rules-coding.md` を基本として参照します。
```

- `AGENTS.md` に、共有管理ファイルは直接編集せず `scripts/propose-shared-reference-change.ps1` を使う旨を追記する。
- `docs/policy-index.yaml` がある場合は、`.shared/shared-index.yaml` と `.shared/shared-reference.lock.yaml` を sources または policy に追加し、優先順位はプロジェクト固有 docs が共有版を上書きする形にする。

## Verify

- `scripts/sync-shared-reference.ps1 -DryRun`
- `scripts/propose-shared-reference-change.ps1 -VendorPath .shared/shared-index.yaml`
- 可能なら `shared-reference/scripts/validate-shared-reference.ps1`
- `git diff --check`

## Done When

- `.shared/` に共有 docs / skills が同期されている。
- lock file が `https://github.com/1008k/shared-reference.git` と commit SHA を記録している。
- プロジェクト固有ルールが失われていない。
- 共有版で代替できる古い重複ルールや skill が整理されている。
- `policy-index.yaml` / `AGENTS.md` / `docs/rules-*.md` の参照が矛盾していない。
- 検証結果、削除/短縮した項目、残した項目、未実施確認が報告されている。
- 問題なければコミットし、push 可能なら push する。
````

### Short Prompt

```md
このプロジェクトに `https://github.com/1008k/shared-reference.git` を導入してください。

まず git 状態、remote、`docs/policy-index.yaml`、`AGENTS.md`、`docs/rules-*.md`、既存 `.agents/skills/` と `.shared/` を確認してください。

`shared-reference/scripts/adopt-shared-reference.ps1` を使って `.shared/` へ vendor 同期し、`.shared/shared-reference.lock.yaml`、`.shared/shared-index.yaml`、`.shared/docs/rules-*.md`、`.shared/skills/skills-index.md`、`scripts/sync-shared-reference.ps1`、`scripts/propose-shared-reference-change.ps1` を導入してください。

既存のプロジェクト固有ルールや skill は無条件に消さず、共有版で代替できる一般論・古い運用メモ・重複 skill だけ削除または短縮してください。プロジェクト固有の仕様、互換性、ドメイン知識、公開仕様は残してください。

`AGENTS.md` と `docs/rules-*.md`、必要なら `docs/policy-index.yaml` を更新し、プロジェクト固有 docs が共有版を上書きする構造にしてください。

最後に `scripts/sync-shared-reference.ps1 -DryRun`、`scripts/propose-shared-reference-change.ps1 -VendorPath .shared/shared-index.yaml`、`git diff --check` を確認し、問題なければコミット・push してください。
```

## Update Prompt

Use this when the project already has `.shared/shared-reference.lock.yaml`.

### Full Prompt

````md
# shared-reference を最新化してください

このプロジェクトに導入済みの `shared-reference` vendor コピーを、共有 repo の最新 commit に同期してください。

## Goal

- `https://github.com/1008k/shared-reference.git` の最新 `main` を取り込む。
- `.shared/` 配下の managed docs / skills と `.shared/shared-reference.lock.yaml` を更新する。
- プロジェクト固有の docs / rules / skills は保持し、共有版の更新で不要になった重複だけ整理する。
- managed file にローカル変更がある場合は直接上書きせず、正本編集フローへ切り分ける。

## First

1. `git status --short --branch` と `git remote -v` を確認する。
2. `.shared/shared-reference.lock.yaml` を読み、source repo、local path、現在の ref、disabled entries を確認する。
3. `docs/policy-index.yaml` があれば読み、`.shared/shared-index.yaml` の参照と優先順位を確認する。
4. 既存の未コミット変更がある場合は巻き戻さず、今回の同期差分と混ぜてよいか慎重に判断する。

## Update

- `shared-reference` repo が lock file の `source.local_path` または隣接ディレクトリにあればそれを使う。
- なければ `https://github.com/1008k/shared-reference.git` を適切な場所に clone する。
- 共有 repo を最新化する。

```powershell
git -C ..\shared-reference fetch origin
git -C ..\shared-reference switch main
git -C ..\shared-reference pull --ff-only
$ref = git -C ..\shared-reference rev-parse HEAD
```

- 導入先プロジェクトで dry-run してから同期する。

```powershell
scripts\sync-shared-reference.ps1 -Ref $ref -DryRun
scripts\sync-shared-reference.ps1 -Ref $ref
```

## Cleanup

- 同期後、共有版で代替できる一般論、古い運用メモ、重複 skill がプロジェクト固有 docs / `.agents/skills/` に残っていれば削除または短縮する。
- プロジェクト固有の仕様、互換性、ドメイン知識、公開仕様、既存UI/保存形式に関わるルールは残す。
- `disabled` entries がある場合は、今回の更新後も除外理由が妥当か確認する。
- managed file を変更したくなった場合は、`.shared/` を直接編集せず `scripts/propose-shared-reference-change.ps1 -VendorPath <path>` で共有 repo 側へ変更を作る。

## Verify

- `scripts/sync-shared-reference.ps1 -DryRun`
- `scripts/propose-shared-reference-change.ps1 -VendorPath .shared/shared-index.yaml`
- `git diff --check`
- 必要なら、共有 repo 側で `scripts/validate-shared-reference.ps1`

## Done When

- `.shared/shared-reference.lock.yaml` の ref が取り込んだ commit SHA に更新されている。
- `.shared/` の managed docs / skills が同期されている。
- プロジェクト固有ルールが失われていない。
- 共有版で代替できる古い重複ルールや skill が整理されている。
- `policy-index.yaml` / `AGENTS.md` / `docs/rules-*.md` の参照が矛盾していない。
- 検証結果、削除/短縮した項目、残した項目、未実施確認が報告されている。
- 問題なければコミットし、push 可能なら push する。
````

### Short Prompt

```md
このプロジェクトに導入済みの `https://github.com/1008k/shared-reference.git` を最新化してください。

まず git 状態、remote、`.shared/shared-reference.lock.yaml`、`docs/policy-index.yaml`、`AGENTS.md`、`docs/rules-*.md`、既存 `.agents/skills/` を確認してください。

`shared-reference` repo を最新の `main` に更新し、その commit SHA を使って `scripts/sync-shared-reference.ps1 -Ref <commit> -DryRun`、問題なければ `scripts/sync-shared-reference.ps1 -Ref <commit>` を実行してください。

同期後、共有版で代替できる一般論・古い運用メモ・重複 skill がプロジェクト固有 docs や `.agents/skills/` に残っていれば削除または短縮してください。プロジェクト固有の仕様、互換性、ドメイン知識、公開仕様は残してください。

managed file を変更したくなった場合は `.shared/` を直接編集せず、`scripts/propose-shared-reference-change.ps1 -VendorPath <path>` で共有 repo 側へ変更してください。

最後に `scripts/sync-shared-reference.ps1 -DryRun`、`scripts/propose-shared-reference-change.ps1 -VendorPath .shared/shared-index.yaml`、`git diff --check` を確認し、問題なければコミット・push してください。
```
