require 'gtk3'
require 'yaml'
require 'natto'
require 'pp'
require 'open_jtalk'

def yome_talk
  OpenJtalk.load(OpenJtalk::Config::Mei::FAST) do |openjtalk|
    header, data = openjtalk.synthesis(openjtalk.normalize_text(@output))
    OpenJtalk::WaveFileWriter.save('yome.wav', header, data)
    `aplay yome.wav`
  end
#  File.delete 'yome.wav'
end

#### Ui クラスを定義
class Ui
  def initialize
    @markov_dic = YAML.load_file 'MARKOV_DIC.yaml'
  rescue
    @markov_dic = []
  end

  def make_window
    win = Gtk::Window.new

    #### 次のコードで「閉じる」を押すと、プログラムは終了。
    win.signal_connect('destroy') { Gtk.main_quit }
    win.set_border_width(10)

    #### 縦の箱を用意
    vbox = Gtk::Box.new(:vertical, 10)

    #### 上から画像、無脳ちゃん（仮）の言葉、こちらの入力欄を置く
    ibox = Gtk::Image.new(file: 'yome.png')
    tp = Gdk::RGBA.new(1.0, 0.5, 1.0, 0.5)
    ibox.override_background_color(:normal, tp)

    yome_area = Gtk::TextView.new
    yome_area.set_size_request(240, -1)
    yome_area.set_cursor_visible(false)
    yome_area.set_editable(false)
    yome_area.buffer.text = '何か用事なの？私だって忙しんだからね。そうそう『バイバイ」でさよならよ。'

    ore_area = Gtk::Entry.new
    ore_area.set_size_request(240, -1)
    ore_area.signal_connect('activate') do |e|
      @entry = e.text
      if @entry == 'バイバイ' || @entry == 'ばいばい'
        puts @entry
        YAML.dump(@markov_dic, File.open('MARKOV_DIC.yaml', 'w'))
        yome_area.buffer.text = 'じゃ、またね。　×を押して終了してね。'
        exit
      end
      ore_strings
      yome_strings
      yome_area.buffer.text = @output
      e.text = ''
      yome_talk
    end

    vbox.pack_start(ibox, expand: true, fill: true, padding: 0)
    vbox.pack_start(yome_area, expand: true, fill: true, padding: 0)
    vbox.pack_start(ore_area, expand: true, fill: true, padding: 0)
    ore_area.grab_focus

    win.add(vbox)
    win.show_all
    Gtk.main
  end

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

  def yome_strings
    @yome_strings = ['え！？　嘘でしょ？　もー、信じらんない！　']
    @markov_dic.each do |line|
      if line[0][0] == @keyword
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
    end
    @yome_strings.push '　バカ、死ね、カス！'
    @output = @yome_strings.join
    @yome_strings = ['ヨメ（仮）> ']
  end
end

Ui.new.make_window
