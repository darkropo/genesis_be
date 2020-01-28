####
###
## For Documentation
# https://currentmillis.com/ 
# https://docs.gemini.com/rest-api/#trade-history
require 'em/pure_ruby'
require 'coinbase/exchange'
require 'eventmachine'

class PopuladorCoinbaseController < ActionController::API
    include Response
    include ExceptionHandler
    
    def populateCoinbase
        #Estas valores estan hardcodeados aca por que el api solo tiene permiso de lectura
        #si se llegara a cambiar los permisos se deberia pasar estos valores por parametros por seguridad

        api_key = "5688bf3d3bac1521c66ef50e245ede2c"
        api_secret = "Vac1vhlTRhSznw1IpxQy/lVOtjJlJbzmb2EN/poG5NgjIKku1GcJWFw4oOJhdkgarRPd+/A1tzC3b/whR6wIUQ=="
        api_pass = "krypgen8945"

        conn = DatabaseConection.new
        client = conn.connect      
        collection = client[:gen_coinbase]
        find_tid = collection.find().sort({timestamp:-1}).first
        if find_tid.present?
            since = find_tid[:timestamp]     
        else
            ##este timestamp es en milisegundos
            since = params[:since].to_i
        end

        #rest_api = Coinbase::Exchange::AsyncClient.new(api_key, api_secret, api_pass)
       
        #info log
        #logger.debug "coinbase_call:" + 'https://api.gemini.com/v1/trades/btcusd?limit_trades=500&timestamp='+since.to_s 
        #logger.debug "gemini_result_code: " + respuesta.code.to_s

        
    end
end
