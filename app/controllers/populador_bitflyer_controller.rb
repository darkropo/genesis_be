####
###
## For Documentation
# 
# https://lightning.bitflyer.com/docs/playground?lang=en#GETv1%2Fexecutions%3Fproduct_code%3D%7Bproduct_code%7D%26count%3D%7Bcount%7D%26before%3D%7Bbefore%7D%26after%3D%7Bafter%7D/ruby

class PopuladorBitflyerController < ActionController::API
    include Response
    include ExceptionHandler

    def populateBitflyer
        conn = DatabaseConection.new
        client = conn.connect      
        collection = client[:gen_bitflyer]
        find_tid = collection.find().sort({id:-1}).first
        if find_tid.present?
            since = find_tid[:id]     
        else
            ##este since es un id interno de bit
            since = params[:since].to_i
        end

        apix = HttpCall.new
        while true
          sleep 10
            respuesta = apix.call('https://api.bitflyer.com/v1/executions?product_code=BTC_USD&count=300&after='+since.to_s)
            #info log
            logger.debug "bitflyer_call:" + 'https://api.bitflyer.com/v1/executions?product_code=BTC_USD&count=300&after='+since.to_s 
            logger.debug "bitflyer_result_code: " + respuesta.code.to_s

            if respuesta.code.to_s === "200"
                res = JSON.parse(respuesta.body)

                @result = collection.insert_many(res)
                #info log
                logger.debug "bitflyer_result_inserted_trades: " + @result.inserted_count.to_s
                @response = '{
                  "response":[{
                    "status": "ok"
                    "code": "200",
                  }]
                }'
                
              else
                #info log
                logger.debug "bitflyer_result_code: " + respuesta.code.to_s
                logger.debug "bitflyer_result_error: " + respuesta.body
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
