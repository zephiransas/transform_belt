## 内容

これは、S3のPUTイベントをフックして、ECSのタスクを起動するLambdaです。

## 前提

- S3が既にあること
- 実行したい処理のDockerがECRなどに登録されていること

## 修正するところ

### serverless.yml

- 48行目 - `SUBNET_ID` をタスクを実行するサブネットIDを設定。インターネットにつながっている必要がある。
- 49行目 - `SECURITY_GROUP` にセキュリティグループを指定。外部からアクセスされることはないので、defaultでいいかも。
- 118行目 - ECRを使う場合はImageを修正。

### transform.rb

- 31行目 - 現在は `echo [S3にPUTされたオブジェクトのキー]` するだけんいなっているので、これを適切なコマンドに書き換える。

## デプロイ方法

serverless frameworkがインストールされていれば

```
$ sls deploy
```

で、デプロイされる。

## トリガの設定

Lambda function `transform-belt-dev-transform` のトリガに、S3のPUTイベントを設定する。
