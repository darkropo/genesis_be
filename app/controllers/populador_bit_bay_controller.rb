####
###
## Documentation
# https://bitbay.net/en/public-api#public-api-bitbay

class PopuladorBitBayController < ActionController::API
    include Response
    include ExceptionHandler

    def populateBitBay
      conn = DatabaseConection.new
      client = conn.connect      
      collection = client[:gen_bit_bay]
      find_tid = collection.find().sort({tid:-1}).first
      if find_tid.present?
        since = find_tid[:tid]     
      else
        ## esto no es timestamp es un id de row
        since = params[:since]
      end

      apix = HttpCall.new
      respuesta = apix.call('https://bitbay.net/API/Public/BTCUSD/trades.json?since='+since)
      #info log
      logger.debug "bitBay_call:" + 'https://bitbay.net/API/Public/BTCUSD/trades.json?since='+since.to_s 
      logger.debug "bitBay_result_code: " + respuesta.code.to_s
     
      if respuesta.code.to_s === "200"
        res = JSON.parse(respuesta.body)
        @result = collection.insert_many(res)
        #info log
        logger.debug "bitBay_result_inserted_trades: " + @result.inserted_count.to_s
        @response = '{
          "response":[{
            "status": "ok"
            "code": "200",
          }]
        }'
        
      else
        #info log
        logger.debug "bitBay_result_code: " + respuesta.code.to_s
        logger.debug "bitBay_result_error: " + respuesta.body
        @response = '{
          "response":[{
            "status": "error"
            "code": "'+respuesta.code.to_s+'",
          }]
        }'
        
      end
      json_response(@response)
    end


    
end
