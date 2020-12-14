#/bin/bash

cd /opt/kafka
echo 'starting zookeeper..'
nohup bin/zookeeper-server-start.sh -daemon config/zookeeper.properties &
sleep 5
echo 'starting kafka..'
nohup bin/kafka-server-start.sh -daemon config/server.properties &
sleep 5
bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic raw

