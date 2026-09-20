module.exports = {
  // entry = どのファイルを起点にバンドルしていくか
  entry: "./app/javascript/react/main.tsx",
  // バンドルした後、どこにいくか
  output: {
    // __dirname = 現在の階層
    // 現在の階層の下にdistフォルダを作成し、そこにbundle.jsを作成
    path: `${__dirname}/public/react/`,
    filename: "bundle.js",
  },
  mode: "development",
  module: {
    rules: [
      {
        // 拡張子tsのファイル（正規表現）を探して
        test: /(\.ts|\.tsx)$/,
        // typescriptをコンパイルする
        use: "ts-loader",
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    // 拡張子を配列で指定
    extensions: [".tsx", ".ts", ".js"],
  },
};
