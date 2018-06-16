require 'gtk3'

win = Gtk::Window.new

#### 次のコードで「閉じる」を押すと、プログラムは終了。
win.signal_connect("destroy") { Gtk.main_quit }
win.set_border_width(10)    # 余白

#### 縦の箱を用意
vbox = Gtk::Box.new(:vertical, 10)

#### 上から画像、無脳ちゃん（仮）の言葉、こちらの入力欄を置く
ibox = Gtk::Image.new(:file => "yome.png")
tp = Gdk::RGBA.new(1.0, 0.5, 1.0, 0.5)
ibox.override_background_color(:normal, tp)

yome_area = Gtk::TextView.new
yome_area.set_size_request(240, 40)
yome_area.set_cursor_visible(false)
yome_area.set_editable(false)
yome_area.buffer.text = "バカ、死ね、カス！"

ore_area = Gtk::Entry.new
ore_area.set_size_request(240,40)
ore_area.signal_connect("activate") do |entry|
  puts "#{entry.text}"
end

vbox.pack_start(ibox, :expand => true, :fill => true, :padding => 0)
vbox.pack_start(yome_area, :expand => true, :fill => true, :padding => 0)
vbox.pack_start(ore_area, :expand => true, :fill => true, :padding => 0)
ore_area.grab_focus

win.add(vbox)
win.show_all
Gtk.main
