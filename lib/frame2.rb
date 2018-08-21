module Frame2

    require './lib/database/user'

    def frame2(frame, frame1)

        $username = TkVariable.new
        $password = TkVariable.new

        frame = Tk::Tile::Frame.new(frame) {}.grid(:column => 0, :row => 2)

        $enter_msg = Tk::Tile::Label.new(frame) {text 'Enter username'}.grid(:column => 0, :row => 2, :sticky => 'e')
        $entry = Tk::Tile::Entry.new(frame) {width 12; textvariable $username}
        .grid(:column=>1, :columnspan => 12, :row=>2, :sticky=>'w')
        $entry.focus
        $enter_msg.grid_remove
        $entry.grid_remove

        $password_label = Tk::Tile::Label.new(frame) {text 'Password'}.grid(:column => 0, :row => 3, :sticky => 'e')
        $password_entry = Tk::Tile::Entry.new(frame) {width 12; show '*'; textvariable $password}.grid(:column => 1, :columnspan => 3, :row => 3, :sticky => 'w')
        $password_entry.grid_remove
        $password_label.grid_remove

        $pass = TkVariable.new
        $confirm_label = Tk::Tile::Label.new(frame) {text 'confirm password'}.grid(:column => 0, :row => 4, :sticky => 'e')
        $confirm_entry = Tk::Tile::Entry.new(frame) {width 12; show '*'; textvariable $pass}.grid(:column => 1, :columnspan => 3, :row => 4, :sticky => 'w')
        $confirm_entry.grid_remove
        $confirm_label.grid_remove

        $empty_field = Tk::Tile::Label.new(frame) {text 'Empty field(s)'; foreground 'red'}
        .grid(:column => 0, :row => 1, :columnspan => 6, :sticky => 'e')
        $empty_field.grid_remove

        $unsuccessful_login = Tk::Tile::Label.new(frame) {text 'Username or password wrong'; foreground 'red'}.grid(:column => 0, :row => 1, :columnspan => 6, :sticky => 'e')
        $unsuccessful_login.grid_remove

        $login_button = Tk::Tile::Button.new(frame) {text "Login"; command{check_user($username, $password, frame, frame1, 'user')} }
        .grid(:column=>5, :row=>4, :columnspan => 5, :sticky => 'w')
        $login_button.grid_remove

        $admin_login_button = Tk::Tile::Button.new(frame) {text "Login"; command{check_user($username, $password, frame, frame1, 'admin')} }
        .grid(:column=>5, :row=>4, :columnspan => 5, :sticky => 'w')
        $admin_login_button.grid_remove

        $register_button = Tk::Tile::Button.new(frame) {text "Register"; command{register_user($username, $password, $pass, frame, frame1 = '')} }
        .grid(:column=>5, :row=>5, :columnspan => 5, :sticky => 'w')
        $register_button.grid_remove

        $username_taken = Tk::Tile::Label.new(frame) {text 'Username already in use, choose another'; foreground 'red'}
        .grid(:column => 0, :row => 1, :columnspan => 6, :sticky => 'e')
        $password_match = Tk::Tile::Label.new(frame) {text 'Passwords do not match'; foreground 'red'}
        .grid(:column => 0, :row => 1, :columnspan => 6, :sticky => 'e')
        $registered = Tk::Tile::Label.new(frame) {text 'Registered! You can login now.'; foreground 'blue'}
        .grid(:column => 0, :row => 1, :columnspan => 6, :sticky => 'e')
        $username_taken.grid_remove
        $password_match.grid_remove
        $registered.grid_remove

        #return frame
    end

    def login(frame, frame1, user = 'user')
        remove_message_widgets()
        $intro.grid_remove
        $admin.grid
        $login.grid
        $login.grid_remove if user == 'user'
        $admin.grid_remove if user == 'admin'

        $register.grid

        $entry.grid
        $enter_msg.grid
        $password_label.grid
        $password_entry.grid
        $register_button.grid_remove
        $login_button.grid if user == 'user'
        $admin_login_button.grid if user == 'admin'
        $confirm_entry.grid_remove
        $confirm_label.grid_remove

        $password_entry.bind("Return") {check_user($username, $password, frame, frame1, user)}
        $password_entry.bind('Enter') {$unsuccessful_login.grid_remove;}
        $entry.bind('Enter') {$unsuccessful_login.grid_remove}

    end

    def register(frame, frame1)
        remove_message_widgets()
        $intro.grid_remove
        $register.grid_remove
        $login.grid
        $admin.grid

        $username.value = ''
        $entry.grid
        $enter_msg.grid
        $password_label.grid
        $password_entry.grid
        $confirm_entry.grid
        $confirm_label.grid
        $login_button.grid_remove
        $register_button.grid

        $password_entry.bind("Return") {}
        $confirm_entry.bind("Return") {register_user($username, $password, $pass, frame, frame1)}
        $confirm_entry.bind('Enter') {$password_match.grid_remove}
        $entry.bind('Enter') {$username_taken.grid_remove}
    end

    def check_user(username, password, frame, frame1, user)
        $registered.grid_remove

        if username != nil && password != nil
            if User::check_password(username, password)
                if user == 'user'
                    $frame_1.grid_remove
                    $frame_2.grid
                    $logout = Tk::Tile::Button.new(frame1) {text "Logout"; command {logout(frame, frame1)}}
                    .grid(:column => 13, :row=>1)
                    label1(frame1)
                    frame3(frame1)
                    frame4(frame1)
                elsif user == 'admin'
                    $frame_1.grid_remove
                    $frame3.grid_remove if $frame3
                    $frame_2.grid
                    $logout = Tk::Tile::Button.new(frame1) {text "Logout"; command {logout(frame, frame1, user)}}
                    .grid(:column => 13, :row=>1)
                    label1(frame1)
                    admin(frame1)
                end
                    remove_message_widgets()
            else
                $unsuccessful_login.grid
            end
        else
            $empty_field.grid
        end
    end

    def register_user(username , password, password1, frame, frame1)
        if username != nil
            if !User::is_registered?(username)
                if password == password1 && password != nil && password1 != nil
                    User::register_user(username, password)
                    remove_message_widgets()
                    login(frame, frame1)
                    $registered.grid

                elsif password == nil || password == nil
                    $empty_field.grid
                else
                    $password_match.grid
                end
            else
                $username_taken.grid
            end
        else
            $empty_field.grid
        end
    end

    def remove_message_widgets
        $password.value = ''
        $pass.value = ''
        $password_match.grid_remove
        $empty_field.grid_remove
        $unsuccessful_login.grid_remove
        $username_taken.grid_remove
        $registered.grid_remove
    end

    def logout(frame, frame1, user = 'user')
        $frame_2.grid_remove
        $frame_1.grid

        $frame_4.grid_remove if $frame_4
        $admin_frame.grid_remove if $admin_frame
        login(frame, frame1, user)
        Product::empty_product_list
        User::empty_id
        $row = 0
    end

end
