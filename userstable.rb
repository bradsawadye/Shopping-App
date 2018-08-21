require 'sqlite3'

begin
    db = SQLite3::Database.open "shopper.db"
    smt = db.prepare ('select * from Users')
    #rr = ['reeff', 'truitirr']
    #smt.bind_params rr
    res = smt.execute
    #res.finish
    res.each {|re| puts re[1]}
rescue SQLite3::Exception => e
    puts "Exception occurred"
    puts e
ensure
    smt.close if smt
    db.close if db
end
'CREATE TABLE History(Id INTEGER, Time INTEGER,
P1 TEXT,  P2 TEXT,  P3 TEXT, P4 TEXT,  P5 TEXT,  P6 TEXT,  P7 TEXT, P8 TEXT
 ) '
