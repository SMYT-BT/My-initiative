## 実装内容（課題内容）
CloudFormation と同様に、Terraformでもクラウド環境を構築できるように、環境構築のコード化を実現すること。
※背景：CloudFormation または Terraform どちらも実現場で使われるツールであるため、双方対応できるようにすること。
- VC-CODE に Terraform を登録 ⇒ [Zenn](https://zenn.dev/aws_cloudmemo/articles/88cf4f869ecbcc#terraform-%E3%81%AE%E6%BA%96%E5%82%99%E6%89%8B%E9%A0%86%EF%BC%88vc-code-%E7%B7%A8%EF%BC%89) にて記載しました。
  
## 動作確認（対応事項）
### 1. 前回作成した CloudFormation の YAML ファイルをもとに、以下 ChatGPT に依頼する。
```
添付のYAMLファイルをTerraform用のコード文に変換してください。
```
**【出力結果】**

<img width="392" height="146" alt="image" src="https://github.com/user-attachments/assets/270795a6-8c95-4a2f-9020-03e6c78998ec" />

-------------------------

### 2. 出力結果を全文検閲・理解
検閲したこと、理解したこと、調べたことを Zennブログにまとめる ⇒ [マイブログ](https://zenn.dev/aws_cloudmemo/articles/88cf4f869ecbcc#terraform-%E3%81%AE%E6%BA%96%E5%82%99%E6%89%8B%E9%A0%86%EF%BC%88vc-code-%E7%B7%A8%EF%BC%89)

-------------------------

### 3. Terraform にてコードの試験開始

① コードのフォーマット
```
PS C:\terraform\terraform-project\terraform-aws-CloudWatch-WAF> terraform fmt -recursive
```

② プロバイダー・モジュールの初期化
```
PS C:\terraform\terraform-project\terraform-aws-CloudWatch-WAF> terraform init
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 6.0"...
- Installing hashicorp/aws v6.73.0...
- Installed hashicorp/aws v6.73.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!
```

③ 構文・設定の検証
```
PS C:\terraform\terraform-project\terraform-aws-CloudWatch-WAF> terraform validate
Success! The configuration is valid.
```
④ AWSへの作成・変更予定の確認（エラー対応あり）
```
PS C:\terraform\terraform-project\terraform-aws-CloudWatch-WAF> terraform plan

Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: No valid credential sources found
│ 
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on main.tf line 12, in provider "aws":
│   12: provider "aws" {
│ 
│ Please see https://registry.terraform.io/providers/hashicorp/aws
│ for more information about providing credentials.
│ 
│ Error: failed to refresh cached credentials, no EC2 IMDS role found, operation error ec2imds: GetMetadata, request
│ canceled, context deadline exceeded
```
⇒ Terraformの初期化・フォーマット・構文検証は正常に完了しているが、AWSの認証情報が設定されていない。

⇒ 認証情報の登録を実施（[マイブログにて記載](https://zenn.dev/aws_cloudmemo/articles/88cf4f869ecbcc#aws-cli-%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB)）

上記で、AWS CLI をインストールし再度 terraform plan を実行。以下成功！
<img width="686" height="184" alt="image" src="https://github.com/user-attachments/assets/d15ad2e0-d175-4df1-aa65-cab953675c42" />

⑤ AWSへのリソース作成
```
terraform apply
```
以下画像のように Apply というメッセージ反応があればビルド成功！
<img width="683" height="154" alt="image" src="https://github.com/user-attachments/assets/44c3c096-d548-4d48-8e43-5579b152fa9b" />
