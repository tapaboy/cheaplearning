#### 使う配列とリストを定義
dictionary={}
name_list=[]
dicto=[]
#### ファイルから読み込む
File.open("dictionary.txt","r") do |dict|
  dict.each_line do |line|
    ## ,で分けて、前をハッシュのキーに、後を値として読み込む
    ## また、nameだけで配列を作る。
    dicto.push(line)
    puts dicto
    name="仮の名"
    mean="仮の意味"
    dictionary[name]=mean
    name_list.push(name)
  end
end

#### 意味を教えようとする
select=rand(name_list.size)
selected_word=name_list[select]

puts "ねえ、「" + selected_word + "」の意味教えてあげましょうか？"

print "うん、教えて(Y)  知ってるからいいよ(N)"
gets.chomp

puts "「" + selected_word + "」は、「" + dictionary[selected_word] + "」という意味なのよ。知ってた？"
