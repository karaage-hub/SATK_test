# 復調部の内部設計

[設計仕様書](bpsk-demod-architecture.html)に機能階層、構成案A、静的Simulinkモデル、内部インターフェース契約を記載しています。全項目draftです。

- 機能一覧・要求対応・内部インターフェース一覧の正本はCSV。
- 内部インターフェースは21件。フィールド定義は `bpsk-demod-interface-fields.csv`、機械可読の集約は `bpsk-demod-interface-contracts.json`。
- `bpsk-demod-port-descriptions.json` はモデル端子説明への反映用データ。
- 静的モデルは入出力端子と接続のみ。実行アルゴリズム・試験ハーネスは未実装。
- 処理単位、同期判定閾値・状態遷移は次工程で具体化します。

辞書: `config/bpsk_demod_interfaces.sldd`。Project内で `build_bpsk_interfaces` を実行するとCSVから再生成、`check_bpsk_interfaces` で静的整合を確認できます。仕様書第6章参照。

[設計仕様](bpsk-demod-architecture.html)と[検討状況・未決事項・検証記録](bpsk-demod-design-status.html)を分離して管理します。

## 辞書の操作・再生成

既存MATLAB Projectを開いて次を実行します。

```matlab
open('bpsk_demod_interfaces.sldd')  % Design Dataで型・要素のDescriptionを参照
build_bpsk_interfaces             % CSV正本から辞書を再生成
check_bpsk_interfaces             % CSV・辞書・モデル端子の静的整合を確認
```

辞書の同名型は再生成で更新されます。変更はCSV正本へ反映し、端子型を変更する場合はインターフェースCSVとモデルも更新してください。辞書だけを手修正しないでください。静的整合の確認は動作・性能の検証を意味しません。
