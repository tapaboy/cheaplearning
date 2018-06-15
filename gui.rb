require 'gtk3'

win = Gtk::Window.new()

#### 次のコードで「閉じる」を押すと、プログラムは終了。
win.signal_connect("destroy") { Gtk.main_quit }

#### 縦の箱を用意
vbox = Gtk::Box.new(:vertical, 10)
ibox = Gtk::Image.new(:file => "yome.png")
yome_text = Gtk::TextView.new
yome_text.set_size_request(240, 100)
yome_text.buffer.text = "バカ、死ね、カス！"
vbox.pack_start(ibox)
vbox.pack_start(yome_text)

win.add(vbox)
win.show_all
Gtk.main
