#### なんとなくうまくいきそう

require 'yaml'
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
keyword = gets.chomp
make_stings keyword
puts @yome_strings.join + "わかった？"
