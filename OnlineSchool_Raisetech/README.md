# はじめに
本リポジトリは、自身の学習結果と知識・スキルを管理しています。
# 方針
オンラインスクール「Raisetech  -AWSフルコース講座」を通して得た、
また個人で調べ得た学習内容等を都度、追加、更新すること。
# 学習上、使用するツール
- GitHub
- AWS
------------------------------
# 学習概要
## 業務で利用するAI
・perplexity

・ChatGPT

## 開発環境
### Visual Studio Code

・複数プラグインを導入して自分オリジナルにできる

→YAML

→CloudFormation Linter

→HashiCorp Terraform

→Prettier - Code formatter

→Markdown All in One

→Draw.io Integration

→Git History

→Markdown All in One

→Extension Pack for Java

●[spring boot](https://start.spring.io/)

JavaでのWebアプリケーションやマイクロサービス開発を簡単かつ迅速に行うためのオープンソースフレームワーク

⇒ 実行結果を表示させるために、Java21が必要⇒インストール

・SpringbootはSNAPSHOTのついていないバージョンを選択

・.vscode フォルダに格納

⇒Java21をインストールしないとうまくいかない

# 提出課題１：簡易Webアプリケーションの起動・稼働確認

以下、AWSインスタンスにインストール（および取得）

・my sql クライアント

・MySQL クライアント関連のパッケージ

・Java(Ver.21)

・git

・課題用プロジェクト（git clone で取得）

①chmod 755 gradlew

⇒Webアプリケーション起動のために権限変更

②cd src/main/resources

⇒Webアプリケーションに表示する内容やプロパティのユーザデータを更新

**※パスワードを更新していなかったため、エラーに衝突**

③「②」の「create.sql」に記載されているテーブル情報を MySQL 上で実施

（データベースにテーブルを新規追加する）

④use study; , select * from student;

⇒「③」で追加した情報が更新されているか確認する。

⑤./gradlew bootRun（WebAPPの実行）

🌟結果として以下画面が表示される（塗りつぶしは個人名であるため）

<img width="959" height="599" alt="スクリーンショット 2026-10-21 173816" src="https://github.com/user-attachments/assets/dde05e9b-c4cb-4fd7-833a-b7c5700f880b" />
