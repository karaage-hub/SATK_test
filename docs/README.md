# 設計ドキュメント

入口は [index.html](index.html) です。

```text
docs/
├── index.html
└── bpsk-demod/
    ├── *.html       上位要求・設計仕様・検討状況・配置方針
    ├── data/        CSV正本と機械可読JSON
    └── assets/      モデル図
```

仕様と検討状況は別HTMLで管理します。モデル・辞書・生成スクリプトは従来どおりmodels/とconfig/に配置します。
