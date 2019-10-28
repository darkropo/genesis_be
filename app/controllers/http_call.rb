
require 'net/http'
require 'json'

class HttpCall

    def call(url)
        uri = URI(url)
        response = Net::HTTP.get_response(uri)        
        return response
    end
end
