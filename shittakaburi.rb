require 'yaml'
require 'pp'

class Shittakaburi
  def initialize
    begin
      @dictionary=YAML.load_file'DICTIONARY.yaml'
    rescue
      puts "#{Yome}> 言葉を教えてあげようと思ったのだけれど、私の知っている言葉はただひとつ「AIしている？」だけ。"
      exit
    end
    ## ハッシュのキーを配列として取り出す。
    @wordslist=@dictionary.keys
  end

  def teach
    @word=@wordslist[rand(@wordslist.size)]
    puts "#{Yome}> ねえ、「#{@word}」の意味知ってる？"
    puts "#{Yome}> それは「#{@dictionary[@word].sample}」という意味なのよ。私って物知りでしょ？"
  end
end
