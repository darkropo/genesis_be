# README

https://rubyinstaller.org/downloads/

Descargar Ruby+Devkit 2.6.5-1 (x64)

Instalar

https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2012plus-4.2.1-signed.msi
Instalar Mongodb

Arracar el mongo en este url 127.0.0.1:27017
crear esta coleccion: genesis_v1

Arrancar el servidor ruby con el siguente comando: rails server


# Para el llamado de las apis de populacion de mongo

## BitBay
### El parametro since es un id interno de la api de bitbay
http://localhost:3000/populatebitbay?since=285000

## BitX
### El parametro since es en unix timestamp en milisegundos
http://localhost:3000/populatebitx?since=1546311600000

## Bitfinex
### El parametro since es en unix timestamp en milisegundos
http://localhost:3000/populatebitfinex?since=1546311600000

## Bitflyer
### El parametro since es un id interno de la api de bitflyer
http://localhost:3000/populatebitflyer?since=1350000000

## Bitstamp
http://localhost:3000/populatebitstamp

## Gemini
### El parametro since es en unix timestamp en milisegundos
http://localhost:3000/populategemini?since=1573516809

## Kraken
### El parametro since es en unix timestamp en milisegundos
http://localhost:3000/populatekraken?since=1574098423508708579
