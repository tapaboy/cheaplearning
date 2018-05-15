require 'yaml'
#require './learning'
require 'pp'

class Shiritori_Learning
  def initialize
#    super
    begin
      @dictionary=YAML.load_file'DICTIONARY.yaml'
    rescue
      @dictionary={}
    end
    begin
      @pc_wordsbank=YAML.load_file'WORDSBANK.yaml'
    rescue
      puts ('嫁>まだしりとりやったことないから、言葉を知らないの。')
      exit
    end
  end

  def ask
    #### しりとりデータベースからランダムに言葉を取り出す。
    select=rand(@pc_wordsbank.size)
    puts '「' + @pc_wordsbank[select] + '」てどういう意味なの？'
    print '単語>'
    @word=gets.chomp
    print '意味>'
    @mean=gets.chomp
    puts '「' + @word + '」とは「' + @mean + '」という意味なのね。覚えたわ。'
    @dictionary[@word]=@mean
    YAML.dump(@dictionary,File.open('DICTIONARY.yaml', 'w'))
  end
end

shiritori_learning=Shiritori_Learning.new
shiritori_learning.ask
