
require 'net/http'
require 'json'

class HttpCall

    def call(url)
        uri = URI(url)
        response = Net::HTTP.get(uri)
        return JSON.parse(response)
    end
end
