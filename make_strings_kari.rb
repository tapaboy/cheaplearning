require 'yaml'
require 'natto'
require 'pp'

@markov_dic = YAML.load_file'MARKOV_DIC.yaml'
@yome_strings = ["嫁> え！？　そんなこと私に聞くの？　嘘でしょ？　もー、信じらんない！　"]

@markov_dic.shuffle!
def make_stings (keyword)
  @markov_dic.each do |line|
    break if keyword == "。"
    if line[0][0] == keyword
      @yome_strings.push line[0][0]
      @yome_strings.push line[0][1]
      break if line[0][1] == "。"
      keyword = line[1]
      next if keyword != line[0][0]
      make_stings keyword
    end
  end
end

puts "嫁> なんでもいいから私に聞いてみなさい。"
print "俺> "
str = gets.chomp

parse_ore = Natto::MeCab.new

parsed_str = []
parse_ore.parse(str) do |line|
  parsed_str.push line.surface
end

## マルコフ連鎖用辞書に収録
cycle = parsed_str.size - 3
cycle.times do |key1, key2, val|
    key1 = parsed_str[0]
    key2 = parsed_str[1]
    val = parsed_str[2]
    keys = [key1, key2]
    cell_arr = [keys, val]
    @markov_dic.push cell_arr
    parsed_str.shift
end

@markov_dic.uniq!
YAML.dump(@markov_dic,File.open('MARKOV_DIC.yaml', 'w'))

ore_words = []
parse_ore.parse(str) do |line|
  if line.feature =~ /固有名詞/ || line.feature =~ /名詞,サ変接続/ || line.feature =~ /名詞,一般/
    ore_words.push line.surface
  end
end
keyword = ore_words[rand(ore_words.size)]

make_stings keyword
puts @yome_strings.join + "わかった？"
