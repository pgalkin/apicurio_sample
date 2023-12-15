#!/usr/bin/env sh

# Setup:
docker network create the_network
docker run --detach --volume /var/run/docker.sock:/var/run/docker.sock:ro --restart always --publish 53/udp --net the_network --name dnsdock aacebedo/dnsdock:latest-amd64 --domain localhost
DNS_IP=$(docker inspect --format '{{ .NetworkSettings.Networks.the_network.IPAddress }}' dnsdock)
export DNS_IP
docker run --detach --volume /var/run/docker.sock:/tmp/docker.sock:ro --restart always --publish 80:80 --net the_network --name nginx-proxy --label com.dnsdock.alias=localhost nginxproxy/nginx-proxy:latest
docker compose up -d mysql connect akhq
docker compose run --rm -it debezium_tooling sh -c 'http -pHBhb -j connect.localhost/connectors'
docker compose run --rm -it debezium_tooling sh -c 'http -pHBhb -j connect.localhost/connectors < sample.json'

# Cleanup:
#
# docker compose down
# docker volume rm apicurio_sample_history apicurio_sample_kafka_config apicurio_sample_kafka_data apicurio_sample_kafka_logs apicurio_sample_zookeeper_conf apicurio_sample_zookeeper_data apicurio_sample_zookeeper_logs apicurio_sample_zookeeper_txns
