require 'yaml'
require 'pp'

class Learning
  def initialize
    begin
      @dictionary=YAML.load_file'DICTIONARY.yaml'
      pp @dictionary
    rescue
      @dictionary={}
    end
  end

  def ask
    puts '何か言葉を教えて。'
    print '単語>'
    @word=gets.chomp
    print '意味>'
    @mean=gets.chomp
    puts '「' + @word + '」とは「' + @mean + '」という意味なのね。覚えたわ。'

    @dictionary[@word]=@mean

    YAML.dump(@dictionary,File.open('DICTIONARY.yaml', 'w'))
  end
end
