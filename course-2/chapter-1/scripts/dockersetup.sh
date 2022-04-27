#!/bin/zsh

echo "==> Creating network and persistent volumes..."

docker network create -d bridge redpandanet && \
docker volume create redpanda1 && \
docker volume create redpanda2 && \
docker volume create redpanda3

echo "==> Starting Redpanda nodes..."

docker run -d \
--pull=always \
--name=redpanda-1 \
--hostname=redpanda-1 \
--net=redpandanet \
-p 8082:8082 \
-p 9092:9092 \
-p 9644:9644 \
-v "redpanda1:/var/lib/redpanda/data" \
docker.vectorized.io/vectorized/redpanda:latest redpanda start \
--smp 1  \
--memory 1G  \
--reserve-memory 0M \
--overprovisioned \
--node-id 0 \
--check=false \
--pandaproxy-addr 0.0.0.0:8082 \
--advertise-pandaproxy-addr 127.0.0.1:8082 \
--kafka-addr 0.0.0.0:9092 \
--advertise-kafka-addr 127.0.0.1:9092 \
--rpc-addr 0.0.0.0:33145 \
--advertise-rpc-addr redpanda-1:33145 &&

docker run -d \
--pull=always \
--name=redpanda-2 \
--hostname=redpanda-2 \
--net=redpandanet \
-p 9093:9093 \
-v "redpanda2:/var/lib/redpanda/data" \
docker.vectorized.io/vectorized/redpanda:latest redpanda start \
--smp 1  \
--memory 1G  \
--reserve-memory 0M \
--overprovisioned \
--node-id 1 \
--seeds "redpanda-1:33145" \
--check=false \
--pandaproxy-addr 0.0.0.0:8083 \
--advertise-pandaproxy-addr 127.0.0.1:8083 \
--kafka-addr 0.0.0.0:9093 \
--advertise-kafka-addr 127.0.0.1:9093 \
--rpc-addr 0.0.0.0:33146 \
--advertise-rpc-addr redpanda-2:33146 &&

docker run -d \
--pull=always \
--name=redpanda-3 \
--hostname=redpanda-3 \
--net=redpandanet \
-p 9094:9094 \
-v "redpanda3:/var/lib/redpanda/data" \
docker.vectorized.io/vectorized/redpanda:latest redpanda start \
--smp 1  \
--memory 1G  \
--reserve-memory 0M \
--overprovisioned \
--node-id 2 \
--seeds "redpanda-1:33145" \
--check=false \
--pandaproxy-addr 0.0.0.0:8084 \
--advertise-pandaproxy-addr 127.0.0.1:8084 \
--kafka-addr 0.0.0.0:9094 \
--advertise-kafka-addr 127.0.0.1:9094 \
--rpc-addr 0.0.0.0:33147 \
--advertise-rpc-addr redpanda-3:33147
