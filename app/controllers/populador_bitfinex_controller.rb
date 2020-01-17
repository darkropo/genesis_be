####
###
## For Documentation
# https://currentmillis.com/ 
# https://docs.bitfinex.com/reference#rest-public-trades
require 'em/pure_ruby'
require 'eventmachine'

class PopuladorBitfinexController < ActionController::API
    include Response
    include ExceptionHandler

    def populateBitfinex
        conn = DatabaseConection.new
        client = conn.connect      
        collection = client[:gen_bitfinex]
        find_tid = collection.find().sort({MTS:-1}).first
        if find_tid.present?
            since = find_tid[:MTS]     
        else
            ##este timestamp es en milisegundos
            since = params[:since].to_i
        end
        apix = HttpCall.new

        while true
          sleep 10
            respuesta = apix.call('https://api-pub.bitfinex.com/v2/trades/tBTCUSD/hist?start='+since.to_s)
            #info log
            logger.debug "bitfinex_call:" + 'https://api-pub.bitfinex.com/v2/trades/tBTCUSD/hist?start='+since.to_s 
            logger.debug "bitfinex_result_code: " + respuesta.code.to_s

            if respuesta.code.to_s === "200"
                res = JSON.parse(respuesta.body)
                resMap = res.map{|s| {ID: s[0], MTS: s[1], AMOUNT: s[2], PRICE: s[3] } } 
                resJson = resMap
              
                @result = collection.insert_many(resJson)
                #info log
                logger.debug "bitfinex_result_inserted_trades: " + @result.inserted_count.to_s
                @response = '{
                  "response":[{
                    "status": "ok"
                    "code": "200",
                  }]
                }'
                 
              else
                #info log
                logger.debug "bitfinex_result_code: " + respuesta.code.to_s
                logger.debug "bitfinex_result_error: " + respuesta.body
                @response = '{
                  "response":[{
                    "status": "error"
                    "code": "'+respuesta.code.to_s+'",
                  }]
                }'
                
              end  
          end

       
        
          json_response(@response)
    end
end
