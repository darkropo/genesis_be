Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/populatebitbay', to: 'populador_bit_bay#populateBitBay'
  get '/populatebitx', to: 'populador_bit_x#populateBitX'
  get '/populatebitfinex', to: 'populador_bitfinex#populateBitfinex'
  get '/populatebitflyer', to: 'populador_bitflyer#populateBitflyer'
  get '/populatebitstamp', to: 'populador_bitstamp#populateBitstamp'
  get '/populategemini', to: 'populador_gemini#populateGemini'

end
