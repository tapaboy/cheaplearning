require 'yaml'
require 'pp'

class Learning
  def initialize
    @names=YAML.load_file'NAMES.yaml'

    begin
      @dictionary=YAML.load_file'DICTIONARY.yaml'
    rescue
      @dictionary={}
    end
  end

  def ask
    print '単語> '
    @word=gets.chomp
    print '意味> '
    @mean=gets.chomp
    puts "「#{@word}」とは「#{@mean}」という意味なのね。覚えたわ。"
    ura_strings = "「いいこと？#{@word}ていうのはね#{@mean}という意味なのよ。これくらい常識よ。覚えておきなさい。"

    @dictionary[@word] = [@dictionary[@word], @mean].flatten.compact
    YAML.dump(@dictionary,File.open('DICTIONARY.yaml', 'w'))
  end
end
