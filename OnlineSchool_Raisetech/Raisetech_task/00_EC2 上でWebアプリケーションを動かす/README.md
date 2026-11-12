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
