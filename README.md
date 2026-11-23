# BPSK復調器の設計試行

既存の `Satk_test_prj.prj` を作業環境とする。新規Projectは作成しない。

- [設計インプット v0.3](docs/bpsk-demod/bpsk-demod-design-input.html)
- [機能定義とアルゴリズム構成案A（Draft v0.6）](docs/bpsk-demod/bpsk-demod-architecture.html)
- [成果物形式・配置方針](docs/bpsk-demod/bpsk-demod-deliverables.html)

MATLABで `Satk_test_prj.prj` を開いて作業する。モデル・参照実装・設定・試験の各保存先はProjectパスに登録する。文書と結果フォルダは検索パスに追加しない。

文書の入口は [docs/index.html](docs/index.html)。BPSK関連文書は `docs/bpsk-demod/` に集約する。

現在は詳細機能10件と上位要求との対応をDraftとして導出済み。機能階層と情報依存を定義し、処理順序・配置・ポート・状態遷移は方式検討に必要な確認を経て具体化する。静的SLXモデルを作成済み。アルゴリズム実装・性能検証は未実施。

アルゴリズム全体構成案Aを仕様書第3章へ追記。単一案を対話で具体化する段階であり、採用確定・性能検証はまだ行っていない。

構成案Aの静的モデル：`models/bpsk-demod/bpsk_demod_architecture.slx`。内部は端子のみで、アルゴリズム実装・性能検証は未実施。

内部インターフェースは仕様書第5章と `bpsk-demod-interfaces.csv`、`bpsk-demod-interface-fields.csv`、`bpsk-demod-interface-contracts.json` に定義。静的モデルへ反映済み（Bus定義・端子型を適用済み）。

[設計仕様](docs/bpsk-demod/bpsk-demod-architecture.html)と[検討状況・未決事項・検証記録](docs/bpsk-demod/bpsk-demod-design-status.html)を分離して管理します。
