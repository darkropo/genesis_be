####
###
## For Documentation
# https://currentmillis.com/ 
# https://docs.gemini.com/rest-api/#trade-history

class PopuladorGeminiController < ActionController::API
    include Response
    include ExceptionHandler

    def populateGemini
        conn = DatabaseConection.new
        client = conn.connect      
        collection = client[:gen_gemini]
        find_tid = collection.find().sort({timestamp:-1}).first
        if find_tid.present?
            since = find_tid[:timestamp]     
        else
            ##este timestamp es en milisegundos
            since = params[:since].to_i
        end

        apix = HttpCall.new
        respuesta = apix.call('https://api.gemini.com/v1/trades/btcusd?limit_trades=500&timestamp='+since.to_s)
        #info log
        logger.debug "gemini_call:" + 'https://api.gemini.com/v1/trades/btcusd?limit_trades=500&timestamp='+since.to_s 
        logger.debug "gemini_result_code: " + respuesta.code.to_s

        if respuesta.code.to_s === "200"
            res = JSON.parse(respuesta.body)
            @result = collection.insert_many(res)
            #info log
            logger.debug "gemini_result_inserted_trades: " + @result.inserted_count.to_s
            @response = '{
              "response":[{
                "status": "ok"
                "code": "200",
              }]
            }'
            
          else
            #info log
            logger.debug "gemini_result_code: " + respuesta.code.to_s
            logger.debug "gemini_result_error: " + respuesta.body
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
