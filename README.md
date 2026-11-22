# BPSK復調器の設計試行

既存の `Satk_test_prj.prj` を作業環境とする。新規Projectは作成しない。

- [設計インプット v0.3](docs/specs/algorithms/blind-bpsk/blind-bpsk-design-input.html)
- [成果物形式・配置方針](docs/architecture/bpsk-demod/bpsk-demod-deliverables.html)

MATLABで `Satk_test_prj.prj` を開いて作業する。モデル・参照実装・設定・試験の各保存先はProjectパスに登録する。文書と結果フォルダは検索パスに追加しない。

設計インプットの既存保存先 `blind-bpsk` はリンク維持のため残す。今後の内部設計・実装には、プリアンブルを使う現仕様に合わせて `bpsk-demod` を使用する。

現在は成果物形式、フォルダ、CSVヘッダを準備した段階。内部機能の導出、アーキテクチャ本文、SLXモデル、アルゴリズム実装は次工程で作成する。
