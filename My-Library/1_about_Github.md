# GitHub 学習内容
## ■下準備　Gitのインストール
＜GitHubのインストール方法＞https://www.curict.com/item/60/60bfe0e.html
## ■事前準備
〇コピーペーストが使えない時…

・Gitへのコピーペースト
本来は、「Shiftキー＋Insert」で実行できる。
→Insertがない場合、窓の杜などでキー配置の変更のアプリケーションを入手。
⇒「Change Key v1.50」を使用（Shift＋F12に変更）

※「MINGW64」周りについて認識


rabbi     @ L-Rain MINGW64


ユーザー名/ 端末名/
## ■ 用語
- Issue：課題、修正点
- Pull Request
- Files Changed：Pull Requestで表示されるファイルの変更数
- リバート：バージョニングを一つ一つ戻ること
- ブランチ：特定の変更点から分岐点までのこと
- featture：機能開発
- リポジトリ：バージョン管理によって管理されるファイルと履歴情報を保管する領域
## ■ GitHubについて
GitHub（ギットハブ） サービス提供元：米 GitHub社（保守対応も含め）
※2018年 マイクロソフトの傘下

ソフトウェア開発のプラットフォーム。コードのバージョン管理システムにはGitを使用する。
複数人のエンジニアがリモートリポジトリとして活用する他、チーム開発を行うための機能を提供するWEBサービス。
リポジトリとしての機能を持つ他にも、コードレビュー機能やWikiなどのコミュニケーションツールとしての機能を持ち、組織規模を問わず、多くの企業・団体がソフトウェア開発で利用する。

GitHubにソースコードをホスティングすることで複数人のソフトウエア開発者と協働してコードをレビューしたり、プロジェクトを管理しつつ開発を行うことができる。

＜GitHubの基本操作＞https://tech-camp.in/note/technology/4756/#GitHub-7

＜GitHubの基本機能＞https://www.brain-gate.net/content/column/system-program-github/

＜GitHubの導入からブランチ作成＞https://tech-blog.rakus.co.jp/entry/20200529/git

＜GitHub一連の処理の動き＞https://zenn.dev/atsushi101011/articles/4e0e36d238a3b8
## ■ バージョン管理基礎（バージョン管理システム）
〇Git（現場での使用率：高）【各端末へ分散型】

バージョン管理システムは大きく「集中型」と「分散型」に分けられます。

- 分散型
   - Git Hubと連携されているため、サーバーの構築は不要

   - ファイルの追加や変更の履歴情報を管理することで、過去の変更箇所を確認する、特定時点の内容に戻す、などの「バージョン管理」という作業が可能となる

   - 「分散型」のバージョン管理システムでは個々人のマシン上にリポジトリを作成して開発を行うことができ、現在のチーム開発における主流となっている。

   - 分散型のバージョン管理システムであるGitでは、まず個々人のマシン上にあるリポジトリ上で作業を実施後、作業内容をネットワーク先のサーバー上などにあるリポジトリに集約する流れで開発を進めていく。
  

  この個々人のリポジトリを「ローカルリポジトリ」、集約先となるリポジトリを「リモートリポジトリ」と呼ぶ。

・基本的な流れ
①ローカルリポジトリにリモートデータの取得
②ローカルリポジトリでファイル更新を履歴に反映
③リモートリポジトリでローカルのデータを反映

＜補足＞
・コメント、承認：レビューの申請と承認 → レビューで承認がないと統合されない
・複数の各々のブランチを統合（マージ）するのが主流
・ブランチを作成すると、そのコードはブランチを作成する前のコードから分析し、「別の時間を生きる」こととなる。
・別の時間を生きたコードは自分だけの経験（変更）を蓄える。
・上記プロセスに問題がなければ、親（分岐元）は「マージ（記憶を統合）を要求」する
・マージは基本リモートリポジトリで実施する

◇集中型
SVN【中央集権型】
※管理するサーバーは自分で立てる

・バージョンを管理するリポジトリは単一。
・リポジトリが壊れても、スナップショットで復旧が可能。
・Gitに比べて容易であり、学習コストが低い。
・特定の場所にあるリポジトリへの接続が必須となる。
## ■リモートリポジトリとは
インターネット上あるいはその他ネットワーク上のどこかに存在するプロジェクトのこと。
（※リモート URL は、「コードがここに保存されています」ということを表現する Git のしゃれた方法）
複数のリモートリポジトリを持つこともでき、それぞれを読み込み専用にしたり読み書き可能にしたりすることもできる。
（※fetch=書き込み、push=読み込み git ,「remote -v」で確認できる）

他のメンバーと共同作業を進めていくにあたっては、これらのリモートリポジトリを管理し、必要に応じてデータのプル・プッシュを行うことで作業を分担していくことになる。
リモートリポジトリの管理には「リモートリポジトリの追加」「不要になったリモートリポジトリの削除」「リモートブランチの管理や追跡対象/追跡対象外の設定」などさまざまな作業が含まれる。


＜リモートリポジトリについて＞https://docs.github.com/ja/get-started/getting-started-with-git/about-remote-repositories
＜リポジトリ作成方法＞https://qiita.com/daisuke19840125/items/75caaef6bc0983524260

＜リモート操作＞https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E5%9F%BA%E6%9C%AC-%E3%83%AA%E3%83%A2%E3%83%BC%E3%83%88%E3%81%A7%E3%81%AE%E4%BD%9C%E6%A5%AD
## ■Git Clone とは
GitHub.com からリポジトリのクローンを作成して、コンピュータ上にローカルコピーを作成し、マージの競合の修正、ファイルの追加または削除、より大きなコミットのプッシュなど、2つの場所で同期することができる。
GitHub.comにリポジトリを作成した場合、それはリモートリポジトリとなる。
リモートリポジトリをそのまま自分のローカル環境（自分のPC上）へ複製（コピー）する機能。

リポジトリをクローンすると、その時点で GitHub.com にあるすべてのリポジトリデータの完全なコピーがプルダウンされる。
これには、プロジェクトのすべてのファイルとフォルダのすべてのバージョンも含まれる。

＜リポジトリのクローンについて＞https://docs.github.com/ja/repositories/creating-and-managing-repositories/cloning-a-repository
## ■インデックス とは
リポジトリに保存されている情報とワークツリー（作業している場所）との差（変更箇所）を記録する場所。
その差（変更箇所）だけをリポジトリに保存していく仕組み

＜インデックスとは＞https://tetoblog.org/2021/06/git-index/
＜ワークツリーとインデックス＞https://u-tan-web.com/git-worktree-index/
## ■ 機能
・ブランチ保護：GitHubは直接コミット禁止によるブランチの保護（保護されたブランチ/protected branches）を提供する。

・GitHubにホストされたリモートレポジトリはgit pushにより更新できる。
→これを許容すると意図しないバグによりpushを受けたブランチが壊れるリスクがある。

・GitHubは「指定ブランチへの直接コミット禁止 + チェック通過Pull Requestを介したmerge/rebase許可」という機能を提供することで、ブランチに問題のあるコミットが混入しないことを可能にしている。

＜ブランチについて＞https://backlog.com/ja/git-tutorial/stepup/01/
＜ブランチのメリット＞https://www.sejuku.net/blog/71071

・GitHub CLI：コマンドライン上でGitHubの操作を行えるCLIツール。
新規でリポジトリを作成したい場合やPRを確認したい場合などに、ブラウザを開かなくても操作できる。
## ■ 課題で使用したコマンド
・git rm -rf {レポジトリ名} ：git clone 削除
・git rm -rf .git：git 削除　

・git ls-files --stage：インデックスの中身を見ることができる。
＜情報元＞https://zenn.dev/kaityo256/articles/inside_the_index

・git config --global user.name：ユーザーネーム確認
・git config --global user.email：メールアドレス確認
・git checkout「ブランチ名」：ブランチへの移動
・git branch：ブランチ一覧表示
・git branch 「ブランチ名」：ブランチ追加
・git branch -d 「ブランチ名」：ブランチ削除
・git branch -D 「ブランチ名」：ブランチ強制削除
・git clone：リモートリポジトリのクローンを生成
・git pull：gitリポジトリにある最新のソースコードを取得
・git add：インデックスにファイル等を認識させる
・git commit：リモートリポジトリにファイル更新の差異を登録する
・git push：リモートリポジトリへ差異を連携する

・git remote -v：他のリポジトリへのリモート接続の一覧を表示するコマンド
・git remote add リモートリポジトリの追加
・git remote rename A B リモートリポジトリの命名変更
＜Gitのリポジトリ切り替え方法＞https://kde.hateblo.jp/entry/2018/02/18/200459

・git remote set-url origin [pushしたいurl]：pushするリポジトリのURLを変更して、pushする
＜情報元＞https://ishidalog.com/?p=140

＜Gitコマンド一覧＞https://qiita.com/uhooi/items/c26c7c1beb5b36e7418e
## ★ Q/A ★
◇GitHub　ReadMeとは
リポジトリに訪れた人に "このプロジェクトが何なのか" をわかりやすく伝えるための説明書のようなもの。
＜参考＞https://cpp-learning.com/readme/

◇ユーザー設定確認方法
https://docs.github.com/ja/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/remembering-your-github-username-or-email

◇マークダウン 記述方法
＜参考＞https://qiita.com/tbpgr/items/989c6badefff69377da7

◇プルリクエストとは
＜参考資料＞https://phoeducation.work/entry/20210913/1631487480

