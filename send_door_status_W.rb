require 'net/http'
require 'uri'
require 'json'
require 'pi_piper'

include PiPiper

preTime1 = Time.now
preTime2 = Time.now

pin1 = Pin.new pin:18, direction: :in, pull: :down
pin2 = Pin.new pin:7, direction: :in, pull: :down

loop do
	pin1.read
   	 if pin1.changed? then
    	 
    	 p "pin 18 is pushed!!!!"

	puts "show status"

	now_time1 = Time.now
	datetime_string = now_time1.strftime("%Y/%m/%d %H:%M:%S")

        uri = URI.parse("http://52.197.229.83/server_post")
        response = nil

        request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})

        http = Net::HTTP.new(uri.host, uri.port)
        http.set_debug_output $stderr

        sdata = {
        :type => "toiret",
        :toiret_floor => "13" ,
        :toiret_num => "0" ,
        :used_time => now_time1 - preTime1,
        :flag => pin1.value,
        :datetime => datetime_string
        }.to_json
        request.body = sdata
 	 preTime1 = now_time1

        http.start do |h|
          response = http.request(request)
        end
        end

	pin2.read
   	 if pin2.changed? then

    	 p "pin 7 is pushed!!!!"

	puts "show status"

	now_time2 = Time.now
	datetime_string = now_time2.strftime("%Y/%m/%d %H:%M:%S")

        uri = URI.parse("http://52.197.229.83/server_post")
        response = nil

        request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})

        http = Net::HTTP.new(uri.host, uri.port)
        http.set_debug_output $stderr

        sdata = {
        :type => "toiret",
        :toiret_floor => "13" ,
        :toiret_num => "1" ,
        :used_time => now_time2 - preTime2,
        :flag => pin2.value,
        :datetime => datetime_string
        }.to_json
        request.body = sdata
 	 preTime2 = now_time2

        http.start do |h|
          response = http.request(request)
	 end
	end
 sleep 1.0
end
