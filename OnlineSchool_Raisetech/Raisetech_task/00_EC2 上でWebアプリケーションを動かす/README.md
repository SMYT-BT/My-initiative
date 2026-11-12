# 実装内容（課題内容）

簡易Webアプリケーションの起動・稼働確認。

Webアプリケーションを作成して自身の名前をＷｅｂ上に表示させることで、Webアプリケーションの仕組みを理解する。
```
以下課題環境を準備したうえで、以降の対応を実施。
① VPC上に（無料枠）インスタンスを１つ作成
② [SpringBoot](https://start.spring.io/) にて、デモンストレーション用のWebアプリケーションデータを作成
③ 上記「②」で作成したデータを VC-CODE の新規プロジェクトに読み込ませる
```


### ① 作成したインスタンスに接続確認

以下コマンドを実行すると、下記のように接続ができる。
```
ssh -i C:\Users\****\Documents\Raisetech\Raisetech_App1020.pem ec2-user@***.***.***.***

The authenticity of host '13.231.146.97 (13.231.146.97)' can't be established.
ED25519 key fingerprint is SHA256:ancJmJkUboFJtr4Lub0N2jLvSa7lb35Yp9NodnV4lOc.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '13.231.146.97' (ED25519) to the list of known hosts.
   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
[ec2-user@ip-10-0-14-185 ~]$
```
### ② RDS作成（注意すべき項目を抜粋）

My SQLを選択。
<img width="931" height="209" alt="image" src="https://github.com/user-attachments/assets/46671e91-b8a3-4cc7-b6bc-a1d91c5f1d38" />

無料枠で作成するため、Single AZ になる。
<img width="905" height="380" alt="image" src="https://github.com/user-attachments/assets/7ab6ecce-56e9-425f-b429-5b38c91e2fec" />

メモ：マスターユーザーは admin としておく。PASSは adminadmin

作成したインスタンスと連携させる。
<img width="909" height="223" alt="image" src="https://github.com/user-attachments/assets/e7cf9e84-68a7-455b-8cd0-f2a8b7279d6c" />

### ③ EC2インスタンスの環境を整備

EC2に接続した状態で、以下コマンドを実行。EC2内の既存AWSサービスの更新。
```
sudo dnf update
```
mysql コマンドを使えるように、My SQLをインストールする。
[参考サイト](https://dev.classmethod.jp/articles/Install-mysql-on-al2023-and-login/)
```
sudo dnf -y install https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
```
mysql のクライアントをインストール。
```
sudo dnf -y install mysql mysql-community-client
```

該当の RDS の詳細画面から以下画像のとおり、選択範囲のコマンドをEC2インスタンス上で実行。

<img width="740" height="149" alt="image" src="https://github.com/user-attachments/assets/6676f9b1-1e39-4d4e-a0f9-21f33c9cba7d" />

以下のように接続完了
```
mysql -h aws-study-database-1.cpg04ysmcz79.ap-northeast-1.rds.amazonaws.com -P 3306 -u admin -p
```
<img width="854" height="225" alt="image" src="https://github.com/user-attachments/assets/8335df23-8f29-4ed5-a3d4-9f0a6c92ef94" />


立ち上げた springboot は下記のように port 8080 の接続になる。
```
2026-11-12T08:10:46.819Z  INFO 29086 --- [demo] [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port 8080 (http) with context path '/'
```

そのため、EC2インスタンスのセキュリティグループにて、8080 用のルールを以下のように作る必要がある。
<img width="895" height="51" alt="image" src="https://github.com/user-attachments/assets/7a0f1330-a8d2-4af1-9814-dd5131f02a8f" />

URL「13.231.146.97:8080」を検索すると、以下のようなページに遷移。
<img width="959" height="188" alt="image" src="https://github.com/user-attachments/assets/1266a28f-735a-40a0-97d7-6240d4b2386b" />



以下、AWSインスタンスにインストール（および取得）

・my sql クライアント

・MySQL クライアント関連のパッケージ

・Java(Ver.21)

・git

・課題用プロジェクト（git clone で取得）

# 動作確認（対応事項）

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

⑥自身の名前がWebアプリケーションの処理結果として、Ｗｅｂ上に表示されることを確認。

※別ファイル「Webアプリケーション実行結果画像.png」を参照

# 工夫した点・学んだこと

・シンプルな考えではあるが、事象の切り分け方としてシステム構成側の問題か、ユーザデータ側の問題か、切り分けることができると感じた。つまり、プロジェクトを遂行する際、この両面の要件が正確に設定されているか確実に確認するためのチェックシートなどがあると、対応漏れや・設定の見直し・新人への理解促進につながると感じた。
