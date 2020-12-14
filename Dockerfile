FROM ubuntu:16.04

ENV PATH=/opt/anaconda/bin:$PATH

COPY install.sh /usr/bin/install.sh
RUN chmod +x /usr/bin/install.sh && bash install.sh

COPY run_kafka.sh /usr/bin/run_kafka.sh
RUN chmod +x /usr/bin/run_kafka.sh && bash run_kafka.sh

ENV KAFKA_BROKER=localhost:9092
ENV FLASK_PORT=9999

CMD ["bash", "-c", "/usr/bin/launcher.sh"]
