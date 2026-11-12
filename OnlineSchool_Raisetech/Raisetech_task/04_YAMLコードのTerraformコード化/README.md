# Terraform CLIをインストールする（Windows）

### ① Terraform公式サイトにアクセス＆インストール
https://developer.hashicorp.com/terraform/install?utm_source=chatgpt.com

### ② Windows用のファイルをダウンロード

一般的なIntel・AMD製CPUのWindows PCなら、以下を選択します。
- OS：Windows
- Architecture：AMD64
- ファイル形式：ZIP
※ ARM版Windows PCの場合はARM64を選択してください。

### ③ ZIPファイルを展開する

以下のフォルダを作成。
```
C:\terraform
```
展開したZIPの中にある terraform.exe を、このフォルダに配置します。

### ④ 環境変数PATHを設定する

Terraformをどのフォルダからでも実行できるようにします。

1. Windowsの検索欄で「環境変数」と検索

2. 「システム環境変数の編集」を開く

3. 「環境変数」をクリック

4. ユーザー環境変数またはシステム環境変数の Path を選択

5. 「編集」→「新規」

6. 以下を追加
```
C:\terraform
```
7. OKを押して設定を保存

### ⑤ インストール確認

新しくPowerShellを起動して、以下を実行します。

terraform -version

正常にインストールされていれば、Terraformのバージョンが表示されます。

terraform -version が正常に動けばCLIの導入は完了です。

# VS CodeにTerraform拡張機能を導入する

1. VS Codeを起動

2. 左側の拡張機能アイコンをクリック

3. 検索欄に以下を入力
```
HashiCorp Terraform
```
4. 発行元がHashiCorpの拡張機能を選択

5.「インストール」をクリック

# Terraformの基本的な動作確認

①ターミナルをひらく

表示（V）→ターミナル
```
terraform init
```
```
terraform validate
```
```
terraform plan
```
