# 課題_lecture03
## 講座内で展開されているサンプルアプリケーションをCloud9で稼働させる

### ①サンプルアプリケーションの入手

※オンラインコンテンツのため、省略

### ②MySQLのインストール
「①」にて、展開されている手順に沿って、MySQLをインストール。

【エラー対応】
以下コマンドにて失敗
- sudo yum install -y mysql-community-devel
- sudo yum install -y mysql-community-server


＜エラーメッセージ＞
GPG key retrieval failed: [Errno 14] curl#37 - "Couldn't open file /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql-2022"
（※GCP鍵でエラーの発生の意味）

[外部参考サイト]
- https://qiita.com/nishikawa1031/items/b31e4fb579e167778c45
- https://labor.ewigleere.net/2022/02/22/error-at-install-mysql-community-server-import-rpm-pgp-key/


【対応】
- 変更→sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
- root権限に移動後、vi /etc/yum.repos.d/mysql-community.repoを実施。

### ③初期パスワードの確認

⇒My SQLインストール完了


### ④Rails アプリケーションのデプロイ
●bundlerの入手

- 「gem install bundler」を実行。
- 「bundle install 」※gem file のインストール）を実行。

※bundle installとは、bundlerを使ってGemfileからgemをインストールするコマンド。　
　
「bundle update」を念のため実行。

- 「rails -v」でRuby on railsのバージョン5.0.0であることを確認。


### ⑤データベース作成

- config file /database.yml に　SQLのパスワード添付
- bundle exec rails db:create　実行。


【エラーメッセージ】
Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)

Couldn't create 'raisetech_live8_sample_app_development' database. Please check your configuration.
rake aborted!

ActiveRecord::ConnectionNotEstablished: Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)


【対応】

Mysqlへログインして、以下実行。
- select * from mysql.user where user='root'\G  #「\」は逆スラッシュ

→以下、レスポンス
ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.

- config file /database.ymlを以下に変更

「/tmp/mysql.sock」 を 「/var/lib/mysql/mysql.sock」に変更。

- ALTER USER 'root'@'localhost' IDENTIFIED BY '複雑なパスワード';
- 「ALTER USER 'root'@'localhost' IDENTIFIED BY '6FOilzoij@$$';」実行

→Query OK, 0 rows affected (0.05 sec)
⇒再度、「bundle exec rails db:create」を実行。


【エラーメッセージ】

rake aborted!


【対応】
- gem list lake→何もない
- gem install rake -v 12.3.3　→　bundle update rake

⇒何故か表示されない
![](https://github.com/SMYT-BT/My-initiative/blob/main/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture03/Picts/Pict1.png)

- スペルミス 　〇gem list rake
- database.ymlがちゃんと保存できていなかった

⇒再度、bundle exec rails db:create

- Running via Spring preloader in process 4294

- Created database 'raisetech_live8_sample_app_development'

- Created database 'raisetech_live8_sample_app_test'

⇒成功


- 「bundle exec rails db:migrate」を実行。
- rails sの実行

※rails s：サーバーを起動


【エラーメッセージ】
ネットワークのエラー。


【対応】
- メッセージの下部にある以下メッセージを、development.rbに記載

「config.hosts << "5a0a555aa03143beab3df992f27badc5.vfs.cloud9.ap-northeast-1.amazonaws.com"」

- 「bundle exec  rails webpacker:install」を実行。


【エラーメッセージ】
Yarn not installed. Please download and install Yarn from https://yarnpkg.com/lang/en/docs/install/
Exiting!


【対応】
- npm install yarn

(パッケージのインストールに使うnpm install)

- 再度、bundle exec rails webpacker:install

⇒ Webpacker successfully installed
※ポイント：必要なパッケージがちゃんとインストールされているか確認すること


- 再度rails sの実行
⇒画像が表示されない

- 画像をアップロードして、以下確認。

 【エラーメッセージ】
You must have ImageMagick or GraphicsMagick installed

＜apt-getについて＞https://qiita.com/chisaki0606/items/fda0d0a67954b75b8bb5
![](https://github.com/SMYT-BT/My-initiative/blob/main/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture03/Picts/Pict2.png)

【対応】
「sudo yum -y install ImageMagick ImageMagick-devel」実行

＜気付きを得たサイト＞https://zenn.dev/takahashim/articles/507589508ae2d5


★対応完了★
![](https://github.com/SMYT-BT/My-initiative/blob/main/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture03/Picts/Pict3.png)