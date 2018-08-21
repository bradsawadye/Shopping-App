require 'digest'
require 'date'

time = Time.now.to_i
tr = Time.at(time)
hash = Digest::SHA256.hexdigest('brad')
puts hash
puts time
puts tr.strftime("%Y-%m-%d %H:%M:%S")

$quant_values = [{'e'=>3}]
#$quant_values.each{|e, k| puts e,k}
e = $quant_values.find{|e| e.keys[0] == 'r'}
puts e
