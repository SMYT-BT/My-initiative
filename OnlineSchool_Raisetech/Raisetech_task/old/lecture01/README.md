# lecture1:講義概要

## 【概要】
本講座を受講するうえでの心構えやマインドを序章に、エンジニアとプログラミングの概念を見直すものであった。  
エンジニアというものは依頼された通りのITシステムを完成させることを基本的な目的とするが、依頼通りでない、納得を得られるような結果を提示することも一つの手段である。  
故に決まった結果はないため、期待値は不変的である。  
上記期待値を実現させるためには「プログラムは何に必要か」、「必要なインフラは何か」、またそれ以外の必要な要素はないか、などの技術の内訳を思考またはアウトプットできる必要がある。  
そしてこの所作を実施するためにはやはり「知識」が基づいてくる。  

## 【学習メモ】
### ○メモ１：AWSとは…
・AWS(Amazon Web Services)とは、Amazon が提供しているクラウドインフラのプラットフォーム。  
・世界中にサービス拠点(リージョン)を持ち、利用したい人はアカウントを作成するだけで、AWS が提供する 170 以上のサービスの利用が可能。  
・Netflix など有名な企業がシステムに AWS を採用している。  

### ○メモ２：開発環境の概念
・いわば「プログラムを作ることができる環境」のことを意味する。  
・エディター（記述するソフトウェア）をインストールしたり、開発言語本体のプログラムをインストールするなど、環境を整えることが必要。  
・インフラエンジニアはサーバーに設定した情報を管理しておかないといけない立場上、環境構築にも一定の知識、具体的には実際に環境の構築ができるくらいの知識を持っている必要がある。  

## 【課題事前知識】
### ○AWSアカウント作成
・MFA(多要素認証)は必ず有効化すること。  
・AWS には無料利用枠があるが、使用料に制限機能はないため、「AWS アカウントを安全に管理する」「ログイン情報を忘れないようにする」ことは必須。  
・アカウント作成で最初に作られるユーザーはルートユーザーと呼ばれ、解約も含めてすべての権限を持つ。  


# 課題_AWSアカウントの作成とCloud9動作確認
## 【対応事項】
###  IAM の推奨設定ルートユーザーを MFA で保護。  
![](https://github.com/SMYT-BT/My-initiative/blob/main/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture01/%E8%AA%B2%E9%A1%8C1.png)

###  Billingを IAM ユーザーで閲覧できるようにする。  
![](https://github.com/SMYT-BT/My-initiative/blob/main/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture01/%E8%AA%B2%E9%A1%8C2.png)

###  AdministratorAccess権限のIAM ユーザーを作成。  
![](https://github.com/SMYT-BT/My-initiative/blob/main/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture01/%E8%AA%B2%E9%A1%8C3.png)

###  AWSサービス、Cloud9上でRuby開発環境を構築し、「"Hello World"」を出力する。  
1. AWSマネジメントコンソールから、Cloud9サービスを選択。  
2. Linux2でインスタンスでの作成を選択。  
3. Ruby環境にて、「puts "Hello World"」  
![](https://github.com/SMYT-BT/My-initiative/blob/main/OnlineSchool_Raisetech/Raisetech%E8%AA%B2%E9%A1%8C/lecture01/%E8%AA%B2%E9%A1%8C4.png)