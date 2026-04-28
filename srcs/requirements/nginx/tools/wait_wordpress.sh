#!/bin/bash

timeout=60

while ! nc -z wordpress 9000; do
	sleep 1
	timeout=$((timeout - 1))
	if [ "$timeout" -le 0 ]; then
		echo "WordPress failed to start."
		exit 1
	fi
done

exec nginx -g "daemon off;"
