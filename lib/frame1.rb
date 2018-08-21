module Frame1

    def label(content)
        $intro = Tk::Tile::Label.new(content) {
            text "Welcome to the Shopper App"
            font TkFont.new('times 50 bold')
            foreground 'blue'
        }.grid(:column => 0, :row => 2, :columnspan => 15)
    end

    def label1(frame)
        Tk::Tile::Label.new(frame) {
            text "Welcome #{$username.value.capitalize}\n"
            font TkFont.new('times 30 bold italic')
            foreground 'light blue'
            pack('side'=>'right')
        }.grid(:column => 0, :columnspan => 2, :row => 2, :sticky =>'nswe')
    end

end
