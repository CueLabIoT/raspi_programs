require 'net/https'
require 'uri'
require 'json'
require 'pi_piper'

include PiPiper

fnum = "06"
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
	uri_api = URI.parse("https://o9q636x114.execute-api.ap-northeast-2.amazonaws.com/toilet/toiletinfos")
        
	response = nil
        
	request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})

        http = Net::HTTP.new(uri.host, uri.port)
        http.set_debug_output $stderr
        
	request_api = Net::HTTP::Put.new(uri_api.request_uri, initheader = {'Content-Type' =>'application/json'})

        https = Net::HTTP.new(uri_api.host, uri_api.port)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_NONE
        https.set_debug_output $stderr

        sdata = {
        :type => "toiret",
        :toiret_floor => fnum ,
        :toiret_num => "0" ,
        :used_time => now_time1 - preTime1,
        :flag => pin1.value,
        :datetime => datetime_string
        }.to_json
        request.body = sdata
        
	sdata_api = {
        :type => "toiret",
        :toilet_floor => fnum ,
        :toilet_num => "0" ,
        :used_time => now_time1 - preTime1,
        :flag => pin1.value,
        :datetime => datetime_string
        }.to_json
        request_api.body = sdata_api
 	
	 preTime1 = now_time1

        http.start do |h|
          response = http.request(request)
        end
        https.start do |h|
          response = https.request(request_api)
        end
        
	end

	pin2.read
   	 if pin2.changed? then

    	 p "pin 7 is pushed!!!!"

	puts "show status"

	now_time2 = Time.now
	datetime_string = now_time2.strftime("%Y/%m/%d %H:%M:%S")

        uri = URI.parse("http://52.197.229.83/server_post") 
	uri_api = URI.parse("https://o9q636x114.execute-api.ap-northeast-2.amazonaws.com/toilet/toiletinfos")

	response = nil

        request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})

        http = Net::HTTP.new(uri.host, uri.port)
        http.set_debug_output $stderr

        request_api = Net::HTTP::Put.new(uri_api.request_uri, initheader = {'Content-Type' =>'application/json'})

        https = Net::HTTP.new(uri_api.host, uri_api.port)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_NONE
        https.set_debug_output $stderr

        sdata = {
        :type => "toiret",
        :toiret_floor => fnum ,
        :toiret_num => "1" ,
        :used_time => now_time2 - preTime2,
        :flag => pin2.value,
        :datetime => datetime_string
        }.to_json

        sdata_api = {
        :type => "toiret",
        :toilet_floor => fnum ,
        :toilet_num => "1" ,
        :used_time => now_time2 - preTime2,
        :flag => pin2.value,
        :datetime => datetime_string
        }.to_json
        
	request.body = sdata
	request_api.body = sdata_api
 	
	preTime2 = now_time2

        http.start do |h|
          response = http.request(request)
	 end

        https.start do |h|
          response = https.request(request_api)
	 end

	end
 sleep 1.0
end
