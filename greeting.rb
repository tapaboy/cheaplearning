require 'yaml'
require 'pp'
require './meimei'
require './shiritori'
require './learning'
require './shiritori_learning'
require './shittakaburi'

begin
  names = YAML.load_file'NAMES.yaml'
  Yome = names[0]
  Ore = names[1]
  puts "#{Yome}> #{Ore}、何か用事なの？私だって忙しんだからね。でも、ちょっとだけならつきあってあげてもいいわよ。"
rescue
  names={}

  puts '私の名前は？'
  Yome = gets.chomp
  puts "私の名前は#{Yome}っていうの？"
  puts 'あなたをなんと呼べばいいの？'
  Ore = gets.chomp
  puts "#{Ore}でいいのね？"

  YAML.dump([Yome, Ore],File.open("NAMES.yaml", "w"))
  puts "#{Yome}> 別に#{Ore}と知り合いになってもうれしくもないんだかれね。だけど、一応よろしくね。"
end

talk = rand(4)
case talk
when 0
  puts "#{Yome}> しりとりでもする？あ、勘違いしないでよね。ただの暇つぶしよ。ヒマツブシ。"
  Shiritori.new.play
when 1
  puts "#{Yome}> 何か言葉を教えてよ。ま、あなたじゃ大した語彙なさそうだけどね。"
  Learning.new.ask
when 2
  puts "#{Yome}> ちょっと、前しりとりに出てきた言葉の意味教えなさいよ。"
  Shiritori_Learning.new.ask
when 3
  puts "#{Yome}> #{Ore}はあまり言葉知らなそうだから、私が少し教えてあげるわ。"
  Shittakaburi.new.teach
end
