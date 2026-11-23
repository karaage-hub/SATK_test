# BPSK復調器の設計試行

MATLAB Agentic ToolkitとSimulink Agentic Toolkitを使い、BPSK復調器の設計・検証・再利用資産化を試行するプロジェクトです。単一の構成案を対話で具体化し、設計仕様とモデル・設計データを対応付けて管理します。

## 対象システム

ADC（200 kHz実数IF、1 MS/s、12 bit）とDDCの後段に置く復調部を対象とします。

| 項目 | 仕様 |
| --- | --- |
| 入力 | DDCからの複素IQ、80 ksample/s |
| 変調・レート | BPSK、10 ksymbol/s、プリアンブル込み公称10 kbit/s |
| フレーム | 32 bitプリアンブル `0x1ACFFC1D`（MSB first）＋256 bitデータ。空白なしで連続送信 |
| 出力 | プリアンブルを含む極性補正済み硬判定列、`bit_valid`、`frame_start` |

フレーム形式はシステムからの要求として設定しています。復調部自身がフレーム同期と極性補正を行います。

## 現在の設計状況

- 詳細機能10件、上位要求との対応、構成案A、段階的な同期捕捉と再捕捉の動作方針を定義済みです。
- 13サブシステムを端子と接続で表した静的Simulinkモデルを作成済みです。
- 内部インターフェース21件を定義し、11種類・58フィールドのBus定義と57端子の型・説明を反映済みです。CSV・辞書・端子の静的整合を確認しています。
- アルゴリズム実装、動作シミュレーション、BER・捕捉性能の検証は未実施です。同期判定閾値・ループ係数・実行周期などは詳細設計で決定します。

設計はdraftです。静的整合の確認は、動作・性能の成立を意味しません。

## 設計文書

文書の入口は [docs/index.html](docs/index.html) です。HTMLはローカルのブラウザで開いて参照してください。

| 文書 | 内容 |
| --- | --- |
| [上位要求一覧](docs/bpsk-demod/bpsk-demod-requirements.html) | R-01〜R-06と共通条件 |
| [設計インプット](docs/bpsk-demod/bpsk-demod-design-input.html) | 上位仕様の詳細 |
| [設計仕様書](docs/bpsk-demod/bpsk-demod-architecture.html) | 範囲と目的、詳細機能、内部アーキテクチャ、動作仕様、インターフェース、モデル化仕様 |
| [検討状況・検証記録](docs/bpsk-demod/bpsk-demod-design-status.html) | 未決事項と確認済みの範囲 |
| [成果物形式・配置方針](docs/bpsk-demod/bpsk-demod-deliverables.html) | 成果物の形式と保存先 |

## MATLABでの利用

既存の [Satk_test_prj.prj](Satk_test_prj.prj) を開き、Project内で次を実行します。

```matlab
open_system('bpsk_demod_architecture')  % 静的アーキテクチャモデルを表示
check_bpsk_interfaces                 % CSV・辞書・端子の静的整合を確認
```

フィールド定義CSVを変更した場合は、`build_bpsk_interfaces` で辞書を再生成し、整合を再確認します。端子や接続の変更はモデルにも反映してください。

## フォルダ構成

| 保存先 | 内容 |
| --- | --- |
| `docs/bpsk-demod/` | 設計文書。`data/`にCSV・JSON、`assets/`に画像 |
| `models/bpsk-demod/` | 静的アーキテクチャモデル |
| `config/` | データディクショナリ、生成・整合確認スクリプト |
| `src/bpsk-demod/` | MATLAB参照実装の保存先 |
| `models/harness/` | 試験ハーネスの保存先 |
| `tests/bpsk-demod/` | 試験コード・条件の保存先 |
| `results/bpsk-demod/` | 実行結果・報告の保存先 |

機能一覧・要求対応・インターフェース一覧はCSVを正本とし、HTMLで設計意図を説明します。モデルとデータディクショナリはセットで管理します。
