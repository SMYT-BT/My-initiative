# lecture05:講義概要

## 【概要】

AWSサービスの利用用途例として、Webアプリケーションにスポットを当てる。  
Webアプリケーションを作成することを切り口に基本的なAWSサービスがどのように使用され、どのサービスとの連携が一般的に利用されるかを学ぶ。  
加えて冗長性の基本に触れることで、カスタマーニーズに応えられるような理解力を得る。  

## 【開発作業を実施するにあたって】
- 作業を行うにあたって、「インストールしたモジュール」と「行った作業」を控えておくこと。
- ELBとEC2間はローカル IP 通信になるため、ELBがEIPを呼び出すことはない。
- やるべきことは細分化して行うこと。

【例】
①組み込みサーバー(Puma)でのRailsアプリケーション動作確認  
②組み込みサーバーとUnix Socketを使ったRailsアプリの動作確認  
③Nginxの単体起動確認  
④Nginxと組み込みサーバー、Unix Socket を組み合わせてのRailsアプリケーション動作確認  


## ○冗長化
システムの一部に異常が起こっても機能を継続できるようにすることを指す。  
※実際に予備のシステムを構築する時に手っ取り早く、コストも安く、かつ確実性が高いのはインフラレベルで用意しておくこと。  
※予備の仕組みなので、データのバックアップで問題ないならそれも冗長化。  


### ●ELB(Elastic Load Balancing)  
ELB は負荷分散によって冗長性を担保する仕組み。  

- 裏側で ELB 自体が止まらないように自動拡張される構成
- クロスゾーン負荷分散：ELB 側からで振分が可能なため、AZ を意識する必要もない

【種類】  
- Application Load Balancer(ALB) L7 ロードバランサー  
HTTP/HTTPS に特化。
  
- Network Load Balancer(NLB) L4 ロードバランサー  
発信元 IP の固定化が可能。  
「受け取ったプロトコルをそのまま」バランシングするため、たとえば HTTP 通信の中身をチェックしないといけない、 URL に応じた振分といった機能は使用できません。  

※NLB は固定 IP アドレスを持つため、IP アドレスでアクセスしたいケース、IP アドレス変動が困るケースに有効
  
- Gateway Load Balancer(GWLB) L3 ロードバランサー。  
特殊ケースで利用
  
- Classic Load Balancer(CLB) 旧式ロードバランサー。  
旧式のELB。現在ではほぼ利用はなし。

## ○ストレージ
### ●S3
主にログファイルや画像ファイルなどあまり変更がなくアクセスも多くないものが置かれる。  
ストレージとしての役割だけでなく、静的 Web サイトとしても利用される。  

- key(場所) と value(その場所に格納されたデータ) という形でデータを保持するため、「ファイルシステムとしては」一般的なフォルダーという概念はない。
（このようはファイルシステムをキーバリューストア、と呼ぶ）

# 課題_サンプルアプリケーションとサービスに触れる
## EC2 上にサンプルアプリケーションをデプロイして、動作させる
![](https://github.com/SMYT-BT/My-initiative/blob/bc356e7a486f4def2c60c4db2ce8a07bb854242c/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture05/Picts/pict5-1.png)
## 動作したことを確認し、ELB(ALB)を追加する
![](https://github.com/SMYT-BT/My-initiative/blob/bc356e7a486f4def2c60c4db2ce8a07bb854242c/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture05/Picts/pict5-2.png)
## ELB を加えて動作が確認でき次第、さらに S3 を追加する
![](https://github.com/SMYT-BT/My-initiative/blob/bc356e7a486f4def2c60c4db2ce8a07bb854242c/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture05/Picts/pict5-3.png)
## ここまでが問題無く動作した場合、その環境を構成図に書き起こす
![](https://github.com/SMYT-BT/My-initiative/blob/bc356e7a486f4def2c60c4db2ce8a07bb854242c/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture05/Picts/pict5-4.png)
