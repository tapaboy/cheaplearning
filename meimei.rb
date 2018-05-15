require 'yaml'
require 'pp'

names={}

puts '私の名前は？'
names['yome']=gets.chomp
puts '私の名前は ' + names['yome'] + ' っていうの？'

puts 'あなたをなんと呼べばいいの？'
names['master']=gets.chomp
puts names['master'] + ' でいいのね？'

YAML.dump(names,File.open("NAMES.yaml", "w"))
