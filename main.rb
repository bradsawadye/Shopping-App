require 'tk'
require 'tkextlib/tile'
require './lib/frame1'
require './lib/frame2'
require  './lib/frame3'
require './lib/frame4'
require './lib/admin'

include Frame1
include Frame2
include Frame3
include Frame4
include Admin

root = TkRoot.new{
    title "Shopper"
    #background 'light blue'
}

content = Tk::Tile::Frame.new(root) {padding '4 4 12 12'}.grid(:sticky => 'nsew')
$frame_2 = Tk::Tile::Frame.new(content) {}.grid(:sticky => 'news', :column => 0, :row => 0)
$frame_1 = Tk::Tile::Frame.new(content) {}.grid(:sticky => 'news', :column => 0, :row => 0)


label($frame_1)

$login = Tk::Tile::Button.new($frame_1) {text "User Login";  width 12; command{login($frame_1, $frame_2)} }
.grid(:column=>1, :columnspan => 12, :row=>1, :sticky => 'ne')
$register = Tk::Tile::Button.new($frame_1) {text "Register User";width 12; command{register($frame_1, $frame_2)} }
.grid(:column=>14, :row=>1, :sticky => 'ne')
$admin =  Tk::Tile::Button.new($frame_1) {text "Admin Login";  width 12; command{login($frame_1, $frame_2, 'admin')} }
.grid(:column=>15, :row=>1, :sticky => 'ne')

frame2($frame_1, $frame_2)

TkGrid.columnconfigure content, 0, :weight => 1; TkGrid.rowconfigure content, 1, :weight => 1
TkGrid.columnconfigure $frame_1, 0, :weight => 1; TkGrid.rowconfigure $frame_1, 0, :weight => 1
TkGrid.columnconfigure $frame_2, 11, :weight => 1; TkGrid.rowconfigure $frame_2, 0, :weight => 1
TkGrid.columnconfigure root, 0, :weight => 1; TkGrid.rowconfigure root, 0, :weight => 1

Tk.mainloop
