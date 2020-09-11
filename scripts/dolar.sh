#!/bin/bash

#
#get api response
#
DOLAR_HOJE=$(curl -s https://economia.awesomeapi.com.br/json/all/USD-BRL | grep -o "ask[^,]*," | grep -o "[0-9].*[0-9]")

#date
date

# print in terminal
echo "Dolar: US$ 1"
echo "R$ $DOLAR_HOJE"






