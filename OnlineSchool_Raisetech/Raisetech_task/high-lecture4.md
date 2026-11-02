## 実装内容（課題内容）
これまでの講義内容を踏まえて、以下インフラ構成をAWSのCloudFormation を用いて作成すること
- Web アプリケーションの作成を想定して、EC2 を利用
- RDS を利用すること
- ELB（ALB）を利用すること　※ただし、冗長化構成にはしない

## 動作確認（対応事項）
### 1.ChatGPTでインフラ構成図を作成
以下指示内容。
```
AWSサービスにて、以下条件のインフラ構造が構築したいです。AWSサービスのサービスアイコンを用いて、インフラ構成図を作成してみてください。
・VPCを使うこと。
・Internet Gateway を使うこと
・冗長化構成として、ELBを使用する。
・ELBのデータ転送先は２つであり、その先にEC2を作成する。
・作成したEC2のデータベースとしてRDSを作成する。
・RDSは終了保護をつけること
・NAT Gateway は使わないこと。
・無料利用枠を可能な限り利用すること
・セキュリティグループを作る
・EC2はパブリックサブネットの上に、RDSはプライベートサブネット上に作成
```
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/e779df4c-b772-4933-beb3-a74f861b6df7" />

### 2.インフラ構成図をもとに、ChatGPTでコード文作成
※基本的な作成テンプレートを把握しており、手入力による工数削減をシミュレーション
以下、指示内容
```
今作成いただいた画像通りの内容をAWSサービス CloudFormation で構築できるように、YAML形式のコード文を記載してください。
```
### 3.コード文を検閲・添削・修正
※修正箇所は「[ChatGPT 出力結果修正箇所](https://github.com/SMYT-BT/My-initiative/blob/main/OnlineSchool_Raisetech/Raisetech_task/high-lecture4.md#chatgpt-%E5%87%BA%E5%8A%9B%E7%B5%90%E6%9E%9C%E4%BF%AE%E6%AD%A3%E7%AE%87%E6%89%80)」にて記載
### 4.トライ＆エラー
【1回目】インスタンスの作成まで（ELBとRDSの作成を省く）

→既存のキーペアの指定ができておらず失敗
```
・変更点：My KeyPair → Raisetech_App1020
```
⇒作成成功

【2回目】RDS の作成で失敗
```
【エラーメッセージ】
Resource handler returned message: "Cannot find version 8.0.41 for mysql (Service: Rds, Status Code: 400, Request ID: 42dbced4-6b46-4bda-82ec-ae80242d9d37)
```
```
→RDSの指定したバージョンが古かった
・変更点：8.0.41 → 8.4.11
```
⇒最新のバージョンを指定して作成成功
<img width="941" height="382" alt="image" src="https://github.com/user-attachments/assets/a61406b3-4b31-4dc5-9de0-1d5fdb696794" />
### 5.CloudFormation実演講座にて、答え合わせ。一部手を加える。
※加筆箇所は「[講義視聴後の加筆箇所](https://github.com/SMYT-BT/My-initiative/blob/main/OnlineSchool_Raisetech/Raisetech_task/high-lecture4.md#%E8%AC%9B%E7%BE%A9%E8%A6%96%E8%81%B4%E5%BE%8C%E3%81%AE%E5%8A%A0%E7%AD%86%E7%AE%87%E6%89%80)」にて記載

## ChatGPT 出力結果修正箇所
### 〇各セキュリティグループ
```
・SecurityGroupEgressが抜けていた
・ALBのセキュリティグループを削除
```
### 〇サブネット
```
AZを指定：ap-northeast-1* など
※以下変更前の記載
AvailabilityZone: !Select
      - 1
      - !GetAZs ''
```
### 〇EC2
以下内容を追記。
```
・DisableApiTermination: false
・InstanceInitiatedShutdownBehavior: stop
・KeyName: Raisetech_App1020
・Monitoring: false
```
### 〇ALB(ターゲットグループ)
以下内容を追記。
```
・HealthCheckPort: "traffic-port"
・HealthCheckIntervalSeconds: 10

・Tags:     #Tags 丸ごと不足
        - Key: Name
          Value: ALB-Target-Group
```
### 〇RDS
以下内容を追記。
```
・AllowMajorVersionUpgrade: false
・AutoMinorVersionUpgrade: true 
・StorageType: gp2
・Master User Password: admin1101
・DBName: appdb
・ Engine: mysql
・LicenseModel: general-public-license
```
## 講義視聴後の加筆箇所
### 〇RDS
```
・AllowMajorVersionUpgrade: false
・AutoMinorVersionUpgrade: true
・PreferredBackupWindow: 15:00-16:00 #不足部分
・PreferredMaintenanceWindow: sun:18:00-sun:19:00 #不足部分
```
## 工夫した点・学んだこと
- 講義中でも取り上げられた、AI の回答結果が正しいとは限らないを実感できた
  （正しいとは限らない、とともに依頼した支持の不明確さもある）
- 実現場での動きを想定して、ChatGPTにベースを作成＋必要箇所を修正という形式を実施
