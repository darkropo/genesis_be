class PopuladorController < ActionController::API
    include Response
    include ExceptionHandler

    def populate()
      since = params[:since]
      apix = HttpCall.new
      date = ""
      find = ""
      result = ""
      respuesta = apix.call('https://bitbay.net/API/Public/BTCUSD/trades.json?since='+since)
      conn = DatabaseConection.new
      client = conn.connect      
      collection = client[:gen_api_x]

      respuesta.each do |c|
        tid = c['tid']
      
        find = collection.find({:tid=>tid}).first

        if find.present?
          
          result = "update"
        else
          result = collection.insert_one(c)
          result = "insert"
        end   
          
      end
     # doc = respuesta[0]
       # result = collection.insert_one(doc)
         # returns 1, because one document was inserted        
       @todos = result
       json_response(@todos)
       
    end
    
end
