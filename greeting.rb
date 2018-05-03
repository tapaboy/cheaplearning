names=[]
arr_num=0
File.open("text_write_test.txt","r") do |text|
  text.each_line do |line|
    names[arr_num] = line
    puts names[arr_num]
    arr_num +=1
  end
end

puts names[1].chomp + "様、"+names[0].chomp+"をお呼びですか？"
