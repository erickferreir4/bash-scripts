#!/bin/bash


IP=$( curl -s ifconfig.me )
#IP='199.119.74.245' test ip
IPINFO=$( curl -s ipinfo.io/$IP )
COUNTRY_CODE=$(echo $IPINFO | grep -o "country[^,]*" |  grep -o "[^:]*$" | grep -o "[a-zA-Z].*[^\"]")


CURRENCIE_INFO=$(curl -s https://restcountries.eu/rest/v2/alpha/$COUNTRY_CODE )
CURRENCIE=$(echo $CURRENCIE_INFO | grep -o "currencies[^,]*" | grep -o "[^:]*$" | grep -o "[a-zA-Z].*[^\"]")


SYMBOL=$(echo $CURRENCIE_INFO | grep -o "symbol[^,]*" | grep -o "[^:]*$" | grep -oP ".*[\"^]" | grep -o "[^\"]*")


#api 1 alternative
#VALUE=$(curl -s https://economia.awesomeapi.com.br/json/all/USD-$CURRENCIE | grep -o "ask[^,]*," | grep -o "[0-9].*[0-9]")

#api 2 alternative
CURRENCIES=$(curl -s https://api.exchangeratesapi.io/latest?base=USD )
VALUE=$(echo $CURRENCIES | grep -o "$CURRENCIE[^,]*" | grep -o "[^:]*$")


#echo $COUNTRY_CODE
#echo $IPINFO
#echo $CURRENCIE

echo "$SYMBOL: $VALUE"



