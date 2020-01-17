####
###
## For Documentation
# 
# https://www.bitstamp.net/api/
class PopuladorBitstampController < ActionController::API
    include Response
    include ExceptionHandler

    def populateBitstamp
        conn = DatabaseConection.new
        client = conn.connect      
        collection = client[:gen_bitstamp]

        apix = HttpCall.new

        while true
          sleep 10
          respuesta = apix.call('https://www.bitstamp.net/api/v2/transactions/btcusd?time=minute')
          #info log
          logger.debug "bitstamp_call:" + 'https://www.bitstamp.net/api/v2/transactions/btcusd?time=minute'
          logger.debug "bitstamp_result_code: " + respuesta.code.to_s

          if respuesta.code.to_s === "200"
            count = 0
            res = JSON.parse(respuesta.body)
            res.each do |child|
              #puts child['date']
              reg = collection.find({date: child['date']});
              if reg.present?
                puts reg
                @result = collection.insert_one(child)  
                count += 1 
              end
            end

            #info log
            logger.debug "bitstamp_result_inserted_trades: " + count.to_s
            @response = '{
              "response":[{
                "status": "ok"
                "code": "200",
              }]
            }'
            
          else
              #info log
              logger.debug "bitstamp_result_code: " + respuesta.code.to_s
              logger.debug "bitstamp_result_error: " + respuesta.body
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
