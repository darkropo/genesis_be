####
###
## For Documentation
# https://currentmillis.com/ 
# https://www.luno.com/en/developers/api#operation/listTrades

class PopuladorBitXController < ActionController::API
    include Response
    include ExceptionHandler

    def populateBitX
        conn = DatabaseConection.new
        client = conn.connect      
        collection = client[:gen_bit_x]
        find_tid = collection.find().sort({timestamp:-1}).first
        if find_tid.present?
            since = find_tid[:timestamp]     
        else
            #lo llevo a milisegundos por que asi esta en el api
            since = params[:since].to_i * 1000 
        end

        apix = HttpCall.new
        respuesta = apix.call('https://api.mybitx.com/api/1/trades?pair=XBTEUR&since='+since.to_s)
        #info log
        logger.debug "bitX_call:" + 'https://api.mybitx.com/api/1/trades?pair=XBTEUR&since='+since.to_s 
        logger.debug "bitX_result_code: " + respuesta.code.to_s

        if respuesta.code.to_s === "200"
            res = JSON.parse(respuesta.body)
                       
            @result = collection.insert_many(res['trades'])
            #info log
            logger.debug "bitX_result_inserted_trades: " + @result.inserted_count.to_s
            @response = '{
              "response":[{
                "status": "ok"
                "code": "200",
              }]
            }'
            
          else
            #info log
            logger.debug "bitX_result_code: " + respuesta.code.to_s
            logger.debug "bitX_result_error: " + respuesta.body
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
