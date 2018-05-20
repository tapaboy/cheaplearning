require 'yaml'
require 'pp'
require './meimei'
require './shiritori'
require './learning'
require './shiritori_learning'
require './shittakaburi'

class Greeting
  def initialize
    begin
      @names=YAML.load_file'NAMES.yaml'
      puts @names['yome']+'> '+ @names['master'] + '様、今日もお会いできてうれしいです。'
    rescue
      puts 'まず無脳ちゃんに名前をつけてあげてください。'
      meimei
      puts @names['yome']+'> '+ @names['master'] + '様、お会いできてうれしいです。よろしくお願いします。'
    end
  end



#  def talk
#    talk=[[Shiritori,],
#          [Learning,''],
#          [Shiritori_Learning,'しりとりに出てきた言葉の意味を教えてください。'],
#          [Shittakaburi,'言葉の意味を教えてあげましょう。']
#        ]
#    puts @names['yome']+'> それでは、'+talk[rand(4)][1]
#  return  Shittakaburi.new
#  end
  def talking
    talk = rand(2)
    case talk
    when 0
      puts @names['yome']+'> '+ 'しりとりをしましょう。'
      Shiritori.new.play
    when 1
      puts @names['yome']+'> '+ '何か言葉を教えてください。'
      Learning.new.ask
    end
  end
end

session = Greeting.new
session.talking
