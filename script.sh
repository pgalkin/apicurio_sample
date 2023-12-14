#!/usr/bin/env sh

docker network create the_network
docker compose up -d mysql connect
docker compose run --rm -it debezium_tooling sh -c 'http -pHBhb -j connect:8083/connectors'
docker compose run --rm -it debezium_tooling sh -c 'http -pHBhb -j connect:8083/connectors < sample.json'
