require 'yaml'
#require './learning'
require 'pp'

class Shiritori_Learning
  def initialize
    @names=YAML.load_file'NAMES.yaml'

#    super
    begin
      @dictionary=YAML.load_file'DICTIONARY.yaml'
    rescue
      @dictionary={}
    end
    begin
      @pc_wordsbank=YAML.load_file'WORDSBANK.yaml'
    rescue
      puts "#{Yome}> まだしりとりやったことないから、言葉を知らないの。"
      exit
    end
  end

  def ask
    #### しりとりデータベースからランダムに言葉を取り出す。
    select=rand(@pc_wordsbank.size)
    puts "「#{@pc_wordsbank[select]}」てどういう意味なの？"
    print '単語> '
    @word=gets.chomp
    print '意味> '
    @mean=gets.chomp
    puts "「#{@word}」とは「#{@mean}」という意味なのね。覚えたわ。"
    @dictionary[@word] = [@dictionary[@word], @mean].flatten.compact
    YAML.dump(@dictionary,File.open('DICTIONARY.yaml', 'w'))
  end
end
