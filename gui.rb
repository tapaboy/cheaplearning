  require 'gtk3'
  require 'yaml'
  require 'natto'
  require 'pp'
  require 'open_jtalk'

  #### Ui クラスを定義
  class Ui
    def initialize
      super
      @markov_dic = YAML.load_file 'MARKOV_DIC.yaml'
    rescue
      super
      @markov_dic = []
    end

    def make_window
      win = Gtk::Window.new

      #### 次のコードで「閉じる」を押すと、プログラムは終了。
      win.signal_connect('destroy') { Gtk.main_quit }
      win.set_border_width(10)
      win.width_request = 400

      #### 透過性
      ## 枠と上のボタン類を表示しない
      #win.decorated = false
      ## 常に最前面に表示する
      #win.keep_above = true

      color = Gdk::RGBA.new(1.0, 0.75, 1.0, 0.75)
      win.override_background_color(0, color)

      #### 縦の箱を用意
      vbox = Gtk::Box.new(:vertical, 10)
      vbox.override_background_color(0, color)

      #### 上から画像、無脳ちゃん（仮）の言葉、こちらの入力欄を置く
      #ibox = Gdk::Pixbuf.new(file: 'yome.png', has_alpha: true, width: 400, height: 400)
      ibox = Gtk::Image.new(file: 'yome.png')
      ibox.override_background_color(0, color)

      @yome_area = Gtk::TextView.new
      @yome_area.set_size_request(240, -1)
      @yome_area.set_cursor_visible(false)
      @yome_area.set_editable(false)
      @output = '何か用事なの？私だって忙しんだからね。そうそう『バイバイ」でさよならよ。'
      @yome_area.buffer.text = "ヨメ> #{@output}"
      yome_talk

      @ore_area = Gtk::Entry.new
      @ore_area.set_size_request(240, -1)
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
        if @entry == 'バイバイ' || @entry == 'ばいばい'
          YAML.dump(@markov_dic, File.open('MARKOV_DIC.yaml', 'w'))
          @output = 'じゃ、またね。バイバイ'
          @yome_area.buffer.text = "ヨメ> #{@output}"
          yome_talk
          exit
        end
        ore_strings
        yome_strings
        e.text = ''
      end
    end

    #### 人の入力からマルコフ辞書を作成する。
    def ore_strings
      ## 単語分割し、配列に代入
      parse_ore = Natto::MeCab.new
      parsed_str = []
      parse_ore.parse(@entry) do |line|
        parsed_str.push line.surface
      end

      ## マルコフ連鎖用辞書に収録
      cycle = parsed_str.size - 3
      cycle.times do |key1, key2, val|
        key1 = parsed_str[0]
        key2 = parsed_str[1]
        val = parsed_str[2]
        keys = [key1, key2]
        cell_arr = [keys, val]
        @markov_dic.push cell_arr
        parsed_str.shift
      end
      @markov_dic.uniq!
      @markov_dic.shuffle!

      ## 嫁の返事のキーワードとなる名詞をランダムに抜き出す。
      ore_words = []
      parse_ore.parse(@entry) do |line|
        if line.feature =~ /固有名詞/ || line.feature =~ /名詞,サ変接続/ || line.feature =~ /名詞,一般/
          ore_words.push line.surface
        end
      end
      @keyword = ore_words[rand(ore_words.size)]
    end

    #### 無脳ちゃんの言葉を作成する。
    #### なお、ときどきあるはずのない引数を受け取って突然死するのを防止するため(*)で引数を取れるようにする。
    def yome_strings (*)
      beginning = ['え！？　嘘でしょ？　もー、信じらんない！　', 'もー、そんなこと私に聞くの？　', 'しかたないわね、　']
      @yome_strings = [beginning[rand(beginning.size)]]
      @markov_dic.each do |line|
        next unless line[0][0] == @keyword
        if @keyword == '。' || @keyword == '？'
          @yome_strings.push @keyword
          break
        end
        @yome_strings.push line[0][0]
        @yome_strings.push line[0][1]
        @keyword = line[1]
        next if @keyword != line[0][0]
        yome_strings @keyword
      end
      ending = ['　バカ、死ね、カス！', '　そんなことまで言わせないでよね。', '　わかった？']
      @yome_strings.push ending[rand(ending.size)]
      @output = @yome_strings.join
      @yome_area.buffer.text = "ヨメ> #{@output}"
      yome_talk
    end

    #### OpenJtalkで音声を出す。
    def yome_talk
      if ARGV[0] == '-v'
        OpenJtalk.load(OpenJtalk::Config::Mei::FAST) do |openjtalk|
          header, data = openjtalk.synthesis(openjtalk.normalize_text(@output))
          OpenJtalk::WaveFileWriter.save('yome.wav', header, data)
          `aplay yome.wav`
        end
        #  File.delete 'yome.wav'
      end
    end
  end

  Ui.new.make_window
