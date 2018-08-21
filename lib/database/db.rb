module DB

    require 'sqlite3'

    @db
    @@exec
    @@smt
    def connect(db)
            @@db = SQLite3::Database.open db
            #@@db.results_as_hash = true
    end

    def sql_statement(sql)
        @@smt = @@db.prepare(sql)
    end

    def sql_execute(values = nil)
        if values != nil
            @@smt.bind_params values
        end
        @@exec = @@smt.execute
        return @@exec
    end

    def close_db
        @@smt.close if @@smt
        @@db.close if @@db
    end

    def hash_password(password)
        return Digest::SHA512.hexdigest(password)
    end


    def number_to_currency(number, options={})
        unit 		= options[:unit]      || '$'
        precision   = options[:precision] || 2
        delimiter	= options[:delimiter] || ','
        seperator	= options[:seperator] || '.'

        seperator = ' ' if precision == 0
        integer, decimal = number.to_s.split('.')
        i = integer.length
        until  i<=3
        	i -= 3
        	integer = integer.insert(i,delimiter)
        end

        if precision == 0
        	precise_decimal = ' '
        else
        	decimal 		||= "0"
        	decimal 		= decimal[0,precision]
        	precise_decimal = decimal.ljust(precision, "0")
        end

        return unit + integer + seperator + precise_decimal
    end

end
