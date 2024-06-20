#!/bin/sh
set -e

docker compose down -v

set +e
docker kill $(docker ps -a -q)
docker network rm zapp_network

set -e

sleep 5

docker compose up -d zokrates

sleep 5

docker compose up -d timber

sleep 5

docker compose up -d zapp --build --wait
