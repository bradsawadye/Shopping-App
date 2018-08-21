require './lib/database/db'
require 'digest'

include DB

class User

    @@id

    def self.is_registered?(username, table = 'Users')
        res = ''
        begin
            connect('./lib/database/shopper.db')
            sql = ("SELECT * FROM #{table} WHERE Username = ?")
            sql_statement(sql)
            sql_execute(username)
            res = 'true' if @@exec.next != nil

        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e

        ensure
            close_db
        end

        return true if res == 'true'
        return false
    end

    def self.check_password(username, password, table = 'Users')
        pass = ''
        begin
            connect('./lib/database/shopper.db')
            sql = "SELECT ID, Password FROM #{table} WHERE Username = ?"
            sql_statement(sql)
            sql_execute(username)

            res = @@exec.next
            if res != nil
                if res[1] === hash_password(password)
                    pass = 'true'
                    @@id = res[0]
                end
            end
        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end

        return true if pass == 'true'
        return false
    end

    def self.register_user(username, password, table = 'Users')
        if username != nil && password != nil
            begin
                connect('./lib/database/shopper.db')
                sql = "INSERT INTO #{table} (Username, Password) values (?, ?)"
                sql_statement(sql)
                values = [username, hash_password(password)]
                sql_execute(values)

            rescue SQLite3::Exception => e
                puts "Exception occurred"
                puts e

            ensure
                close_db()
            end
        end
    end

    def self.user_transaction_history(id = @@id)
        history = {0=>[], 1=>[], 2=>[], 3=>[], 4=>[]}
        begin
            connect('./lib/database/shopper.db')
            sql = "SELECT * FROM History WHERE Id = ? ORDER BY Time DESC"
            sql_statement(sql)
            sql_execute(id)

            res = @@exec.next
            if res != nil
                res.each{ |element| history[0] << element if element != nil }
                count = 1
                @@exec.each{ |row|
                    if count < 5
                        row.each{|element| history[count] << element if (element != nil)}
                    end
                    count += 1
                }
            end
        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end

        return history
    end

    def self.users(table = 'Users', id = @@id)
        users = []

            begin
                connect('./lib/database/shopper.db')
                sql = "SELECT * FROM #{table}"
                sql_statement(sql)
                sql_execute

                if table == 'Admins' && id == 1
                    @@exec.each{|row|
                        users<< {row[0] => row[1]}
                    }
                elsif table == 'Users'
                    @@exec.each{|row|
                        users<< {row[0] => row[1]}
                    }
                end

            rescue SQLite3::Exception => e
                puts "Exception occurred"
                puts e
            ensure
                close_db()
            end

        return users
    end

    def self.get_all_user_history(id =@@id)
        history = {}
        puts 'ee'
        begin
            connect('./lib/database/shopper.db')
            sql = "SELECT * FROM History WHERE Id = ? ORDER BY Time DESC"
            sql_statement(sql)
            sql_execute(id)

            res = @@exec.next
            if res != nil
                history[0] = []
                res.each{ |element| history[0] << element if element != nil }
                count = 1
                @@exec.each{ |row|
                    history[count] = []
                    row.each{|element| history[count] << element if (element != nil)}
                    count += 1
                }
            end
        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end

        return history
    end

    def self.add_to_history(receipt)
        time = Time.now.to_i
        begin
            connect('./lib/database/shopper.db')
            sql = "INSERT INTO History (Id, Time, Total, P1, P2, P3, P4, P5, P6, P7, P8) values (#{@@id}, #{time}, ?,?,?,?,?,?,?,?,?)"
            sql_statement(sql)
            sql_execute(receipt)

        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end
    end

    def self.get_admin_operations(id)
        history = []
        begin
            connect('./lib/database/shopper.db')
            sql = "SELECT * FROM Admin_Operations WHERE Id = ? ORDER BY Time DESC"
            sql_statement(sql)
            sql_execute(id)

            res = @@exec.next
            if res != nil
                history << {res[1] => res[2]}
                @@exec.each{ |row|
                    history << {row[1] => res[2]}
                }
            end
        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end
    end

    def add_operation(id, operation)
        time = Time.now.to_i
        begin
            connect('./lib/database/shopper.db')
            sql = "INSERT INTO Admin_Operations (Id, Time, Operation) values (#{id}, #{time}, ?)"
            sql_statement(sql)
            sql_execute(operation)

        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end
    end

    def self.delete_user_ohistory(id = @@id, table = 'Users')
        begin
            connect('./lib/database/shopper.db')
            sql = "DELETE FROM #{table} WHERE Id = ?"
            sql_statement(sql)
            sql_execute(id)

        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end
    end

    def self.change_password_username(username, password, id = @@id)
        if password != nil && username != nil
            values = [username, hash_password(password)]
            begin
                connect('./lib/database/shopper.db')
                sql = "UPDATE #{table} SET Username = ?, Password = ? WHERE Id = #{id}"
                sql_statement(sql)
                sql_execute(values)

            rescue SQLite3::Exception => e
                puts "Exception occurred"
                puts e
            ensure
                close_db()
            end
        end
    end

    def self.empty_id
        @@id = ''
    end
end
