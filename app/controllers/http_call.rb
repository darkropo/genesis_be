
require 'net/http'
require 'json'

class HttpCall

    def call(url)
        uri = URI(url)
        response = Net::HTTP.get_response(uri)  
        if response.code == "301"
            response = Net::HTTP.get_response(URI.parse(response.header['location']))
          end      
        return response
    end
end
