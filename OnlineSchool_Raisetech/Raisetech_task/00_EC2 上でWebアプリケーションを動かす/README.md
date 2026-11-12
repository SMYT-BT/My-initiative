# 実装内容（課題内容）

簡易Webアプリケーションの起動・稼働確認。
Webアプリケーションを作成して自身の名前をＷｅｂ上に表示させることで、Webアプリケーションの仕組みを理解する。
```
以下課題環境を準備したうえで、以降の対応を実施。
① VPC上に（無料枠）インスタンスを１つ作成
② [SpringBoot](https://start.spring.io/) にて、デモンストレーション用のWebアプリケーションデータを作成
③ 上記「②」で作成したデータを VC-CODE の新規プロジェクトに読み込ませる
```
# 動作確認（対応事項）

### ① 作成したインスタンスに接続確認

以下 ssh コマンドを実行すると、下記のように接続ができる。
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
-----------------------

### ② RDS作成（注意すべき項目を抜粋）

My SQLを選択。
<img width="931" height="209" alt="image" src="https://github.com/user-attachments/assets/46671e91-b8a3-4cc7-b6bc-a1d91c5f1d38" />

無料枠で作成するため、Single AZ になる。
<img width="905" height="380" alt="image" src="https://github.com/user-attachments/assets/7ab6ecce-56e9-425f-b429-5b38c91e2fec" />


作成したインスタンスと連携させる。
<img width="909" height="223" alt="image" src="https://github.com/user-attachments/assets/e7cf9e84-68a7-455b-8cd0-f2a8b7279d6c" />

 ⇒ **今回、「awsstudy」というデータベース名で作成した。**

-----------------------

### ③ EC2インスタンスの環境を整備

〇 EC2に接続した状態で、以下コマンドを実行。EC2内の既存AWSサービスの更新。
```
sudo dnf update
```
〇 mysql コマンドを使えるように、My SQLをインストールする。
[参考サイト](https://dev.classmethod.jp/articles/Install-mysql-on-al2023-and-login/)
```
sudo dnf -y install https://dev.mysql.com/get/mysql84-community-release-el9-1.noarch.rpm
```
〇 mysql のクライアントをインストール。
```
sudo dnf -y install mysql mysql-community-client
```
〇 JAVA をインスタンスにインストールする。そのため、インストールできるものを一覧で確認。
```
sudo dnf list --available "java-*corretto*"
```
〇 以下にて、Javaをインストールする。(Ver.21)
```
sudo dnf install java-21-amazon-corretto-devel.x86_64
```
〇 （バージョン管理システムとして）gitをインストール
```
sudo dnf install git
```
〇 スクールの授業用に用意されたプロジェクトを（リモートで）インストールする。
```
git clone https://github.com/～（省略）
```

該当の RDS の詳細画面から以下画像のとおり、選択範囲のコマンドをEC2インスタンス上で実行。

<img width="740" height="149" alt="image" src="https://github.com/user-attachments/assets/6676f9b1-1e39-4d4e-a0f9-21f33c9cba7d" />

以下のように接続完了
```
mysql -h aws-study-database-1.cpg04ysmcz79.ap-northeast-1.rds.amazonaws.com -P 3306 -u admin -p
```
<img width="854" height="225" alt="image" src="https://github.com/user-attachments/assets/8335df23-8f29-4ed5-a3d4-9f0a6c92ef94" />

-----------------------

 ### ④ Webアプリケーションの起動確認
Webアプリケーションの実行に伴い、権限上の問題があるため以下コマンドのように権限変更した後に、Webアプリケーションを起動。
以下画像のようにWebアプリケーションが立ち上がる。
```
chmod 755 gradlew
./gradlew bootRun　　　※初回はダウンロードから始まる
```
<img width="942" height="453" alt="スクリーンショット 2026-11-12 1713065676890-" src="https://github.com/user-attachments/assets/d467bd06-46cf-4b55-9d90-637f4c3aefb9" />
 
上記赤線のように、立ち上げた springboot は port 8080 の接続でないとアクセスできない。
 
 ⇒ EC2インスタンスのセキュリティグループのインバウンドルールに 8080 用のルールを作る必要がある。

更新すると、URL「13.231.146.97:8080」を検索すると、「このサイトにアクセスできません」が、以下のようなページに遷移。
※「//13.231.146.97:8080/」みたいに、末尾に :8080 をつける。

<img width="959" height="188" alt="image" src="https://github.com/user-attachments/assets/1266a28f-735a-40a0-97d7-6240d4b2386b" />

-----------------------

### ⑤ Webアプリケーションを正常に稼働させる

・Webアプリケーションのプロパティにて、データの参照先（database.url）を間違えているため下記のようにDBを指定してあげる。

・また、プロパティに記載されているユーザデータが異なった情報であったため、更新。
```
spring.datasource.url=jdbc:mysql://aws-study-database-1.cpg04ysmcz79.ap-northeast-1.rds.amazonaws.com:3306/awsstudy
spring.datasource.username=admin
spring.datasource.password=************
```
以下コマンドで、データベースを切り替えスクール側指定のテーブルを作成する。

※VALUES ('Your Name')　には受講者の名前を入れる。
```
use awsstudy
```
```
CREATE TABLE IF NOT EXISTS student (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL
);

INSERT INTO student (name) VALUES ('Your Name');
```

-----------------------

### ⑥ 作業結果

・CLI 上から、再度Webアプリケーションを起動
・インスタンスのIPの末尾にポート番号をつけてアクセス

⇒問題なく自身の名前が表示されることを確認。
※別ファイル「Webアプリケーション実行結果画像.png」を参照

-----------------------

# 工夫した点・学んだこと

・ユーザーデータや、そのシステムのプロパティのパラメータ値を理解しておくと初動の切り分けが少し楽になると感じた。

・シンプルな考えではあるが、事象の切り分け方としてシステム構成側の問題か、ユーザデータ側の問題か、切り分けることができると感じた。つまり、プロジェクトを遂行する際、この両面の要件が正確に設定されているか確実に確認するためのチェックシートなどがあると、対応漏れや・設定の見直し・新人への理解促進につながると感じた。
