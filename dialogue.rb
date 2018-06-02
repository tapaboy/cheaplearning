require 'yaml'
require 'natto'
require 'pp'

class Dialogue
  def initialize
    @markov_dic = YAML.load_file'MARKOV_DIC.yaml'
    @yome_strings = ["#{Yome}> え！？　そんなこと私に聞くの？　嘘でしょ？　もー、信じらんない！　"]
  end

  def ore_strings
    print "#{Ore}> "
    str = gets.chomp
    if str == "バイバイ"
      puts "#{Yome}> じゃ、またね。"
      YAML.dump(@markov_dic,File.open('MARKOV_DIC.yaml', 'w'))
      exit
    end

    ## 単語分割し、配列に代入
    parse_ore = Natto::MeCab.new
    parsed_str = []
    parse_ore.parse(str) do |line|
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
    parse_ore.parse(str) do |line|
      if line.feature =~ /固有名詞/ || line.feature =~ /名詞,サ変接続/ || line.feature =~ /名詞,一般/
        ore_words.push line.surface
      end
    end
    @keyword = ore_words[rand(ore_words.size)]
  end

  def yome_strings
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
    puts @yome_strings.join
    @yome_strings = ["#{Yome}> "]
  end

#    yome_strings @keyword

  def make_dialogue
    puts "#{Yome}> なんでもいいから私に聞いてみなさい。"
    while true
      ore_strings
      yome_strings
    end
  end
end
