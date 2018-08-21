module Login

require 'sqlite3'

    def login(username)
        begin
            db = SQLite3::Database.open "test.db"
            res = db.execute "SELECT * FROM Users where name = '#{username}'"
            if res.length != 0
                return true
            else return false
            end
        rescue SQLite3::Exception => e

            puts "Exception occurred"
            puts e

        ensure
            db.close if db
        end
    end

end
