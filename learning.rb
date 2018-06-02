require 'yaml'
require 'pp'
require 'natto'

class Learning
  def initialize
    begin
      @dictionary = YAML.load_file'DICTIONARY.yaml'
    rescue
      @dictionary = {}
    end
  end

  def ask
    print '単語> '
    @word=gets.chomp
    print '意味> '
    @mean=gets.chomp
    puts "「#{@word}」とは「#{@mean}」という意味なのね。覚えたわ。"

    @dictionary[@word] = [@dictionary[@word], @mean].flatten.compact
    YAML.dump(@dictionary,File.open('DICTIONARY.yaml', 'w'))

    #### ここからマルコフ連鎖っぽい辞書用
    ## なぜかツンデレっぽい言い方に変換（必須ではない）
    ura_strings = "いいこと？#{@word}ていうのはね#{@mean}という意味なのよ。これくらい常識よ。覚えておきなさい。"
    ## nattoで単語分割
    string_natto = Natto::MeCab.new
    parsed_str = []
    string_natto.parse(ura_strings) do |line|
      parsed_str.push line.surface
    end

    ## マルコフ連鎖用辞書に収録
    begin
      markov_dic = YAML.load_file'MARKOV_DIC.yaml'
    rescue
      markov_dic = []
    end
    cycle = parsed_str.size - 3
    cycle.times do |key1, key2, val|
        key1 = parsed_str[0]
        key2 = parsed_str[1]
        val = parsed_str[2]
        keys = [key1, key2]
        cell_arr = [keys, val]
        markov_dic.push cell_arr
        parsed_str.shift
    end

    markov_dic.uniq!
    YAML.dump(markov_dic,File.open('MARKOV_DIC.yaml', 'w'))
  end
end
