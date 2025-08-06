# Furupura OpenAPI Definitions

ふるぷらAPIの契約定義リポジトリです。境界コンテキストごとにOpenAPI定義を分割管理しています。

## 構造

```
furupura-openapi/
├── contexts/           # 境界コンテキスト別定義
│   ├── shop/          # ショップ向けAPI
│   ├── user/          # ユーザー向けAPI
│   └── admin/         # 管理者向けAPI
├── shared/            # 共通コンポーネント
│   ├── schemas/       # 共通スキーマ
│   ├── parameters/    # 共通パラメータ
│   └── responses/     # 共通レスポンス
├── bundled/           # ビルド済みファイル（自動生成）
└── scripts/           # ユーティリティスクリプト
```

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
   # OpenAPI定義を編集
   pnpm run validate:all
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