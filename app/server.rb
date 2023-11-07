# WEBサーバーを立ち上げるファイル

require 'webrick'
require 'mysql2'
require 'json'
require 'erb'

# データベース接続情報
client = Mysql2::Client.new(:host => 'mysql-container', :user => 'root', :password => 'root')

config = {
    :Port => 8000,
    :DocumentRoot => '.',
}

# erbファイルをhtmlとして返す
WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
server = WEBrick::HTTPServer.new(config)
server.config[:MimeTypes]["erb"] = "text/html"


# # ルーティング設定
server.mount_proc("/sample") { |req, res| 
    template = ERB.new( File.read('sample.erb') )
    res.body << template.result( binding )
}


# APIエンドポイントのルート
server.mount_proc("/api") do |req, res|
    # CORSヘッダを設定 (クロスオリジンリクエストを許可する場合)
    res['Access-Control-Allow-Origin'] = '*'
    res['Access-Control-Request-Method'] = '*'

    # APIエンドポイントへのリクエストメソッドごとに処理を分ける
    case req.request_method
        when 'GET'
            # データの取得
            results = client.query("SELECT * FROM demo.test")
            data = results.to_a
            res.body = data.to_json
            res["Content-type"] = "application/json"
        when 'POST'
            # データの新規作成
            name = req.query['name']
            result = client.query("INSERT INTO demo.test(name) VALUES ('#{name}')")
            res.set_redirect(WEBrick::HTTPStatus::SeeOther, '/sample.erb')
            
        else
            res.status = 405  # メソッドが許可されていない場合
            res.body = 'Method Not Allowed'
        end
    end

# シャットダウン
trap(:INT){
    server.shutdown
}
server.start