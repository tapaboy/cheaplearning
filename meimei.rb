puts "私の名前は？"
yome=gets.chomp
puts "私の名前は " + yome + " っていうの？"

puts "あなたをなんと呼べばいいの？"
master=gets.chomp
puts master + " でいいね？"

File.open("text_write_test.txt","w+") do |text|
 text.puts yome
 text.puts master
end
