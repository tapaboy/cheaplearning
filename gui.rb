require 'gtk3'
require 'yaml'
require 'natto'
require 'pp'
require 'open_jtalk'
require_relative 'noun'

#### Ui クラスを定義
class Ui
  def initialize
    @markov_dic = YAML.load_file 'MARKOV_DIC.yaml'
    @noun_dic = YAML.load_file 'NOUN_DIC.yaml'
  rescue
    @markov_dic = []
    @noun_dic = []
  end

  def make_window
    win = Gtk::Window.new

    #### 次のコードで「閉じる」を押すと、プログラムは終了。
    win.signal_connect('destroy') { Gtk.main_quit }
    win.set_border_width(10)
    win.width_request = 640

    #### 透過性
    ## 枠と上のボタン類を表示しない
    #win.decorated = false
    ## 常に最前面に表示する
    #win.keep_above = true
    # color = Gdk::RGBA.new(1.0, 0.75, 1.0, 0.5)
    # win.opacity=(1)
    # win.override_background_color(0, color)

    #### 縦の箱を用意
    vbox = Gtk::Box.new(:vertical, 10)
    # vbox.opacity=(1)
    # vbox.override_background_color(0, color)

    #### 上から画像、無脳ちゃん（仮）の言葉、こちらの入力欄を置く
    #ibox = Gdk::Pixbuf.new(file: 'yome.png', has_alpha: true, width: 400, height: 400)
    ibox = Gtk::Image.new(file: 'yome.png')
    # ibox.opacity=(1)
    # ibox.override_background_color(0, color)

    @yome_area = Gtk::TextView.new
    @yome_area.set_size_request(380, -1)
    @yome_area.set_cursor_visible(false)
    @yome_area.set_editable(false)
    @yome_area.set_wrap_mode(1)
    @output = '何か用事なの？私だって忙しんだからね。そうそう「バイバイ」でさよならよ。'
    @yome_area.buffer.text = "ヨメ> #{@output}"
    yome_talk

    @ore_area = Gtk::Entry.new
    @ore_area.set_size_request(380, -1)
    @ore_area.max_length = 80
    ore_imput

    vbox.pack_start(ibox, expand: true, fill: true, padding: 0)
    vbox.pack_start(@yome_area, expand: true, fill: true, padding: 0)
    vbox.pack_start(@ore_area, expand: true, fill: true, padding: 0)
    @ore_area.grab_focus

    win.add(vbox)
    win.show_all
    Gtk.main
  end

  private

  #### 人が入力したときの処理
  def ore_imput
    @ore_area.signal_connect('activate') do |e|
      @entry = e.text
      ## ばいばいかバイバイだったら辞書を保存して終了。
      if @entry == 'バイバイ' || @entry == 'ばいばい'
        YAML.dump(@markov_dic, File.open('MARKOV_DIC.yaml', 'w'))
        YAML.dump(@noun_dic, File.open('NOUN_DIC.yaml', 'w'))
        @output = 'じゃ、またね。バイバイ'
        @yome_area.buffer.text = "ヨメ> #{@output}"
        yome_talk
        exit
      end
      ## 通常の文章なら、次のメソッドを実行。
      ore_strings
      yome_strings(@keyword)
      ## 入力欄を空にする。
      e.text = ''
    end
  end

  ## いろいろやって、@keywordを返す。
  def ore_strings
    #### 人の入力からマルコフ辞書を作成する。
    ## 単語分割し、配列に代入
    @parse_ore = Natto::MeCab.new
    parsed_str = []
    @parse_ore.parse(@entry.chomp) do |line|
      parsed_str.push line.surface
    end
    ## 不要な記号を抜く。
    parsed_str.delete('「')
    parsed_str.delete('」')
    parsed_str.delete('　')

    ## マルコフ連鎖用辞書に収録
    cycle = parsed_str.size - 3
    cycle.times do |item0, item1, item2|
      item0 = parsed_str[0]
      item1 = parsed_str[1]
      item2 = parsed_str[2]
      cell_arr = [item0, item1, item2]
      @markov_dic.push cell_arr
      parsed_str.shift
    end
    @markov_dic.uniq!
    ore_noun
  end

  ## 嫁の返事のキーワードとなる名詞をランダムに抜き出す。
  def ore_noun
    ## このあとpushするので、配列であることをからかじめ明示する必要がある。
    ore_words = []
    @parse_ore.parse(@entry) do |line|
      ## featurで品詞が名詞である場合は、
      if line.feature =~ /固有名詞/ || line.feature =~ /名詞,サ変接続/ || line.feature =~ /名詞,一般/
        ## surfaceして、単語を登録していく。
        ore_words.push line.surface
      end
    end
    @trigger = ore_words[rand(ore_words.size)]
    @noun_dic.push(ore_words)
    ## noun_chooserは別ファイルのメソッド。
    ## 最終的には、yome_stringsに渡す@keywordを返す。
    @keyword = noun_chooser(@noun_dic, @trigger) || @trigger
    make_selected_mkv_dic
    puts "keyword A is #{@keyword}"
  end

  #### 無脳ちゃんの言葉を作成する。
  #### なお、ときどきあるはずのない引数を受け取って突然死するのを防止するため(*)で引数を取れるようにする。
  def yome_strings(keyword)
    beginning = ['え！？　嘘でしょ？　もー、信じらんない！　',
                 'もー、そんなこと私に聞くの？　',
                 'しかたないわね、　',
                 '']
    @yome_strings = [beginning[rand(beginning.size)]]
    @yome_strings.push keyword
    ## 後のループ抜け出し判定のため、@yome_stringsの要素数を控えておく。
    @before_size = @yome_strings.size
    ## 順調にループしている間は、connect_wordsを実行する。
    connect_words(@keyword)
    ending = ['　バカ、死ね、カス！',
              '　そんなことまで言わせないでよね。',
              '　わかった？',
              '']
    @yome_strings.push ending[rand(ending.size)]
    @output = @yome_strings.join
    @yome_area.buffer.text = "ヨメ> #{@output}"
    yome_talk
  end

  ## 条件を満たすまで、再帰的に実行するメソッド。
  def connect_words(keyword)
    ## @yome_stringsの長さがループ後に変わっていなければ、もう追加できる言葉がないと判断する。
    if @before_size != @after_size
      puts "size before #{@before_size}"
      @before_size = @after_size
      puts "keyword B is #{keyword}"

      ## 処理の核心部（別メソッド）
      connect_words_core(keyword)
      ## 新たなキーワードで再帰処理
      connect_words(@new_keyword)
    end
    @after_size = 0
  end

  ## 無脳ちゃんの言葉を作る核心部。
  def connect_words_core(keyword)
    ## 関連性の高そうな言葉から先につなげていくように辞書を結合する。
    dictionary = @selected_mkv_dic + @markov_dic.shuffle
    puts "dictionary size is #{dictionary.size}"
    ## 辞書の最初の言葉がキーワードと一致するまで飛ばす。
    dictionary.each do |line|
      ## 対象がないのに無限ループするのを防ぐ。
      next unless line[0] == keyword
      puts "Line is #{line}"
      @yome_strings.push line[1]
      ## 「ちょうど」。や？などが来たら、そこで終了。
      if line[2] == '。' || line[2] == '？' || line[2] == '！'
        @yome_strings.push line[2]
        break
      else
        @yome_strings.push line[2]
        @after_size = @yome_strings.size
        @new_keyword = line[2]
        ## 関連性の高い辞書から、一度使った言葉を廃棄。
        @selected_mkv_dic.delete(line)
        puts "new keyword is #{@new_keyword}"
        puts "size after #{@after_size}"
        break
      end
    end
  end

  ## 特定の名詞（sub_item）を含む子配列（item）を抜き出して、配列に入れる。
  def make_selected_mkv_dic
    @selected_mkv_dic = []
    @markov_dic.each do |item|
      item.each do |sub_item|
        ## @noun_relationは、別ファイルのnoun_chooserにより作られた変数。
        ## @noun_relationに含まれる名詞をひとつづつに対し、小配列に含まれているか判断。
        @noun_relation.include?(sub_item) && @selected_mkv_dic.push(item)
      end
    end
    pp @selected_mkv_dic.uniq!
  end

  #### OpenJtalkで音声を出す。
  def yome_talk
    if ARGV[0] == '-v'
      mode = [OpenJtalk::Config::Mei::ANGRY,
              OpenJtalk::Config::Mei::BASHFUL,
              OpenJtalk::Config::Mei::HAPPY,
              OpenJtalk::Config::Mei::SAD,
              OpenJtalk::Config::Mei::FAST,
              OpenJtalk::Config::Mei::SLOW,
              OpenJtalk::Config::Mei::HIGH,
              OpenJtalk::Config::Mei::LOW]
      OpenJtalk.load(mode[rand(8)]) do |openjtalk|
        header, data = openjtalk.synthesis(openjtalk.normalize_text(@output))
        OpenJtalk::WaveFileWriter.save('yome.wav', header, data)
        `aplay yome.wav`
      end
    #  File.delete 'yome.wav'
    end
  end
end

Ui.new.make_window
