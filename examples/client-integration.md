# クライアント統合例

## Next.js (TypeScript) - ユーザーフロントエンド

### 1. package.json

```json
{
  "scripts": {
    "generate:api": "curl -L https://github.com/furupura/furupura-openapi/releases/latest/download/user.openapi.yaml -o openapi.yaml && openapi-generator-cli generate -i openapi.yaml -g typescript-axios -o src/api --additional-properties=withSeparateModelsAndApi=true",
    "postinstall": "npm run generate:api"
  }
}
```

### 2. API クライアントの設定

```typescript
// src/lib/api-client.ts
import { Configuration, DefaultApi } from '@/api';

const config = new Configuration({
  basePath: process.env.NEXT_PUBLIC_API_URL || 'https://api.furupura.jp/user/v1',
  accessToken: () => {
    // トークン取得ロジック
    return localStorage.getItem('access_token') || '';
  },
});

export const apiClient = new DefaultApi(config);
```

### 3. 使用例

```typescript
// src/app/products/page.tsx
import { apiClient } from '@/lib/api-client';

export default async function ProductsPage() {
  const { data } = await apiClient.browseProducts({
    page: 1,
    perPage: 20,
  });

  return (
    <div>
      {data.data.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  );
}
```

## React Native - モバイルアプリ

### 1. API生成スクリプト

```bash
#!/bin/bash
# scripts/generate-api.sh

OPENAPI_VERSION=${1:-latest}

curl -L "https://github.com/furupura/furupura-openapi/releases/download/${OPENAPI_VERSION}/user.openapi.yaml" \
     -o openapi.yaml

npx @openapitools/openapi-generator-cli generate \
  -i openapi.yaml \
  -g typescript-fetch \
  -o src/api \
  --additional-properties=typescriptThreePlus=true
```

### 2. APIクライアント

```typescript
// src/services/api.ts
import { DefaultApi, Configuration } from '../api';
import AsyncStorage from '@react-native-async-storage/async-storage';

const apiConfig = new Configuration({
  basePath: 'https://api.furupura.jp/user/v1',
  accessToken: async () => {
    const token = await AsyncStorage.getItem('access_token');
    return token || '';
  },
});

export const api = new DefaultApi(apiConfig);
```

## Vue.js - 管理画面

### 1. Vite設定

```typescript
// vite.config.ts
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [
    {
      name: 'generate-api',
      buildStart: async () => {
        const { execSync } = require('child_process');
        execSync('npm run generate:api');
      },
    },
  ],
});
```

### 2. Pinia Store

```typescript
// src/stores/products.ts
import { defineStore } from 'pinia';
import { apiClient } from '@/lib/api';

export const useProductsStore = defineStore('products', {
  state: () => ({
    products: [],
    loading: false,
  }),

  actions: {
    async fetchProducts() {
      this.loading = true;
      try {
        const response = await apiClient.listProducts();
        this.products = response.data.data;
      } finally {
        this.loading = false;
      }
    },
  },
});
```

## GitHub Actions - 自動更新

```yaml
# .github/workflows/update-api-client.yml
name: Update API Client

on:
  repository_dispatch:
    types: [openapi-updated]

jobs:
  update:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Download OpenAPI spec
        run: |
          curl -L "https://github.com/furupura/furupura-openapi/releases/download/${{ github.event.client_payload.version }}/user.openapi.yaml" \
               -o openapi.yaml

      - name: Generate client
        run: |
          npx @openapitools/openapi-generator-cli generate \
            -i openapi.yaml \
            -g typescript-axios \
            -o src/api

      - name: Create PR
        uses: peter-evans/create-pull-request@v5
        with:
          title: 'chore: update API client to ${{ github.event.client_payload.version }}'
          commit-message: 'chore: update API client'
          branch: update-api-client-${{ github.event.client_payload.version }}
```

## SDK開発例

```typescript
// @furupura/js-sdk/src/index.ts
export class FurupuraSDK {
  private shopApi: ShopApi;
  private userApi: UserApi;
  private adminApi: AdminApi;

  constructor(config: SDKConfig) {
    this.shopApi = new ShopApi(config.shopApiKey);
    this.userApi = new UserApi(config.userApiKey);
    this.adminApi = new AdminApi(config.adminApiKey);
  }

  get shop() {
    return this.shopApi;
  }

  get user() {
    return this.userApi;
  }

  get admin() {
    return this.adminApi;
  }
}

// 使用例
const sdk = new FurupuraSDK({
  shopApiKey: process.env.SHOP_API_KEY,
  userApiKey: process.env.USER_API_KEY,
  adminApiKey: process.env.ADMIN_API_KEY,
});

const products = await sdk.shop.products.list();
```
