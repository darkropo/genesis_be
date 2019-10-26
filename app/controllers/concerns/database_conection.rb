require 'mongo'
class DatabaseConection

    def connect
        #client = Mongo::Client.new("mongodb+srv://gen_dev:16151662@genesisv1-4en0l.gcp.mongodb.net/genesis_db_v1_dev?retryWrites=true&w=majority
        #")
        client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'genesis_v1')
        
        return client
    end
end
