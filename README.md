# Furupura OpenAPI Definitions

ふるぷらAPIの契約定義リポジトリです。境界コンテキストごとにOpenAPI定義を分割管理しています。

## 構造

```
furupura-openapi/
├── contexts/           # 境界コンテキスト別定義
│   ├── shop/          # ショップ向けAPI
│   │   ├── openapi.yaml    # メイン定義（info, servers, tags）
│   │   ├── paths/          # エンドポイント定義（分割管理）
│   │   │   ├── products.yaml
│   │   │   └── orders.yaml
│   │   └── schemas/        # ショップ固有スキーマ
│   ├── user/          # ユーザー向けAPI
│   │   ├── openapi.yaml    # メイン定義
│   │   ├── paths/          # エンドポイント定義（分割管理）
│   │   │   ├── auth.yaml
│   │   │   ├── profile.yaml
│   │   │   ├── browsing.yaml
│   │   │   └── cart.yaml
│   │   └── schemas/        # ユーザー固有スキーマ
│   └── admin/         # 管理者向けAPI
│       ├── openapi.yaml    # メイン定義
│       ├── paths/          # エンドポイント定義（分割管理）
│       │   ├── auth.yaml
│       │   ├── users.yaml
│       │   ├── shops.yaml
│       │   └── analytics.yaml
│       └── schemas/        # 管理者固有スキーマ
├── shared/            # 共通コンポーネント
│   ├── schemas/       # 共通スキーマ
│   ├── parameters/    # 共通パラメータ
│   └── responses/     # 共通レスポンス
├── bundled/           # ビルド済みファイル（自動生成）
│   ├── shop.openapi.yaml
│   ├── user.openapi.yaml
│   └── admin.openapi.yaml
├── docs/              # HTMLドキュメント（自動生成）
│   ├── shop/
│   ├── user/
│   └── admin/
└── scripts/           # ユーティリティスクリプト
```

### ファイル分割の方針

OpenAPI定義は保守性を高めるため、以下の方針で分割管理しています：

1. **メイン定義ファイル** (`openapi.yaml`)
   - API全体の情報（info, servers, tags）
   - パスへの参照（$ref使用）
   - セキュリティ設定

2. **パス定義ファイル** (`paths/*.yaml`)
   - 機能グループごとにファイル分割
   - 各ファイルに関連するエンドポイントをまとめる
   - 例：認証系、プロフィール系、商品系など

3. **スキーマ定義ファイル** (`schemas/*.yaml`)
   - データモデルごとにファイル分割
   - 再利用可能なコンポーネントとして定義

## セットアップ

```bash
# 依存関係のインストール
pnpm install
```

## 開発

### APIドキュメントのプレビュー

```bash
# ショップAPI
pnpm run preview:shop

# ユーザーAPI
pnpm run preview:user

# 管理者API
pnpm run preview:admin
```

### 検証

```bash
# 個別検証
pnpm run validate:shop
pnpm run validate:user
pnpm run validate:admin

# 全て検証
pnpm run validate:all
```

### バンドル

```bash
# 個別バンドル
pnpm run bundle:shop
pnpm run bundle:user
pnpm run bundle:admin

# 全てバンドル
pnpm run bundle:all
```

## クライアントコード生成

### 方法1: スクリプトを使用

```bash
# TypeScript (axios)
./scripts/generate-client.sh shop typescript-axios ./generated/shop-client

# Swift
./scripts/generate-client.sh user swift5 ./generated/user-ios-client

# Kotlin
./scripts/generate-client.sh admin kotlin ./generated/admin-android-client
```

### 方法2: 各クライアントのCIで実行

```yaml
# .github/workflows/generate-client.yml
- name: Download OpenAPI spec
  run: |
    curl -L https://github.com/furupura/furupura-openapi/releases/latest/download/shop.openapi.yaml \
         -o openapi.yaml

- name: Generate client
  run: |
    npx @openapitools/openapi-generator-cli generate \
      -i openapi.yaml \
      -g typescript-axios \
      -o ./src/api
```

## CI/CD

### プルリクエスト時
- 全API定義の検証
- バンドルファイルの生成

### リリース時（タグプッシュ時）
1. API定義の検証
2. バンドルファイルの生成
3. GitHubリリースの作成
4. クライアントリポジトリへの通知

## バージョニング

セマンティックバージョニングを採用：
- `v1.0.0` - 破壊的変更
- `v1.1.0` - 後方互換性のある機能追加
- `v1.1.1` - バグ修正

## ワークフロー

1. **API変更の提案**
   ```bash
   git checkout -b feature/add-new-endpoint
   # OpenAPI定義を編集（適切なpathsファイルを修正）
   # 例: contexts/user/paths/cart.yaml に新エンドポイント追加
   pnpm run validate:all
   pnpm run bundle:all
   ```

2. **プルリクエスト作成**
   - 変更内容の説明
   - 影響を受けるクライアントの明記
   - 破壊的変更の有無

3. **レビュー＆マージ**
   - API設計のレビュー
   - 自動検証の確認
   - マージ

4. **リリース**
   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   ```

## 開発のヒント

### 新しいエンドポイントの追加

1. 適切な`paths/*.yaml`ファイルを選択または作成
2. エンドポイント定義を追加
3. メインの`openapi.yaml`に参照を追加（新規ファイルの場合）
4. バリデーションとバンドルを実行

```bash
# 例：ユーザーAPIに新機能追加
echo "新しいエンドポイント定義" >> contexts/user/paths/new-feature.yaml
# contexts/user/openapi.yamlのpathsセクションに参照追加
pnpm run validate:user
pnpm run bundle:user
```

## 各コンテキストの特徴

### Shop API (`/shop/v1`)
- ショップオーナー向け機能
- 商品管理、注文管理、在庫管理
- JWT認証必須

### User API (`/user/v1`)
- エンドユーザー向け機能
- 商品閲覧、カート、購入
- 一部エンドポイントは認証不要

### Admin API (`/admin/v1`)
- システム管理者向け機能
- ユーザー管理、ショップ管理、分析
- 二要素認証対応

## トラブルシューティング

### バンドルエラー
```bash
# キャッシュクリア
rm -rf .redocly-cache
pnpm run bundle:all
```

### 循環参照エラー
共通コンポーネントへの参照パスを確認：
- 相対パス: `../../shared/schemas/common.yaml#/components/schemas/Error`
- 絶対パスは使用しない

## ライセンス

MIT