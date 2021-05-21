# Twitter API brah
## Recent Search

アプリでTwitterトレンドが出てきて、タップするとウェブビュー画面に遷移する、みたいなロジック、よく見ますよね？

あれをやりたいなと思います。こんな感じで。下記の例はyahooニュースアプリです。1,2枚目のスクショはAPI叩いてとったデータをクライアント側で整形しているかんじですよね。3枚目のスクショがwebviewで表示しているものですね。

...... ところで、

みんなのガッキーがお嫁に行きましたね ;)

おめでとう！ガッキー!!!!!!!
<div align="center">
<img src="../../assets/images/twitter_api_webview/twitter_trends_view_in_app.jpg" alt="属性" title="twitter trends in app">
<img src="../../assets/images/twitter_api_webview/twitter_trends_view_in_app3.jpg" alt="属性" title="twitter trends in app">
<img src="../../assets/images/twitter_api_webview/twitter_trends_view_in_app2.jpg" alt="属性" title="twitter trends in app">
</div>

いろいろいじったところ、ざっくり下記のようになりました。


地域を選択して、トレンドを取得、タップするとそのトレンド検索の画面(webview)に移行します。

<div align="center">
<img src="../../assets/images/twitter_api_webview/twitter_trends.png" alt="属性" title="twitter trends in app">
<img src="../../assets/images/twitter_api_webview/twitter_api_webview.png" alt="属性" title="twitter trends in app">
</div>


## Fetch Twitter Trends thru Twitter API then display Twitter screen on Web-View


