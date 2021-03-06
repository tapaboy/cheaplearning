require 'yaml'
require 'pp'

class Shiritori
  def initialize
    @names=YAML.load_file'NAMES.yaml'

    #### 初めからPCが答えられる言葉を用意してあげる。
    @pc_wordsbank = ['ごりら','ぱんだ','ごま','めだか','かばん','ごりら']

    #### WORDSBANK.yamlを一旦読み込み、配列pc_wordsbankに格納
    #### ただし、最初はWORDSBANK.yamlがないので、例外処理を行う
    begin
      @load_wordsbank=YAML.load_file'WORDSBANK.yaml'
      @load_wordsbank.each do |i|
        @pc_wordsbank.push(i)
      end
    ## WORDSBANK.yamlがないとき（中身が空のとき）の処理（と言っても何もしない）
    rescue
    end

    ## 最後にWORDSBANK.yamlに（再）保存するために一時保管
    @temp_wordsbank=@pc_wordsbank

    ## wordsbankの空配列
    @wordsbank=[]
  end

#  wordsbank=[]

  #### 出てきた言葉を保存するメソッド
  def store_words
    @temp_wordsbank.each do |i|
      @wordsbank.push(i)
    end
    @wordsbank.uniq!
    YAML.dump(@wordsbank,File.open('WORDSBANK.yaml', 'w'))
    exit
  end

  ####人間側の設定（キーボードから入力した文字を返すだけ。）
  def human_play
    print "#{Ore}> "
    return gets.chomp
  end

  #### pc側の設定（手持ちのリストから、該当する単語を探し出す。）
  def pc_play
    @pc_wordsbank.each do |w|
      if w[0] == @tail
        puts "#{Yome}> " + w
        @pc_wordsbank.delete(w)
        return w
      end
    end
    puts "#{Yome}> うぅ〜、「#{@tail}」で始まる言葉を思い出せないわ。しかたないわね。今回だけは負けを認めてあげるわ。"
    store_words
    exit
  end

  ####審判
  def judge

  ## すでに使われた単語か判断。
    @wordsbank.each do |w|
      if w == @word
        puts '謎の中の人> その言葉はもう出てます。残念でした。'
        store_words
      end
    end

    ## 「ん」で終わっていないか判断
    if @word[-1] == 'ん'
      puts '謎の中の人> 最後の言葉が「ん」です。残念でした。'
      @wordsbank.push(@word)
      store_words
    ## 前の単語の最後の文字で始まっていれば正常処理
    elsif @word[0] == @tail
      @wordsbank.push(@word)
      puts "次は「#{@word[-1]}」で始まる言葉"
      return @word[-1]
    ## 前の言葉の最後の言葉と違う言葉で始まっていれば負け判定
    else
      puts "謎の中の人> 「#{@tail}」で始まる言葉ではありません。残念でした。"
      @wordsbank.push(@word)
      store_words
    end
  end

  def play
    #### 試合開始
    puts "#{Yome}> はじめは#{Ore}からどうぞ"
    @word=human_play
    @tail=@word[0]

    while true
      @tail=judge
      @word=pc_play
      @tail=judge
      @word=human_play
    end
  end
end
