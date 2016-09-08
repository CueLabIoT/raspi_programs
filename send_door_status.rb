require 'net/http'
require 'uri'
require 'json'
require 'pi_piper'

PiPiper.watch :pin => 18 do

   last_status = #{last_value}
   now_status = #{value}

   puts "show status"
   puts last_status
   puts now_status

   datetime_string = Time.now.strftime("%Y/%m/%d %H:%M:%S")

	
	toiret_flag = 0
	lastflag = 0;
		uri = URI.parse("http://52.197.229.83/server_post")
		response = nil

		request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
	
		http = Net::HTTP.new(uri.host, uri.port)
		http.set_debug_output $stderr
	
		sdata = { 
		:type => "toiret",
		:toiret_floor => "15F" ,
		:toiret_num => "0" ,
		:distance => "0",
		:flag => now_status ,
		:datetime => datetime_string
		}.to_json
		request.body = sdata
	
		http.start do |h|
		  response = http.request(request)
		end

end

PiPiper.wait

