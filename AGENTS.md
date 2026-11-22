# 作業指針

## 目的と進め方

MATLAB Agentic ToolkitとSimulink Agentic Toolkitを使い、BPSK復調器の設計・検証・再利用資産化を試行する。ユーザーとの会話・設計文書は日本語を基本とする。仕様は必要な粒度に絞り、依頼範囲を越えて詳細設定を増やさない。

2026-11-22時点では設計インプットと成果物形式、保存先、CSVヘッダを準備済み。内部機能の導出・アーキテクチャ本文・実装・性能検証は未実施。今後は実ファイルと最新の依頼を確認して進捗を判断する。

## 作業環境

- このリポジトリの既存 `Satk_test_prj.prj` を使用する。別Projectを新設しない。
- MATLAB作業前に現在のProjectを確認する。未オープンなら既存Projectを開く。別Projectが開かれている場合は、その状態を確認してから切り替える。
- MATLAB / Simulink操作は利用可能なToolkitのツールを優先する。導入済み製品・バージョン・APIを確認し、利用可能と推測しない。
- `restoredefaultpath` を実行しない。接続ツールのパスを失う可能性がある。
- Projectのファイル登録と検索パス登録は別操作。新規成果物はProjectに登録し、モデル・設定・実装・試験の必要なフォルダだけをProjectパスへ追加する。
- `resources/project/` の管理ファイルを手編集せず、Project APIを利用する。
- 既存の変更、Project設定、startup/shutdown処理を尊重する。依頼されていないコミットや既存変更の取り消しは行わない。

## 設計の正本

まず以下を参照する。

1. `docs/specs/algorithms/blind-bpsk/blind-bpsk-design-input.html`：上位仕様。
2. `docs/architecture/bpsk-demod/bpsk-demod-deliverables.html`：成果物形式と配置方針。
3. `docs/architecture/bpsk-demod/` のCSV：機能・内部インターフェース・要求の対応。

設計インプットの `blind-bpsk` は既存リンク維持のため残した名前であり、現在の仕様がプリアンブルなしという意味ではない。今後の内部設計・実装は `bpsk-demod` とする。

現行の前提（変更時は正本と関連文書を同時に更新）：

- ADC：200 kHzの実数IF、1 MS/s、12 bit。
- DDC：複素ベースバンドIQ、80 ksample/s。
- BPSK：10 ksymbol/s、プリアンブル込み10 kbit/s。
- システム設計から要求された固定フレーム：32 bitプリアンブル `0x1ACFFC1D`（MSB first）＋256 bitデータ。ヘッダ・CRCなし、空白なしで連続送信。
- 復調部でフレーム同期と極性補正を行い、プリアンブルを含む補正済み硬判定列、ビット有効信号、フレーム先頭信号を出力する。
- 評価器による全体反転補正は禁止。受信機自身の極性補正を評価し、途中のスリップ・欠落を再整列で隠さない。
- データ部の送信真値は評価器だけが参照する。既知プリアンブルとフレーム長は復調部で使用できる。

## 成果物と配置

| 保存先 | 内容・形式 |
| --- | --- |
| `docs/architecture/bpsk-demod/` | 機能導出・アーキテクチャHTML、埋込みSVG、一覧CSV |
| `models/bpsk-demod/` | 復調モデル `.slx` |
| `models/harness/` | ADC・DDC・波形源・チャネル・評価器を含むハーネス `.slx` |
| `src/bpsk-demod/` | MATLAB参照実装 `.m` |
| `config/` | 共通パラメータ `.m`、必要に応じてBus・辞書 `.sldd` |
| `tests/bpsk-demod/` | 試験コード `.m` と試験条件 |
| `results/bpsk-demod/` | 実行別の結果 `.mat`、集計 `.csv`、報告 `.html` |

設計説明・構成図はHTML、一覧情報はCSVを正本とする。CSVはUTF-8 BOM付き、複数IDはセミコロン区切り。要求 `R-xx`、機能 `F-xx`、インターフェース `IF-xx` を対応付ける。statusは `draft` / `reviewed` / `verified`。未実装・未実行・未決定を明示する。

System ComposerやRequirements Toolbox専用形式は必須にしない。必要性と導入状況を確認してから採用する。大容量ログ・派生ファイルを無条件にProjectやGitへ登録しない。

## 設計・検証

- 上位要求から機能を導出し、責務・入出力・信号レート・状態・リセット・検証方法を定義する。方式候補と決定済み仕様を区別する。
- 仕様変更時はアーキテクチャ、CSV、モデル、試験への影響を確認する。数値目標を達成結果として記載しない。
- モデル編集後は構造と設定を読み戻し、診断・該当試験で確認する。
- MATLAB参照実装とSimulinkには共通の入力・設定を用いる。フレーム誤検出、未検出、欠落、極性誤りをBERと併せて報告する。
- 実行結果には環境、設定、乱数seed、試験条件を残す。未実行の試験を合格扱いしない。
- 文書のみの変更はリンク・表・仕様の整合を確認する。不要なシミュレーションは行わない。
- Project変更後は `runChecks` と `updateDependencies` で確認する。チェックの成否と対象ファイルを読み、未合格項目を隠さない。

初期セットアップでは `OutOfDateDerivedFiles` チェックのみ対象ファイル0件のまま未合格だった。原因を確定した記録ではないため、必要に応じて再確認する。
