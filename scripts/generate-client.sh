#!/bin/bash

# クライアントコード生成スクリプト
# 使用例: ./scripts/generate-client.sh shop typescript-axios ./generated

CONTEXT=$1
GENERATOR=$2
OUTPUT_DIR=$3

if [ -z "$CONTEXT" ] || [ -z "$GENERATOR" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Usage: ./scripts/generate-client.sh <context> <generator> <output_dir>"
    echo "Context: shop, user, admin"
    echo "Generator: typescript-axios, typescript-fetch, swift5, kotlin, etc."
    exit 1
fi

# OpenAPI Generatorを使用してクライアントコード生成
docker run --rm \
    -v "${PWD}:/local" \
    openapitools/openapi-generator-cli:latest generate \
    -i "/local/bundled/${CONTEXT}.openapi.yaml" \
    -g "$GENERATOR" \
    -o "/local/${OUTPUT_DIR}" \
    --additional-properties=npmName=@furupura/${CONTEXT}-api-client,npmVersion=1.0.0

echo "Client code generated in ${OUTPUT_DIR}"