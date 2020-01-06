#!/usr/bin/env bash

CH_IMAGE=yandex/clickhouse-server:latest
CH_SHARDS=3
CH_HOST=$(hostname -I | cut -d' ' -f1)
CH_PORT_HTTP=8123
CH_PORT_TCP=9000
CH_CONFIG_PATH=${PWD}/config/config.xml
CH_USERS_PATH=${PWD}/config/users.xml
for shard in $(seq 0 $((CH_SHARDS-1))); do
    # Prepare config for this particular shard
    config_path=${CH_CONFIG_PATH}_${shard}
    cp ${CH_CONFIG_PATH} ${config_path}
    shard_port_http=$((CH_PORT_HTTP+shard))
    shard_port_tcp=$((CH_PORT_TCP+shard))
    sed -i "s/{host}/${CH_HOST}/g" ${config_path}
    for shard2 in $(seq 0 $((CH_SHARDS-1))); do
        shard2_port_tcp=$((CH_PORT_TCP+shard2))
        sed -i "s/{port-shard${shard2}}/${shard2_port_tcp}/g" ${config_path}
    done
    # Restart container with prepared config
    container=clickhouse_${shard}
    echo "Stop and remove container ${container} ..."
    docker rm -f ${container} || true
    echo "Start container ${container} ..."
    docker run \
        --name=${container} \
        -p ${shard_port_http}:${CH_PORT_HTTP} \
        -p ${shard_port_tcp}:${CH_PORT_TCP} \
        -v ${config_path}:/etc/clickhouse-server/config.xml \
        -v ${CH_USERS_PATH}:/etc/clickhouse-server/users.xml \
        -d ${CH_IMAGE}
done
