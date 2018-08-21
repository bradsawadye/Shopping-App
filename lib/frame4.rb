module Frame4

require './lib/database/product.rb'

    def display_list(frame)
        $list_frame = Tk::Tile::Frame.new(frame) {borderwidth 2; relief 'groove'}.grid(:column=>5, :row=>15, :sticky => 'w')
        labl = Tk::Tile::Label.new($list_frame) {text 'Add to cart'; foreground 'red'; font TkFont.new('times 14')}
        .grid(:column => 1, :row =>0)
        #labl.grid_remove

        row = 0
        User::user_transaction_history.each{|key, value|
            products = []
            length = value.length
            if length > 3
                row += 1
                c = 0
                hist_string= ''
                value.each{|e|

                    if c == 1
                        time = Time.at(e)
                        hist_string += "#{time.strftime("%Y-%m-%d %H:%M:%S")}\n"
                    end
                    if e != nil && c > 2
                        product, quantity = e.split('x')
                        quantity = quantity.to_i
                        products <<{:product=>product, :quantity=>quantity}
                        if c%2 ==0
                            hist_string += "#{e}\n"
                        elsif length%2 == 1 && c == (length -1)
                            hist_string += "#{e}\n"
                        else
                            hist_string += "#{e}  "
                        end
                    end
                    c+=1
                }
                hist_string += "Total - #{value[2]}"

                Tk::Tile::Label.new($list_frame) {text hist_string; borderwidth 2; relief 'groove'}.grid(:column =>0, :row => row)
                btn = Tk::Tile::Button.new($list_frame) {text '+'; width 2; command{history_to_cart(products)} }.grid(:column => 1, :row => row, :sticky => 's')
                btn.bind('Enter') {labl.grid}
                btn.bind('Leave') {labl.grid_remove}
            end
        }
        $list_frame.grid_remove
    end

    def frame4(frame)

        $frame_4 = Tk::Tile::Frame.new(frame) { padding '12 12';borderwidth 2; relief 'groove'}.grid(:column => 10, :row => 3, :rowspan => 12, :sticky => 'we')
        $cart_label = Tk::Tile::Label.new($frame_4) {text "Cart"; font TkFont.new('times 20 bold underline') }.grid(:column => 0, :row => 0, :sticky => 'w')
        $history = Tk::Tile::Label.new($frame_4) {text 'History'; font TkFont.new('times 15 underline')}.grid(:column => 5, :row => 15)
        display_label = Tk::Tile::Label.new($frame_4){
            text "To display list of past\ntransactions double click History"
            font TkFont.new('times 15 italic');
            foreground 'red'
        }.grid(:column => 5, :row => 14, :columnspan=> 5, :sticky => 'w')
        display_label.grid_remove

        display_list($frame_4)
        $empty = Tk::Tile::Label.new($frame_4) {text "Cart is empty"}.grid(:column => 2, :row => 2, :sticky => 'w')
        $total_label = Tk::Tile::Label.new($frame_4) {text "Total"; font TkFont.new('times 20')}.grid(:column => 2, :row => 14)
        $total = Tk::Tile::Label.new($frame_4) {text ""; font TkFont.new('times 20')}.grid(:column => 3, :row => 14)
        $purchase = Tk::Tile::Button.new($frame_4) {text "Buy"; command{purchase()}}.grid(:column => 2, :row => 16, :columnspan => 3)
        $total.grid_remove
        $total_label.grid_remove
        $purchase.grid_remove

        $history.bind('Enter') {$history['foreground'] = 'red'; display_label.grid}
        #$history.bind('Leave') {$history['foreground'] = 'black'; display_label.grid_remove}
        $history.bind('Double-1') {$list_frame.grid}
        $frame_4.bind('Leave') {$list_frame.grid_remove; $history['foreground'] = 'black'; display_label.grid_remove}

    end

    $quant_values = []
    def added_to_cart(product, quantity, row, add_button = '', frame = $frame_4)
        $empty.grid_remove
        $total.grid
        $total_label.grid
        $purchase.grid
        labl = Tk::Tile::Label.new(frame) {text "#{product} x #{quantity}"}.grid(:column => 2, :row => (13 - row), :sticky => 'w')

        quant = TkVariable.new
        $quant_values<<{product=>quant}
        quant.value = quantity
        s = TkSpinbox.new(frame) {to 25; from 1; width 2; textvariable quant}.grid(:column => 3, :row => (13 - row))

        butn = Tk::Tile::Button.new(frame) {text "-/+ Qty"; command{change_quantity(product, quant, labl)}}.grid(:column=>4, :row=>(13-row))
        remv = Tk::Tile::Button.new(frame) {text "remove"; command{remove(labl, s, butn, remv, add_button, product)}}.grid(:column=>5, :row=>(13-row))
    end

    def change_quantity(product, quant, labl)
        quant_o = 0
        prods = Product::products
        prods.each{|x| x.each{|k, y|
            if k == product
                quant_o = y[:quantity]
            end
                }
        }
        if quant <= quant_o
            $quantity_exceed.grid_remove
            $purchase.grid
            quant = quant.to_i
            x = $cart[:products].find{|prod| prod.keys[0] == product}
            i = $cart[:products].index(x)
            quant_0 = $cart[:products][i][product][:quantity]
            price = $cart[:products][i][product][:price]
            $cart[:products][i][product][:quantity] = quant

            labl.configure('text', "#{product} x #{quant}")
            quantity = quant - quant_0
            $cart[:total] += (quantity*price).round(2)
            $cart[:receipt][i] = make_receipt_element(product, quant)
            $total.configure('text', number_to_currency($cart[:total]))
        else
            $quantity_exceed.grid
            $purchase.grid_remove
        end
    end

    def remove(labl, s, butn, remv, add_button, prod = product)
        x = $cart[:products].find{|pro| pro.keys[0] == prod}
        i = $cart[:products].index(x)
        price = $cart[:products][i][prod][:price]
        quant_0 = $cart[:products][i][prod][:quantity]
        $cart[:total] = $cart[:total].round(2) - (quant_0*price).round(2)
        $cart[:products].delete_at(i)
        $cart[:receipt].delete_at(i)

        add_button.configure('state', 'normal') if add_button != ''
        labl.grid_forget
        s.grid_forget
        butn.grid_forget
        remv.grid_forget
        $total.configure('text', number_to_currency($cart[:total]))

        if $cart[:total] < 1
            $cart[:total] = 0.0
            $total.grid_remove
            $total_label.grid_remove
            $purchase.grid_remove
        end
        $quant_values.delete($quant_values.find{|e| e.keys[0] == prod })
    end

    def purchase
        $cart[:receipt].unshift($cart[:total])
        User::add_to_history($cart[:receipt])
        $row = 0
        $frame3.grid_forget
        $frame_4.grid_forget
        $cart[:products].each{ |e|
            e.each{|y, k|
            Product::update_product(y, k[:quantity], k[:price])
            }
        }
        Product::empty_product_list
        $cart = {:receipt=>[], :products=>[], :total=>0}
        $quant_values = []
        frame3($frame_2)
        frame4($frame_2)
    end

    def history_to_cart(products)

        if products.length >= 1
            #puts products.length
            prods = Product::products
            price = ''

            products.each{|e|
                $add_buttons.each{ |y|
                    y.each{|r, t|
                        t.configure('state', 'disabled') if r == e[:product]
                    }
                }
                prods.each{|x| x.each{|k, y|
                    if k == e[:product]
                        price = y[:price]
                    end
                        } }
                add_to_cart(e[:product], e[:quantity], price)
            }
        end
    end
end
