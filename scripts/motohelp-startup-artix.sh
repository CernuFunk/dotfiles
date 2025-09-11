#!/bin/bash


if [[ $(rc-service mysql status | awk  '/ERROR!/ { print $3" "$4" "$5}') == "is not running" ]]; then
	printf "Startup del server MySQL...\n"
	sudo rc-service mysql start
	sleep 2
	#exit 0
else
	printf "Server MySQL già attivo...\n"
	sleep 1
fi

if [[ $(rc-service redis status | awk  '/status:/ { print $3}') == "stopped" ]]; then
	printf "Startup del servizio Redis...\n"
	sudo rc-service redis start 
	sleep 2
	#exit 0
else
	printf "Servizio Redis già attivo..."
	sleep 1
fi
