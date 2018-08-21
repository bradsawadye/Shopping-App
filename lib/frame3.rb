module Frame3

require './lib/database/product'
    $add_buttons = []
    def frame3(frame)

        $frame3 = Tk::Tile::Frame.new(frame) {
            padding "3 3 12 12"; borderwidth 4}.grid(:column=>0, :row=>3, :columnspan => 8, :sticky => 'w')

        Tk::Tile::Label.new($frame3) {
            text "Below is a list of the products\n"
            font TkFont.new('times 30 bold underline')
        }.grid(:column=>1, :row=>0, :columnspan=> 2, :sticky =>'nw')

        table_header($frame3)

        r = 1
        $quantity_exceed = Tk::Tile::Label.new($frame3) {text "Quantity exceeds \nwhats in stock"; foreground 'red'}
        .grid(:column => 5, :row => r)
        $quantity_exceed.grid_remove
        Product::product_list.each{|element|
              element.each{ |e, k|
                    r += 1
                    table($frame3, e, k, r)

                    quantity = TkVariable.new
                    quantity.value = 1
                    s = TkSpinbox.new($frame3) {to 25; from 1; width 4; textvariable quantity}.grid(:column => 5, :row => r)

                    add_button = Tk::Tile::Button.new($frame3) {
                        text 'Add 2 cart'
                        command {add_to_cart(e, quantity, k[:price], add_button)}
                    }.grid(:column => 6, :row => r, :sticky => 'e')

                    $add_buttons << {e => add_button}
        }}

    end

    def table_header(f1)
        Tk::Tile::Label.new(f1) {
            text "Product"
            borderwidth 5
            font TkFont.new('times 18 bold italic underline')
            foreground "black"
        }.grid(:column => 1, :row=>1)
        Tk::Tile::Label.new(f1) {
            text "Quantity Available"
            borderwidth 5
            font TkFont.new('times 18 bold italic underline')
            foreground "black"
        }.grid(:column => 3, :row=>1)
        Tk::Tile::Label.new(f1) {
            text "Price"
            borderwidth 5
            font TkFont.new('times 18 bold italic underline')
            foreground "black"
        }.grid(:column => 2, :row=>1)
    end

    def table(products_frame, e, k, r)
        Tk::Tile::Label.new(products_frame) {
            text "#{e}"
            borderwidth 5
            font TkFont.new('times 18 italic')
            foreground "black"
        }.grid(:column => 1, :row=>r)
        Tk::Tile::Label.new(products_frame) {
            text "#{k[:price]}"
            borderwidth 5
            font TkFont.new('times 18')
            foreground "black"
        }.grid(:column => 2, :row=>r)
        Tk::Tile::Label.new(products_frame) {
            text "#{k[:quantity]}"
            borderwidth 5
            font TkFont.new('times 18')
            foreground "black"
        }.grid(:column => 3, :row=>r)
        Tk::Tile::Label.new(products_frame) {
            text "Qty"
        }.grid(:column => 4, :row => r)
    end


    $cart = {:receipt=>[], :products=>[], :total=>0}
    $row = 0

    def make_receipt_element(product, quantity)
        element = "#{product}x#{quantity}"
        return element
    end

    def add_to_cart(product, quantity, price, add_button = '')
        quant_o = 0
        prods = Product::products
        prods.each{|x| x.each{|k, y|
            if k == product
                quant_o = y[:quantity]
            end
                } }
        if quantity <= quant_o
            add_button.configure('state', 'disabled') if add_button != ''
            $quantity_exceed.grid_remove
            $purchase.grid
            len = price.length - 1
            quantity = quantity.to_i
            price = price[1,len].to_f.round(2)

            x = $cart[:products].find{|prod| prod.keys[0] == product}
            if x != nil
                i = $cart[:products].index(x)
                quant_0 = $cart[:products][i][product][:quantity]
                $cart[:products][i][product][:quantity] = (quant_0 + quantity)
                price = $cart[:products][i][product][:price]
                $quant_values.each{|e|
                    if e.keys[0] == product
                        e.values[0].value =  quant_0 + quantity
                    end
                }
                $cart[:total] +=  ((quantity*price).round(2)).round(2)
            else
                 $cart[:products] << {product => {:quantity => quantity, :price => price}}
                 $cart[:total] += ((quantity*price).round(2)).round(2)
                 $cart[:receipt]<< make_receipt_element(product, quantity)
                 added_to_cart(product, quantity, $row, add_button)
                 $row += 1
            end
            $total.configure('text', number_to_currency($cart[:total]))
        else
            $quantity_exceed.grid
            $purchase.grid_remove
        end
    end
end
