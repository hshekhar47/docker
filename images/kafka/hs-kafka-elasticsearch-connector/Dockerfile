FROM imhshekhar47/kafka:latest

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=kafka
ARG KAFKA_VERSION=2.12
ARG SCALA_VERSION=2.3.0

ENV KAFKA_CONNECT_PLUGINS_DIR=$KAFKA_HOME/connect 

COPY connect $KAFKA_HOME/connect/
COPY entrypoint.sh /boot/

USER root
RUN yum -y update \
    && yum clean all \
    && chown -R ${UNAME}:${UNAME} $KAFKA_HOME/connect 


USER ${UNAME}
WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/boot/entrypoint.sh"]