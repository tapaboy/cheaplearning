require'pp'
require 'yaml'

def noun_chooser (noun_dic, trigger)
  ## 関連性の高い名詞用の配列を作成する。
  related_noun_arr = []

  ## related_noun_arrの複製を作成
  work_arr = noun_dic.dup

  ## 複数の配列に同じ単語が出てきたら抜き出す。
  while work_arr.size != 1
    noun_first = work_arr.shift
    work_arr.each do |item|
      related_noun_arr.push(noun_first & item)
    end
  end

  ## 重複する配列を削除する。
  related_noun_arr.uniq!

  ## ひとつの単語しかない配列を空にする。
  related_noun_arr.each do |item|
    item.size == 1 && item.clear
  end

  ## 空配列を削除する。
  related_noun_arr.delete([])

  ## 特定の単語を含む配列をみつける
  selected_noun_arr = []
  related_noun_arr.each do |item|
    item.include?(trigger) && selected_noun_arr.push(item)
  end

  ## 配列を平坦化。
  selected_noun_arr.flatten!
  ## 重複する要素を整理。
  selected_noun_arr.uniq!
  @noun_relation = selected_noun_arr

  ## 配列からランダムに単語を取り出す。
  selected_noun_arr[rand(selected_noun_arr.size)]
  puts "related word #{selected_noun_arr[rand(selected_noun_arr.size)]}"
end
