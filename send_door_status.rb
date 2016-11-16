require 'net/http'
require 'uri'
require 'json'
require 'pi_piper'

include PiPiper

pin = Pin.new pin:18, direction: :in, pull: :down
loop do
pin.read
   if pin.changed? then
    puts "show status"
    puts #{pin.value}

    datetime_string = Time.now.strftime("%Y/%m/%d %H:%M:%S")

	uri = URI.parse("http://52.197.229.83/server_post")
	response = nil

	request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
	
	http = Net::HTTP.new(uri.host, uri.port)
	http.set_debug_output $stderr

	sdata = { 
	:type => "toiret",
	:toiret_floor => "10F_test" ,
	:toiret_num => "0" ,
	:distance => "0",
	:flag => pin.value,
	:datetime => datetime_string
	}.to_json
	request.body = sdata

	http.start do |h|
 	  response = http.request(request)
  	end
     end
sleep 2.0
end