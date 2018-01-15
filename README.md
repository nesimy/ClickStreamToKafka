`docker run --rm --net=host -v /tmp:/tmp -it dserban/clickstreamtokafka bash`
```
cd /opt/ClickStreamToKafka/code

KAFKA_BROKER=localhost:9092 FLASK_PORT=9999 python webapp.py

KAFKA_BROKER=192.168.0.15:9092 FLASK_PORT=9999 python webapp.py
```
