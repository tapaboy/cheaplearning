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
      puts @names['yome']+'> '+@names['master'] + '様、今日もお会いできてうれしいです。'
    rescue
      puts 'まず無脳ちゃんに名前をつけてあげてください。'
      meimei
      puts @names['yome']+'> '+@names['master'] + '様、お会いできてうれしいです。よろしくお願いします。'
    end
  end

#  def talk
#    talk=[[Shiritori,'しりとりをしましょう。'],
#          [Learning,'何か言葉を教えてください。'],
#          [Shiritori_Learning,'しりとりに出てきた言葉の意味を教えてください。'],
#          [Shittakaburi,'言葉の意味を教えてあげましょう。']
#        ]
#    puts @names['yome']+'> それでは、'+talk[rand(4)][1]
#  return  Shittakaburi.new
#  end
end

session=Greeting.new
# session.talk
