const path = require("path");
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  entry: path.resolve(__dirname, 'apps/web/assets/index.js'),
  mode: process.env.HANAMI_ENV || 'production',
  output: { path: path.resolve(__dirname, 'public/assets') },
  plugins: [ new MiniCssExtractPlugin() ],
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: 'elm-webpack-loader',
          options: {
            files: [
              path.resolve(__dirname, "apps/web/assets/elm/Main.elm"),
            ],
            debug: process.env.NODE_ENV === 'development'

          }
        }
      },
      {
        test: /\.scss$/,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {
              // you can specify a publicPath here
              // by default it uses publicPath in webpackOptions.output
              publicPath: '../',
              hmr: process.env.NODE_ENV === 'development',
            },
          },
          'css-loader',
          'sass-loader'
        ],
      }
    ]
  }
};
