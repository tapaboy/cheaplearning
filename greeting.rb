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
      puts @names['yome'] + '> ' + @names['master'] + '、何か用事なの？私だって忙しんだからね。でも、ちょっとだけならつきあってあげてもいいわよ。'
    rescue
      puts 'まず無脳ちゃんに名前をつけてあげてください。'
      meimei
      puts @names['yome'] + '> 別に' + @names['master'] + 'と知り合いになってもうれしくもないんだかれね。だけど、一応よろしくね。'
    end
  end

  def talking
    talk = rand(4)
    case talk
    when 0
      puts @names['yome']+'> '+ 'しりとりでもする？勘違いしないでよね。ただの暇つぶしよ。ヒマツブシ。'
      Shiritori.new.play
    when 1
      puts @names['yome']+'> '+ '何か言葉を教えてよ。まあ、あなたじゃ大した語彙なさそうだけどね。'
      Learning.new.ask
    when 2
      puts @names['yome']+'> '+ 'ちょっと、前しりとりに出てきた言葉の意味教えなさいよ。'
      Shiritori_Learning.new.ask
    when 3
      puts @names['yome']+'> '+ @names['master'] + 'はあまり言葉知らなそうだから、私が少し教えてあげるわ。'
      Shittakaburi.new.teach
    end
  end
end

session = Greeting.new
session.talking
