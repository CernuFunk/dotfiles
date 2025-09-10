#!/bin/bash


if [[ $(systemctl status mysql | awk  '/Active:/ { print $2}') == "inactive" ]]; then
	printf "Startup del server MySQL...\n"
	systemctl start mysql
	sleep 2
	#exit 0
else
	printf "Server MySQL già attivo...\n"
	sleep 1
fi

if [[ $(systemctl status redis | awk  '/Active:/ { print $2}') == "inactive" ]]; then
	printf "Startup del servizio Redis...\n"
	systemctl start redis
	sleep 2
	#exit 0
else
	printf "Servizio Redis già attivo..."
	sleep 1
fi
