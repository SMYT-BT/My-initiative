# 実装内容（課題内容）

前課題「02_Cloud formation YAML形式コード作成」に対して、以下機能を追加する。

・CloudWatch（アラーム設定）

・WAF（設定難しい）の設定

・WAFの取得ログをCloudWatch logsに連携する

# 動作確認（対応事項）

①上記内容に対して、ChatGPTへ以下の依頼を実施。
```
AWSサービスにて、提案いただいたインフラ構造が構築したいです。AWSサービスのサービスアイコンを用いて、インフラ構成図を作成してみてください。
```
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/fe3a7846-ab18-45e5-ad3c-ff9c6d28e646" />

②前回課題「02_Cloud formation YAML形式コード作成」に対して、以下依頼を実施。
```
既存のVPC・ALB・EC2・RDSの構成は活かしつつ、WAF、CloudWatch Alarmを追加。また、CloudWatch LogsとWAFを連携させる。
この場合、追加すべき更新内容を教えてください。
```
③微修正をかける
上記「②」の結果を踏まえて、前回課題のYAMLコード文を更新。

なお以下提案をChat GPT から受領したが、課題から外れる可能性を懸念して却下。
- SSH接続をやめ、SSM（System Manager）にてサーバ管理を行う。
- 証明書の登録：Certificate Manager (ACM)の記載が必要である。
- 現在の HTTP接続を HTTPS接続に変更する。

④ Cloudformation にてタスクを作成し実行。

⇒パラメータ値に対しての情報不足があり、以下入力（個人情報は伏せる）

- メールアドレス：～@gmail.com
- MySQL Ver:8.4.11
- DB PASS：TestPass1234
- Global IP：***.***.***.***/32

# 指摘事項

①WAF → CloudWatch Logs の書き込み権限を明示してください。

WAF がロググループにログを出力するための許可（CloudWatch Logs のリソースポリシー / 必要な IAM 設定）がテンプレート内に見当たりません。

WAF が PutLogEvents できるよう、AWS::Logs::ResourcePolicy を追加するか、ドキュメント通りの手順で許可を与えてください。
```
以下内容を追記。
  # ----------------------------------------
  # WAFとCloudWatch Logsを連携
  # ----------------------------------------
    DependsOn:      #CloudFormationでリソースの作成順序を指定するプロパティ
        - WAFLogResourcePolicy #ポリシーの反映(論理ID指定)
```

②メトリクス/ARN の参照の確認をお願いします。

・MyWebACLAssociation の ResourceArn に !Ref MyALB を使っていますが、環境や CFN バージョンによっては明示的に LoadBalancer の ARN を使う必要がある場合があります（デプロイ時にエラーが出ないか確認してください）。

⇒Cloudformation で問題なく構築できることを確認。

# 講座を終えて：3つの心配事

① 現在、ChatGPT を利用しているが、他現場では企業用の Copilot が使用されると思われる。

② そもそもAIでベースを用意 → 修正箇所や整合性の確認、という働き方への疑問

③ コンプライアンス的にAI に インフラ構造の情報を与えて問題ないのだろうか
