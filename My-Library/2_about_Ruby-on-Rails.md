# Ruby on Rails について学習
## ■Ruby on Railsとは
Webアプリの開発に使われることの多い、オープンソースのWebアプリケーションフレームワーク。


- gem（各パッケージ）とは
Ruby のパッケージであり、パッケージ管理システム（Ruby Gemsを指す）

※最近はbundlerを使用する

例えば、ユーザー登録機能や認証機能といった複雑な機能も、gemを使えば簡単に実装可能にするような機能。

- Bundlerとは

gemを管理するためのツール。bundler自体もgemの一種。

bundlerを使うことで、複数のgemの依存関係を保ちながらgemの管理ができる。

【例】

gemAのバージョン2を使うためにgemBのバージョン1が必要なとき。

gemAとgemBは依存関係があるといい、単なるgemの組み合わせだけでなく、どのバージョン同士を組み合わせるかどうかが密接に関連する。

→誤ってgemBのバージョン2を誤って入れてしまった場合には、gemAが正常に動作しない可能性がある。

上記のように、gem同士はさまざまな依存関係にあり、管理するgemの数が増えるほど複雑になっていく。

bundlerはこのようなgem同士の依存関係を管理できるツール。

→bundlerを使うことで、依存関係にあるgemを一括インストールすることができる。


＜Ruby基礎知識＞https://tech-camp.in/note/technology/1056/

＜Ruby環境構築方法＞https://pikawaka.com/rails/curriculums-rails-basic-aws-cloud9-rails-environment

＜Railsの処理の流れ＞https://diveintocode.jp/blogs/Technology/ProcessFlow

＜Railsアプリケーションのファイル構造＞http://www.code-magagine.com/?p=4326

＜Railsアプリのレビュー方法＞https://blog.proglus.jp/3893/

■補足

- gem install bundlerでbundler（gem）をインストール

⇒なぜ必要か：依存関係に則したバージョン管理をするため

＜参考＞https://techplay.jp/column/529


- rails new の実施

⇒新しいRailsプロジェクトの作成

＜参考＞：https://railstutorial.jp/chapters/beginning?version=5.1

※1.3 最初のアプリケーション、より


- rails new weblog -d mysql　を実行：My SQLを使用したアプリケーションであることを明示

＜参考＞：https://railsdoc.com/page/rails_new

-Railsのバージョン指定してインストールする方法

＜参考＞https://qiita.com/ibarakishiminn/items/84838c810e3ddc2c4b9e
