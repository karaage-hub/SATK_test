# BPSK復調部の静的アーキテクチャ

`bpsk_demod_architecture.slx` は仕様書の構成案Aを表した静的モデルです。MATLAB Projectを開き、`open_system('bpsk_demod_architecture')` で表示できます。

- 13処理サブシステム。内部はInport/Outportのみで、意図的に未接続。
- 外部端子はrx_iq・resetと、bits・bit_valid・frame_start。
- 青：信号処理、シアン：フレーム処理、黄：有効性・初期化管理。
- 各処理を拡大し段別に配置、既存線を再ルーティング。内部プレビューは非表示。
- トップレベル端子の接続とサブシステム間の経路を確認済み。内部未接続は静的モデルの意図した状態。実行・コンパイル・性能試験は対象外。
- 信号は論理情報を表す。symbols/candidate_bitsは有効性・位置情報を含む想定、frame_descriptorはフレーム位置・極性・同期状態、frame_permissionは対象フレームに対応する許可を表す。Bus型・要素次元は辞書に定義済み。実行サンプル時間は未定。
- `bpsk-demod-static-structure.json` に処理とF番号・端子・SIDの対応を記録。

内部インターフェース21件の論理契約を仕様書10章とCSVに定義し、各端子のDescriptionに反映しています。フレーム保持部から管理部へのframe_statusを追加しました。フレーム位置と初期化区間IDで対象を対応付けます。数値型・次元は設計案であり、Simulink.Busと端子型を適用済みです。実行周期は未定です。

辞書: `config/bpsk_demod_interfaces.sldd`。Project内で `build_bpsk_interfaces` を実行するとCSVから再生成、`check_bpsk_interfaces` で静的整合を確認できます。仕様書11章参照。
