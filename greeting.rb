require 'yaml'
require 'pp'

class Greeting
  def initialize
    begin
      names=YAML.load_file'NAMES.yaml'
      puts names['master'].chomp + '、'+names['yome'].chomp+'をお呼びですか？'
      pp @names
    rescue
      puts '先に無脳ちゃんに名前をつけてあげてください。'
    end
  end
end

Greeting.new
