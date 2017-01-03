#!/bin/sh

if [ -z "$1" ]; then
	echo "Give a sensu URL please, e.g.:"
	echo "    $0 http://sensu.example.com:4567"
fi

SENSU_URL=$1

curl -s $SENSU_URL/results | jq 'map(select((.check.name | contains("raid")) and .check.status != 0)) | .[] | {client: .client, command: .check.command, name: .check.name, output: .check.output}'

