####
###
## For Documentation
# https://currentmillis.com/ 
# https://docs.bitfinex.com/reference#rest-public-trades

class PopuladorKrakenController < ActionController::API
    include Response
    include ExceptionHandler

    def populateKraken
        conn = DatabaseConection.new
        client = conn.connect      
        collection = client[:gen_kraken]
        find_tid = collection.find().sort({hora:-1}).first
        if find_tid.present?
            since = find_tid[:last]     
        else
            ##este timestamp es en milisegundos
            since = params[:since].to_i
        end

        apix = HttpCall.new
        respuesta = apix.call('https://api.kraken.com/0/public/Trades?pair=XBTUSD&since='+since.to_s)
        #info log
        logger.debug "kraken_call:" + 'https://api.kraken.com/0/public/Trades?pair=XBTUSD&since='+since.to_s 
        logger.debug "kraken_result_code: " + respuesta.code.to_s

        if respuesta.code.to_s === "200"
            res = JSON.parse(respuesta.body)

            resMap = res['result']['XXBTZUSD'].map{|s| {precio: s[0], volumen: s[1], hora: s[2], compraoventa: s[3], mercadoylimite: s[4], varios: s[5], last: res['result']['last'] } } 
            resJson = resMap           
            @result = collection.insert_many(resJson)
            #info log
            logger.debug "kraken_result_inserted_trades: " + @result.inserted_count.to_s
            @response = '{
              "response":[{
                "status": "ok"
                "code": "200",
              }]
            }'
            
          else
            #info log
            logger.debug "kraken_result_code: " + respuesta.code.to_s
            logger.debug "kraken_result_error: " + respuesta.body
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
