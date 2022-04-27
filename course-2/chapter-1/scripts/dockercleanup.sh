#!/bin/zsh

echo "==> Shutting down and removing containers..."

docker stop redpanda-1 redpanda-2 redpanda-3 && \
docker rm redpanda-1 redpanda-2 redpanda-3

echo "==> Removing persistent volumes and network..."
docker volume rm redpanda1 redpanda2 redpanda3 && \
docker network rm redpandanet
