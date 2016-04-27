require 'pi_piper'
require 'net/http'
require 'uri'
require 'json'
include PiPiper

#begin
#  timeout(1) {
#    puts "Start"
#    sleep(2)
#    puts "end"
#  }
#re
#scue Timeout::Error
#  puts "Time out"
#  timeout(1) {
#    puts "Start2"
#    sleep(2)
#    puts "end"
#  }
#end


endTime = Time.now 

watch :pin => 17 do
	t = Time.now
        strTime = t.strftime("%Y%m%d%H%M%S")
        strTimedate = t.strftime("%Y/%m/%d %H:%M:%S")

	flag = 0

        #
        puts "t"
        puts t
        puts ""
	puts "endTime"
        puts endTime
        puts ""
        if t > endTime then

                puts "t > endTime"
                puts ""
                
		puts "flag"
                puts ""
        
	        if flag == 1 then
 
              		puts "flag == 1"
                	puts ""

			uri = URI.parse("http://ec2-52-192-215-250.ap-northeast-1.compute.amazonaws.com/server_post")
			response = nil

			request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})

			http = Net::HTTP.new(uri.host, uri.port)
			http.set_debug_output $stderr
			sdata = { 
				:type => "meeting",
				:id => "10F Cue_Lab",
#				:flag => #{value},
#				:exedate => #{strTimedate}
				}.to_json
			request.body = sdata

			http.start do |h|
				response = http.request(request)
			end
 			flag = 0
                        puts "flag"
                        puts flag
		        puts "" 
		else
               		puts "flag == 0"
                	puts ""

		end
          	
	startTime = Time.now
	endTime = startTime + 5
		puts "setTimer"
	else
		puts "t < endTime"
	end

#	puts "Pin change from #{last_value} to #{value}"
#	puts system("sudo raspistill -w 480 -h 360 -n -o /work/img/#{strTime}.jpg")

	puts "---------------------------------"

end

PiPiper.wait
