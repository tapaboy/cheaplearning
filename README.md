# cheaplearning
try to make personal artificial incompetence.

「人口無脳」ぽいものを自力で作ってみます。
https://wikiwiki.jp/deepforget/
と連携してます。

## あらかじめインストールすべきもの
### パソコン本体にインストールするもの
- ruby、ruby-dev このアプリは,rubyで作っています。
- mecab、libmecab-dev、mecab-ipadic-utf8　形態素解析にmecabを使っています。mecab-ipadic-utf8は、形態素解析に必要な辞書です。必ず「-utf8」がついているものをインストールしてください。
- （任意）NEologd　最近の書籍やテレビ番組（アニメ）のタイトル等も入っている辞書で、頻繁に更新されています。Githubからダウンロードしてインストールします。なお、NEologdより先にcurlをインストールしておく必要があります。

### Ruby付属のgemコマンドでインストールするもの
- rake、mecab、gtk3、natto　rakeは後のものをインストールするために必要なので最初にインストールします。Rubyでmecabを使うためにはgemでもインストールしておく必要があります。gtk3はGUIを作るための道具。nattoはmecabをより使いやすくするもの。
- open_jtalk-ruby https://github.com/sunny4381/open_jtalk-ruby からダウンロードしてインストールします。インストール方法は、当該ページに記載されています。

### 自分で用意するもの
- お好みの yome.png と言う名の画像ファイル。デフォルトの画像をそのまま使ってもいいですが。

## とりあえず使ってみる。
- ファイルを置いてあるディレクトリに移動して、次のようにコマンドを実行してください。
>$ ruby gui.rb

- 音声を出したい場合は、-v オプションをつけます。
>$ ruby gui.rb -v

- "$ ruby greeting.rb" を実行するとGUIと音声はないですが、しりとりなどができます。

## 既知の問題
- ときどき、マルコフ辞書が突然死します。
- 会話の画面表示が音声のあとになってしまいます。本当は画面表示を先にしたいのですが。
- greeting.rbから他のメソッドを呼び出すようにしたが、会話部分を直してないので、何やら不自然。
- privateにした方がよいメソッド（ほとんどだけど）が、そのまま。
- 「しりとり」は、長音や拗音で終わる言葉もなんとかしたい。
- （解決済）一度出てきた言葉に別の意味を教えると、辞書データが上書きされてしまう。＝＞「意味」は配列に変更すべき。

## 主なファイル
- gui.rb GUIで会話っぽいことができます。現在、これだけは単独で動きます。
- greeting.rb もともと挨拶を交わすためだけのものでしたが、ここから他の会話につなげるための入り口になりました。
- meimei.rb 無脳ちゃんに名前をつけます。
- shiritori.rb しりとり遊びをしながら単語を覚えさせてゆきます。
- learning.rb 単語とその意味を覚えさせます。
- shiritori_learning.rb しりとりに出てきた単語の意味を尋ねてきます。
- shittakaburi.rb 無脳ちゃんが（貧弱な）自分の知識をひけらかします。
- dialogue.rb 無脳ちゃんと会話らしきものができます。意味不明なことばかり言いますが、仕様です。
