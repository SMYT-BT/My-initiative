# lecture06の説明

以下、課題を実施しました。

### ①CroudTrailにてAWS最終利用記録を確認する。
⇒＜画像参照＞課題6-1


＜有力な参考サイト＞https://dev.classmethod.jp/articles/elb-healthcheck-monitoring-by-cloudwatch-alarm/


・SNSメールの確認

ALBのターゲットグループ内のEC22つの稼働。

Webアプリケーション側のUnicornを起動。Healty状態になったことを確認し、Unicornを落とす。

ヘルスチェックがUnhealtyになったことを確認。

⇒「2022/09/24 (土) 13:22」にメールが来たことを確認。


### ②ALBをCloudwatchでHealthCheck監視を実施。
　Unhealtyを発生させ、SNSでメールが受信されるか確認すること。

⇒＜画像参照＞課題6-2

### ③AWSの利用料の見積もりを作成。
⇒AWSコンソール内に見積もりを提示するサービスがなかったため、月次の使用料を記載した情報を提示します。

（※AWS Pricing Calculatorというコンソール外のサービスを確認しましたが、正確な情報を提示できないと感じ上記対応をとりました）

⇒＜画像参照＞課題6-3

### ④先月の請求情報からEC2の利用料を確認すること。
⇒＜画像参照＞課題6-4

### ⑤今月の利用料を確認。またFree Tier枠内で収まっているか確認。
⇒＜画像参照＞課題6-6
