# Furupura OpenAPI Definitions

ふるぷらAPIの仕様書リポジトリです。

## 🚀 クイックスタート

```bash
# 1. Node.js v20を使用（.nvmrcで指定済み）
nvm use

# 2. 依存関係をインストール
pnpm install

# 3. API仕様書をプレビュー
pnpm run preview:shop   # ショップオーナー向けAPI
pnpm run preview:user   # ユーザー向けAPI
pnpm run preview:admin  # 管理者向けAPI
```

## 📝 開発ルール

### コミット前の自動チェック

**Huskyにより自動実行されます：**

- OpenAPI仕様の検証（redocly）
- コードフォーマット（Prettier）
- コミットメッセージの検証（Commitlint）

### コミットメッセージ規約

**必ず以下の形式で記述してください：**

```
<type>: <subject>

[optional body]
```

**使用可能なtype：**

- `feat`: 新機能追加
- `fix`: バグ修正
- `docs`: ドキュメントのみの変更
- `style`: フォーマットの修正（コードの動作に影響なし）
- `refactor`: リファクタリング
- `perf`: パフォーマンス改善
- `test`: テストの追加・修正
- `chore`: ビルドプロセスやツールの変更
- `ci`: CI/CD設定の変更
- `revert`: 以前のコミットを取り消し

**例：**

```bash
git commit -m "feat: カート機能のAPIを追加"
git commit -m "fix: 認証エラーレスポンスを修正"
git commit -m "docs: READMEにセットアップ手順を追加"
```

## 🛠️ 開発フロー

### 1. 新しいエンドポイントを追加する場合

```bash
# 1. ブランチを作成
git checkout -b feat/new-endpoint

# 2. 該当するpathsファイルを編集
# 例: contexts/user/paths/cart.yaml

# 3. 検証を実行
pnpm run validate:all

# 4. コミット（自動でフォーマット&検証される）
git add .
git commit -m "feat: カートアイテム削除APIを追加"

# 5. プッシュ
git push origin feat/new-endpoint
```

### 2. スキーマを修正する場合

```bash
# 1. 該当するschemasファイルを編集
# 例: contexts/shop/schemas/product.yaml

# 2. 影響を受ける全APIを検証
pnpm run validate:all

# 3. ドキュメントをローカルで確認
pnpm run docs:build
pnpm run preview:shop
```

## 📁 ディレクトリ構成

```
contexts/
├── shop/          # ショップオーナー向けAPI
├── user/          # ユーザー向けAPI
└── admin/         # 管理者向けAPI

各コンテキスト内：
├── openapi.yaml   # メイン定義
├── paths/         # エンドポイント定義
└── schemas/       # データモデル定義
```

## 🔧 よく使うコマンド

```bash
# 検証
pnpm run validate:all    # 全API仕様を検証

# プレビュー
pnpm run preview:shop    # ブラウザでAPIドキュメントを確認
pnpm run docs:preview    # Redoclyの開発サーバーでプレビュー

# ビルド
pnpm run bundle:all      # 単一ファイルに統合（YAML形式）
pnpm run docs:build      # 個別のHTMLドキュメント生成
pnpm run docs:portal     # ポータルページ（index.html）生成
pnpm run docs:all        # すべてのドキュメントを一括生成

# フォーマット
pnpm exec prettier --write .  # 手動でフォーマット
```

### 📦 bundle vs docs の違い

| コマンド   | 出力形式  | 用途                                   | 出力先           |
| ---------- | --------- | -------------------------------------- | ---------------- |
| `bundle:*` | YAML/JSON | APIクライアント生成、CI/CD統合、配布用 | `bundled/*.yaml` |
| `docs:*`   | HTML      | ブラウザ閲覧用、GitHub Pages公開用     | `docs/*.html`    |

- **bundle**: 分割されたOpenAPIファイルを1つのYAMLファイルに統合。機械が読むための仕様書
- **docs**: OpenAPI仕様からインタラクティブなHTMLドキュメントを生成。人間が読むためのWebページ

## ⚠️ 注意事項

### 破壊的変更を行う場合

1. **必ずチームに相談**してから実施
2. 影響を受けるクライアントを明記
3. 移行ガイドを作成

### $refパスの記述

```yaml
# ❌ 絶対パスは使わない
$ref: '/shared/schemas/common.yaml#/Error'

# ✅ 相対パスを使用
$ref: '../../shared/schemas/common.yaml#/components/schemas/Error'
```

## 🔄 自動アップデート（Dependabot）

毎週月曜日の朝9時（JST）に依存関係の更新をチェックし、PRを自動作成します。

### 対応方法

1. **Dependabot PR**には`dependencies`ラベルが付きます
2. 変更内容を確認し、問題なければマージ
3. 破壊的変更がある場合は、影響を確認してから対応

## 🚨 トラブルシューティング

### コミットが失敗する場合

```bash
# 手動で検証を実行
pnpm run validate:all

# フォーマットを修正
pnpm exec prettier --write .

# コミットメッセージを確認
# 正しい形式: "feat: 機能を追加"
```

### バンドルエラーが発生する場合

```bash
# キャッシュをクリア
rm -rf .redocly-cache
pnpm run bundle:all
```

## 🤝 コントリビューション

1. このリポジトリをフォーク
2. フィーチャーブランチを作成（`git checkout -b feat/amazing-feature`）
3. 変更をコミット（`git commit -m 'feat: 素晴らしい機能を追加'`）
4. ブランチにプッシュ（`git push origin feat/amazing-feature`）
5. プルリクエストを作成

## 📄 ライセンス

このプロジェクトは独自のライセンスの下で公開されています。

- **参照・学習目的**での利用は自由です
- **商用利用**や**派生物の作成**は禁止されています
- 詳細は[LICENSE](./LICENSE)ファイルをご確認ください

## 🌐 APIドキュメント

最新のAPIドキュメントは以下で公開されています：

**https://takeshishito.github.io/furupura-openapi/**

（mainブランチへのプッシュで自動更新されます）

### 📄 ポータルページについて

`docs/index.html`は、すべてのAPIドキュメントへのエントリーポイントとなるポータルページです。

- **生成方法**: `pnpm run docs:portal` または `pnpm run docs:all`
- **設定ファイル**: `portal.yaml` - ポータルページ用のOpenAPI仕様
- **内容**:
  - 各API（Shop/User/Admin）へのナビゲーション
  - APIサービス全体のステータスチェックエンドポイント
  - プラットフォーム概要説明

GitHub Pagesで公開すると、訪問者は最初にこのポータルページを見て、必要なAPIドキュメントへ移動できます。
