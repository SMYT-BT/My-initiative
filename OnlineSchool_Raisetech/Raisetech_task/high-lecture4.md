# 提出物であるCloudFormation のYAMLコードは[課題提出](https://github.com/SMYT-BT/My-initiative/blob/main/OnlineSchool_Raisetech/Raisetech_task/high-lecture4.md#%E8%AA%B2%E9%A1%8C%E6%8F%90%E5%87%BAcloudformation-yaml%E3%82%B3%E3%83%BC%E3%83%89)に記載しています。

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
・PreferredBackupWindow: 15:00-16:00
・PreferredMaintenanceWindow: sun:18:00-sun:19:00
```
## 工夫した点・学んだこと
- 講義中でも取り上げられた、AI の回答結果が正しいとは限らないを実感できた
  （正しいとは限らない、とともに依頼した支持の不明確さもある）
- 実現場での動きを想定して、ChatGPTにベースを作成＋必要箇所を修正という形式を実施

## 課題提出：CloudFormation YAMLコード
```
AWSTemplateFormatVersion: '2010-09-09'
Description: AWS Web Application Infrastructure
# ==========================================
# Parameters
# ==========================================
#ホストユーザのIPアドレス生成
Parameters:
  MyIPAddress:
    Type: String
    Description: SSH接続を許可するグローバルIPアドレス（/32付き）
    AllowedPattern: '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}/32$'
    ConstraintDescription: IPv4アドレスを xxx.xxx.xxx.xxx/32 の形式で入力してください。

# ==========================================
# Resources
# ==========================================
Resources:
  # ----------------------------------------
  # VPC
  # ----------------------------------------
  MyVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags:
        - Key: Name
          Value: MyVPC

  # ----------------------------------------
  # Internet Gateway
  # ----------------------------------------
  MyInternetGateway:
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
        - Key: Name
          Value: MyInternetGateway

  AttachInternetGateway:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref MyVPC
      InternetGatewayId: !Ref MyInternetGateway

  # ----------------------------------------
  # Public Subnets
  # ----------------------------------------
  PublicSubnetA:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: 10.0.1.0/24
      AvailabilityZone: ap-northeast-1a 
      #もともと!Select だった⇒リストの中から指定した番号の要素を取得する関数。
      #番号は 0から始まる ことに注意してください。
      #0:ap-northeast-1a,1:ap-northeast-1c,2:ap-northeast-1d
      # - 0
      # - !GetAZs ''  
      #!GetAZs '' はAZの一覧を取得する関数。空文字 '' は現在のスタックが存在するリージョンを意味する。
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: PublicSubnet-A

  PublicSubnetC:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: 10.0.2.0/24
      AvailabilityZone: ap-northeast-1c
      #もともと!Select だった⇒同上
      # - 1
      # - !GetAZs ''
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: PublicSubnet-C

  # ----------------------------------------
  # Private Subnets
  # ----------------------------------------
  PrivateSubnetA:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: 10.0.11.0/24
      AvailabilityZone: ap-northeast-1a
      #もともと!Select だった⇒同上
      #  - 0
      #  - !GetAZs ''
      Tags:
        - Key: Name
          Value: PrivateSubnet-A

  PrivateSubnetC:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref MyVPC
      CidrBlock: 10.0.12.0/24
      AvailabilityZone: ap-northeast-1c
      #もともと!Select だった⇒同上
      #  - 1
      #  - !GetAZs ''
      Tags:
        - Key: Name
          Value: PrivateSubnet-C

  # ----------------------------------------
  # Public Route Table
  # ----------------------------------------
  PublicRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref MyVPC
      Tags:
        - Key: Name
          Value: PublicRouteTable

  PublicRoute:
    Type: AWS::EC2::Route
    DependsOn: AttachInternetGateway
    Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref MyInternetGateway

  PublicSubnetAssociationA:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnetA
      RouteTableId: !Ref PublicRouteTable

  PublicSubnetAssociationC:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnetC
      RouteTableId: !Ref PublicRouteTable

  # ----------------------------------------
  # Private Route Table
  # No NAT Gateway
  # ----------------------------------------
  PrivateRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref MyVPC
      Tags:
        - Key: Name
          Value: PrivateRouteTable

  PrivateSubnetAssociationA:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PrivateSubnetA
      RouteTableId: !Ref PrivateRouteTable

  PrivateSubnetAssociationC:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PrivateSubnetC
      RouteTableId: !Ref PrivateRouteTable

  # ----------------------------------------
  # Security Groups
  # ----------------------------------------
  #ALB Security Group
  ALBSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow HTTP from Internet
      VpcId: !Ref MyVPC
      SecurityGroupIngress:
        # HTTP
        - IpProtocol: tcp
          FromPort: 8080
          ToPort: 8080
          CidrIp: 0.0.0.0/0
        # HTTPS
        #- IpProtocol: tcp
        #  FromPort: 443
        #  ToPort: 443
        #  CidrIp: 0.0.0.0/0

      # EC2へのアプリケーション通信
      SecurityGroupEgress: #外に出すデータ
        - IpProtocol: -1
          CidrIp: 0.0.0.0/0
      Tags:
        - Key: Name
          Value: ALB-SG

  # EC2 Security Group
  EC2SecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow HTTP SSH and application access
      VpcId: !Ref MyVPC
      SecurityGroupIngress:
        # Application(ALBからのみ許可)
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          SourceSecurityGroupId: !Ref ALBSecurityGroup

        # SSH(メンテナンス用:自身のIP)
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: !Ref MyIPAddress

      SecurityGroupEgress: #外に出すデータ 丸ごと抜けていた
        - IpProtocol: -1
          CidrIp: 0.0.0.0/0
      Tags:
        - Key: Name
          Value: EC2-SG

  #RDS Security Group
  RDSSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow MySQL from EC2 only
      VpcId: !Ref MyVPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 3306
          ToPort: 3306
          SourceSecurityGroupId: !Ref EC2SecurityGroup

      SecurityGroupEgress: #外に出すデータ 丸ごと抜けていた
        - IpProtocol: -1
          CidrIp: 0.0.0.0/0
      Tags:
        - Key: Name
          Value: RDS-SG

  # ----------------------------------------
  # Application Load Balancer
  # ----------------------------------------
  MyALB:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Name: My-ALB
      Scheme: internet-facing
      Type: application
      Subnets:
        - !Ref PublicSubnetA
        - !Ref PublicSubnetC
      SecurityGroups:
        - !Ref ALBSecurityGroup
      Tags:
        - Key: Name
          Value: MyALB

  # ----------------------------------------
  # EC2 Instance
  # ----------------------------------------
  EC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: '{{resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64}}'
      InstanceType: t2.micro
      SubnetId: !Ref PublicSubnetA
      DisableApiTermination: false #EC2インスタンスの終了保護を無効にする設定
      InstanceInitiatedShutdownBehavior: stop #EC2内部からシャットダウン操作を行った際の動作：EC2を停止
      KeyName: Raisetech_App1020 #ChatGPTの回答不足部分
      #★引っ掛かりポイント：キーペアは既存のものを★
      Monitoring: false #EC2インスタンスの詳細モニタリングを無効

      SecurityGroupIds:
        - !Ref EC2SecurityGroup
      Tags:
        - Key: Name
          Value: WebServer-EC2

  # ----------------------------------------
  # Target Group
  # ----------------------------------------
  MyTargetGroup:
    Type: AWS::ElasticLoadBalancingV2::TargetGroup
    Properties:
      Name: My-Target-Group
      Port: 8080
      Protocol: HTTP
      VpcId: !Ref MyVPC
      HealthCheckProtocol: HTTP
      HealthCheckPath: "/"
      HealthCheckPort: "traffic-port" #ヘルスチェックを実行するポート番号を指定する設定
      HealthCheckIntervalSeconds: 10 #ヘルスチェックを実行する間隔を秒単位で指定する
      TargetType: instance 
      Matcher:
        HttpCode: '200'
      Targets:
        - Id: !Ref EC2Instance
          Port: 8080
      Tags:     #Tags ChatGPTの回答不足部分
        - Key: Name
          Value: ALB-Target-Group

  # ----------------------------------------
  # ALB Listener
  # ----------------------------------------
  MyALBListener:
    Type: AWS::ElasticLoadBalancingV2::Listener
    Properties:
      LoadBalancerArn: !Ref MyALB
      Port: 80
      Protocol: HTTP
      DefaultActions:
        - Type: forward
          TargetGroupArn: !Ref MyTargetGroup

  # ----------------------------------------
  # RDS DB Subnet Group
  # ----------------------------------------
  MyDBSubnetGroup:
    Type: AWS::RDS::DBSubnetGroup
    Properties:
      DBSubnetGroupDescription: Private subnets for RDS
      SubnetIds:
        - !Ref PrivateSubnetA
        - !Ref PrivateSubnetC
      Tags:
        - Key: Name
          Value: RDS-Subnet-Group

  # ----------------------------------------
  # RDS MySQL
  # ----------------------------------------
  MyRDS:
    Type: AWS::RDS::DBInstance
    #DeletionPolicy: Retain　CloudFormationスタックを削除したときに、対象リソースを削除せず残す設定
    #UpdateReplacePolicy: Retain CloudFormationの更新によってリソースが置き換えられる際、古いリソースを削除せず残す設定
    Properties:
      AllocatedStorage: '20'
      AllowMajorVersionUpgrade: false #メジャーバージョンアップグレードを許可するかどうか
      AutoMinorVersionUpgrade: true #マイナーバージョンアップグレードを自動的に適用するかどうか
      DBInstanceClass: db.t4g.micro #もともとt3
      Port: 3306 #ChatGPTの回答不足部分
      StorageType: gp2
      BackupRetentionPeriod: 1
      MasterUsername: admin
      #ManageMasterUserPassword: true⇒Secrets Managerによる自動管理を利用する方法がおすすめ。
      #上記の場合、下記の「MasterUserPassword」は消すこと
      ManageMasterUserPassword: true
      DBName: appdb
      Engine: mysql
      EngineVersion: 8.4.11 #無料枠で最新Verの自動適用方法はない
      LicenseModel: general-public-license #ChatGPTの回答不足部分
      DBSubnetGroupName: !Ref MyDBSubnetGroup
      PubliclyAccessible: false #RDSをインターネットから直接接続できる状態にするかを指定
      StorageEncrypted: true #RDSストレージの暗号化
      MultiAZ: false #Single AZ設定 RDSを複数のアベイラビリティーゾーン（AZ）にまたがって冗長化するかを指定
      VPCSecurityGroups:
        - !Ref RDSSecurityGroup
        #- !GetAtt RDSSecurityGroup.GroupId
        #🌟GetAttとは⇒!Ref RDSSecurityGroup と同じ結果であるが参照するのが属性である
      #DBInstanceIdentifier: my-rds-database　RDSインスタンスを識別するための名前を指定
      
      DeletionProtection: true #RDSインスタンスの削除保護を有効にする設定
      Tags:
        - Key: Name
          Value: MyRDS
```
