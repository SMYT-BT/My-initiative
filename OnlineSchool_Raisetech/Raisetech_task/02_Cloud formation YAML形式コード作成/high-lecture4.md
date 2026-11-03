## 補足内容：課題評価者レビュー内容
表題のとおり、評価者からのレビューを受領し、以下の点を付け加えました。

**①MasterUserPassword をテンプレート内に平文で置かない。**

・パラメーターの「 DBPassword:」にて、定義。

※当初平文で置いていた理由は、講義の内容をそのまま再現するものと勘違いしていたため。

**②RDS EngineVersion の妥当性確認（重要）**
```
現状: EngineVersion: 8.4.11 を指定していますが、RDSでサポートされるバージョンか要確認です。確実に作成できるようなら問題ありませんが、安全策としては EngineVersion をパラメータ化するか（デフォルト値を設定）、あるいは指定を外して AWS のデフォルトに任せることを検討してください。
```
上記ご指摘に対し、パラメーターの「DBEngineVersion:」にて、定義。

以下、課題提出内容になります。

↓↓↓

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

  DBPassword:
    Type: String
    NoEcho: true
    MinLength: 8
    Description: RDS master password

  DBEngineVersion:
    Type: String
    Description: RDS MySQL engine version
    AllowedPattern: '^[0-9]+\.[0-9]+\.[0-9]+$'
    ConstraintDescription: バージョンを x.x.x の形式で指定してください。

# ==========================================
# Resources
# ==========================================
Resources:
  # ----------------------------------------
  # VPC(VPCの作成)
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
  # Internet Gateway(IGWの作成)
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
  # Public Subnets(パブリックサブネットの作成)
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
  # Private Subnets(プライベートサブネットの作成)
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
  # Public Route Table(パブリックルートテーブルの作成)
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
  # Private Route Table(プライベートルートテーブルの作成)
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
  # Security Groups(各セキュリティグループの作成)
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
          FromPort: 80
          ToPort: 80
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
          FromPort: 8080
          ToPort: 8080
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
  # Application Load Balancer(ALBの作成)
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
  # EC2 Instance(EC2の作成)
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
  # Target Group(ALBのターゲットグループ作成)
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
  # ALB Listener(ALBのリスナー定義)
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
  # RDS DB Subnet Group(RDSのサブネット作成)
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
  # RDS MySQL(RDB作成)
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
      
      MasterUserPassword: !Ref DBPassword

      DBName: appdb
      Engine: mysql
      EngineVersion: !Ref DBEngineVersion
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
