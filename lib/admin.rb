module Admin

    def admin(frame)
        $admin_frame = Tk::Tile::Frame.new(frame) {padding '3 3 8 8'}.grid(:row => 4, :column => 4)

        products_frame = Tk::Tile::Frame.new($admin_frame) {padding '4 4 12 12'}.grid(:row=> 0, :column => 0)
        instock = Tk::Tile::Label.new(products_frame) {text "Products currently in stock"; font TkFont.new('times 20 bold')}
        .grid(:row => 0, :column => 0, :columnspan => 6)

        table_header(products_frame)
        r = 1
        Product::product_list.each{|element|
              element.each{ |e, k|
                    r += 1
                    table(products_frame, e, k, r)
                    quantity = TkVariable.new
                    quantity.value = k[:quantity]
                    s = TkSpinbox.new(products_frame) {to 100; from 1; width 4; textvariable quantity}.grid(:column => 5, :row => r)

                    Tk::Tile::Label.new(products_frame) {
                        text "Price"
                    }.grid(:column => 6, :row => r)

                    price = TkVariable.new
                    price.value = k[:price][1, k[:price].length].to_f
                    pr = Tk::Tile::Entry.new(products_frame) {textvariable price; width 6}.grid(:column => 7, :row => r)

                    change_button = Tk::Tile::Button.new(products_frame) {
                        text 'Update Qty/Price'
                        command {adjust_product_quantity(e, quantity, price, frame)}
                    }.grid(:column => 8, :row => r, :sticky => 'e')

                    remove_button = Tk::Tile::Button.new(products_frame) {
                        text 'Remove product'
                        command {remove_prod(e, frame)}
                    }.grid(:column => 9, :row => r, :sticky => 'e')
        }}

        Tk::Tile::Label.new(products_frame) {
            text "Add new product\n(price should not have a dollar sign)\n(quantity should be a whole number)"
        }.grid(:column => 1, :columnspan => 2, :row => 20)

        prod_name = TkVariable.new
        prod_name.value = "Enter product name"
        Tk::Tile::Entry.new(products_frame) {textvariable prod_name}
        .grid(:column => 3, :row => 20, :sticky => 's')

        Tk::Tile::Label.new(products_frame) {
            text "Qty"
        }.grid(:column => 4, :row => 20, :sticky => 's')

        quantity = TkVariable.new
        quantity.value = 0
        s = TkSpinbox.new(products_frame) {to 100; from 1; width 4; textvariable quantity}
        .grid(:column => 5, :row => 20, :sticky => 's')

        Tk::Tile::Label.new(products_frame) {
            text "Price"
        }.grid(:column => 6, :row => 20, :sticky => 's')

        price = TkVariable.new
        price.value = 0.00
        pr = Tk::Tile::Entry.new(products_frame) {textvariable price; width 6}
        .grid(:column => 7, :row => 20, :sticky => 's')

        change_button = Tk::Tile::Button.new(products_frame) {
            text 'Add Product'
            command {add_product(prod_name, quantity, price, frame)}
        }.grid(:column => 8, :row => 20, :sticky => 's')

        #Users
        users_frame = Tk::Tile::Frame.new($admin_frame) {padding '4 4 12 12'}.grid(:row=> 2, :column => 0)
        admin_user_frame = Tk::Tile::Frame.new(users_frame) {padding '3 3 8 8'}.grid(:row=> 0, :column => 0)
        user_user_frame = Tk::Tile::Frame.new(users_frame) {padding '3 3 8 8'}.grid(:row=> 1, :column => 0)
        user_history_frame = Tk::Tile::Frame.new(user_user_frame) {padding '3 3 8 8'; width 8; height 8;
             relief 'groove'; borderwidth 2}.grid(:column => 4, :row => 1, :rowspan => 5)
        user_user_frame.bind('Leave') {$frame_hist_1.grid_forget if $frame_hist_1}

        Tk::Tile::Label.new(admin_user_frame) {text "Admin Users"; font TkFont.new('times 20 bold')}
        .grid(:column => 0, :row => 0, :columnspan => 7)
        Tk::Tile::Label.new(user_user_frame) {text "Users"; font TkFont.new('times 20 bold')}
        .grid(:column => 0, :row => 0, :columnspan => 7)

        row = 0
        User::users('Users').each{ |user|
            row += 1
            usr = TkVariable.new
            usr.value = user.values[0]
            Tk::Tile::Label.new(user_user_frame) {text usr.value.capitalize}.grid(:column => 0, :row => row)
            Tk::Tile::Button.new(user_user_frame) {text 'Display History'; command{display_user_history(user.keys[0], user_history_frame)}}
            .grid(:column => 1, :row => row)
            Tk::Tile::Button.new(user_user_frame) {text 'Delete User'; command{}}.grid(:column => 2, :row => row)
        }
    end

    def adjust_product_quantity(product, quantity, price, frame)
        price = price.to_f
        Product::update_product(product, quantity, price, 'admin')
        after_change(frame)
    end

    def add_product(product, quantity, price, frame)
        product = product.value.capitalize()
        price = price.to_f
        quantity = quantity.to_i

        if product != 'Enter product name' && quantity > 0 && price > 0.00
            Product::add_product(product, quantity, price)
            after_change(frame)
        end
    end

    def remove_prod(product, frame)
        if product != 'Enter product name'
            Product::remove_product(product)
            after_change(frame)
        end
    end


    def display_user_history(id, frame)
        $frame_hist_1.grid_forget if $frame_hist_1
        $frame_hist_1 = Tk::Tile::Frame.new(frame) {}.grid(:row => 0, :column =>0)
        row = 0
        User::get_all_user_history(id).each{|e, value|

            length = value.length
            if length > 3
                row += 1
                c = 0
                hist_string = ''
                value.each{|e|
                    if c == 1
                        time = Time.at(e)
                        hist_string += "#{time.strftime("%Y-%m-%d %H:%M:%S")} "
                    end
                    if e != nil && c > 2
                        product, quantity = e.split('x')
                        quantity = quantity.to_i
                        hist_string += "#{e}; "
                    end
                    c+=1
                }
                hist_string += "Total - #{value[2].round(2)}"

                Tk::Tile::Label.new($frame_hist_1) {text hist_string}.grid(:column =>0, :row => row, :sticky => 'w')
            end
        }
    end

    def after_change(frame)
        Product::empty_product_list
        $admin_frame.grid_forget
        admin(frame)
    end
end
