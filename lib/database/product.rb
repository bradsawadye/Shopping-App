require './lib/database/db'

include DB

class Product
    @@products = []

    def self.product_list
        begin
            connect('./lib/database/shopper.db')
            sql = "SELECT * FROM Products"
            sql_statement(sql)
            sql_execute()
            @@exec.each{ |row|
                product = row[1]
                quantity = row[2]
                price = row[3]
                @@products<<{product => {:quantity => quantity, :price => number_to_currency(price)}}
            }

        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end

        return @@products
    end

    def self.isin_products?(product)
        present = ''
        begin
            connect('./lib/database/shopper.db')
            sql = "SELECT * FROM Products where Name = (?)"
            sql_statement(sql)
            sql_execute(product)
            present = 'true' if @@exec.next.length != 0

        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end

        return true if present == 'true'
        return false
    end

    def self.update_product(product, quantity, price, user='user')
        quant = 0
        values = []
        begin
            connect('./lib/database/shopper.db')
            #update the product

            sql = "SELECT Quantity FROM Products where Name = (?)"
            sql_statement(sql)
            sql_execute(product)
            qx = @@exec.next[0]
            if user == 'user'
                quant = qx - quantity
            else
                quant =  quantity
            end
        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end

        begin
            connect('./lib/database/shopper.db')
            values = [quant, price, product]

            sql = "UPDATE Products SET Quantity = ?, Price= ?  WHERE Name = ?"
            sql_statement(sql)
            sql_execute(values)
        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end
    end

    def self.remove_product(product)
        begin
            connect('./lib/database/shopper.db')
            sql = "DELETE FROM Products where Name = (?)"
            sql_statement(sql)
            sql_execute(product)

        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end
    end

    def self.add_product(product, quantity, price)
        entry = [product, quantity, price]
        begin
            connect('./lib/database/shopper.db')
            sql = "INSERT INTO Products (Name, Quantity, Price) values (?,?,?)"
            sql_statement(sql)
            sql_execute(entry)

        rescue SQLite3::Exception => e
            puts "Exception occurred"
            puts e
        ensure
            close_db()
        end
    end

    def self.products
        return @@products
    end
    def self.empty_product_list
        @@products = []
    end

end

#Product::update_product('Ties', 4, '43.45')
