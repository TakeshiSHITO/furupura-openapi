# Furupura OpenAPI Definitions

ふるぷらAPIの仕様書リポジトリです。

📚 **公開ドキュメント**: https://takeshishito.github.io/furupura-openapi/

## 🎯 はじめての方へ

### セットアップ（初回のみ）

```bash
# Node.js v20を使用
nvm use

# 依存関係をインストール
pnpm install
```

### 開発の基本コマンド

```bash
# APIドキュメントをブラウザで確認（これだけ覚えればOK！）
pnpm run dev

# 変更が反映されない時
pnpm run clean && pnpm run dev
```

## 🚀 実践：新しいエンドポイントを追加する

例として「ユーザーのお気に入り商品一覧API」を追加してみましょう。

### Step 1: エンドポイント定義を作成

```yaml
# contexts/user/paths/favorites.yaml を編集
get:
  summary: お気に入り商品一覧を取得
  operationId: getFavorites
  tags:
    - favorites
  responses:
    '200':
      description: お気に入り商品一覧
      content:
        application/json:
          schema:
            type: array
            items:
              $ref: '../schemas/product.yaml#/Product'
```

### Step 2: メインファイルに追加

```yaml
# contexts/user/openapi.yaml の paths: セクションに追加
paths:
  # ... 既存のパス
  /favorites:
    $ref: './paths/favorites.yaml'
```

### Step 3: 確認

```bash
# キャッシュをクリアして確認
pnpm run clean
pnpm run dev
# → http://localhost:8080 で変更を確認
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

## 💡 よくある質問

### Q: 変更が反映されない

```bash
pnpm run clean && pnpm run dev  # キャッシュをクリアして再ビルド
```

### Q: エラーが出る

```bash
pnpm run validate  # どのファイルでエラーが出ているか確認
```

### Q: $refの書き方がわからない

```yaml
# ✅ 相対パスで記述
$ref: '../schemas/user.yaml#/User'

# ❌ 絶対パスはNG
$ref: '/shared/schemas/common.yaml#/Error'
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

## 📋 コマンド一覧

### 基本コマンド

| コマンド            | 説明                         | いつ使う？               |
| ------------------- | ---------------------------- | ------------------------ |
| `pnpm run dev`      | ドキュメントをビルドして表示 | **開発中はこれだけでOK** |
| `pnpm run clean`    | キャッシュをクリア           | 変更が反映されない時     |
| `pnpm run validate` | API仕様を検証                | エラーチェック時         |

### その他のコマンド

| コマンド          | 説明                    |
| ----------------- | ----------------------- |
| `pnpm run bundle` | YAMLファイルを1つに統合 |
| `pnpm run build`  | HTMLドキュメントを生成  |
| `pnpm run serve`  | ローカルサーバーを起動  |

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
pnpm run validate

# フォーマットを修正
pnpm exec prettier --write .

# コミットメッセージを確認
# 正しい形式: "feat: 機能を追加"
```

### バンドルエラーが発生する場合

```bash
# キャッシュをクリア
rm -rf .redocly-cache
pnpm run bundle
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

### 📄 ポータルページについて

`docs/index.html`は、すべてのAPIドキュメントへのエントリーポイントとなるポータルページです。

- **生成方法**: `pnpm run docs:portal` または `pnpm run docs:all`
- **設定ファイル**: `portal.yaml` - ポータルページ用のOpenAPI仕様
- **内容**:
  - 各API（Shop/User/Admin）へのナビゲーション
  - APIサービス全体のステータスチェックエンドポイント
  - プラットフォーム概要説明

GitHub Pagesで公開すると、訪問者は最初にこのポータルページを見て、必要なAPIドキュメントへ移動できます。
