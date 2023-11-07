# webrickを使った簡易webアプリ

## 概要
バックエンドにRubyのwebrickを使ってHTTPサーバを立ち上げ、MysqlとCRUD操作ができる環境

## 開始時
docker-compose.ymlファイルがあるディレクトリで
```shell
$ docker-compose up --build -d
```

### 2回目以降はこっち
```shell
$ docker-compose up  -d
```

起動に30秒くらいかかります。


## Mysqlへログインするとき
```shell
$  docker exec -it ruby-container bash
```
```shell
コンテナ内$  mysql -h mysql-container -u root -D demo -p
```


## 終了時

コンテナ内にいる場合
```shell
コンテナ内$ exit
```

```shell
$ docker-compose down
```
