module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // 新機能
        'fix',      // バグ修正
        'docs',     // ドキュメントのみの変更
        'style',    // コードの意味に影響を与えない変更（スペース、フォーマット等）
        'refactor', // バグ修正や機能追加を伴わないコード変更
        'perf',     // パフォーマンス改善
        'test',     // テストの追加・修正
        'chore',    // ビルドプロセスやドキュメント生成などの補助ツールやライブラリの変更
        'ci',       // CI設定の変更
        'revert'    // 以前のコミットを元に戻す
      ]
    ],
    'subject-case': [2, 'never', ['sentence-case', 'start-case', 'pascal-case', 'upper-case']],
    'subject-full-stop': [2, 'never', '.'],
    'subject-empty': [2, 'never'],
    'type-empty': [2, 'never']
  }
};