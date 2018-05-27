require 'yaml'
require './learning'
require 'pp'

class Shiritori_Learning < Learning
  def initialize
    @names = YAML.load_file'NAMES.yaml'

    begin
      @dictionary = YAML.load_file'DICTIONARY.yaml'
    rescue
      @dictionary = {}
    end
    begin
      @pc_wordsbank = YAML.load_file'WORDSBANK.yaml'
    rescue
      puts "#{Yome}> まだしりとりやったことないから、言葉を知らないの。"
      exit
    end
  end

  def ask
    #### しりとりデータベースからランダムに言葉を取り出す。
    select = rand(@pc_wordsbank.size)
    puts "「#{@pc_wordsbank[select]}」てどういう意味なの？"
    super  #Learningのaskメソッドを活用
  end
end
