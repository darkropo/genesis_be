class PopuladorController < ActionController::API
    include Response
    include ExceptionHandler

    def populate
      conn = DatabaseConection.new
      client = conn.connect      
      collection = client[:gen_api_x]
      find_tid = collection.find().sort({tid:-1}).first
      if find_tid.present?
        since = find_tid[:tid]     
      else
        since = params[:since]
      end

      apix = HttpCall.new
      respuesta = apix.call('https://bitbay.net/API/Public/BTCUSD/trades.json?since='+since)
      #info log
      logger.debug "apiX_call:" + 'https://bitbay.net/API/Public/BTCUSD/trades.json?since='+since.to_s 
      logger.debug "apiX_result_code: " + respuesta.code.to_s
     
      if respuesta.code.to_s === "200"
        res = JSON.parse(respuesta.body)
        @result = collection.insert_many(res)
        #info log
        logger.debug "apiX_result_inserted_trades: " + @result.inserted_count.to_s
        @response = '{
          "response":[{
            "status": "ok"
            "code": "200",
          }]
        }'
        json_response(@response)
      else
        #info log
        logger.debug "apiX_result_code: " + respuesta.code.to_s
        logger.debug "apiX_result_error: " + respuesta.body
        @response = '{
          "response":[{
            "status": "error"
            "code": "'+respuesta.code.to_s+'",
          }]
        }'
        json_response(@response)
      end

    end
    
end
