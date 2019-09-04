FROM imhshekhar47/kafka:latest

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=kafka
ARG KAFKA_VERSION=2.12
ARG SCALA_VERSION=2.3.0

ENV KAFKA_CONNECT_PLUGINS_DIR=$KAFKA_HOME/connect \
    MAVEN_DEP_DESTINATION=$KAFKA_HOME/libs \
    CONFLUENT_VERSION=5.2.3 \
    MAVEN_REPO_CORE="https://repo1.maven.org/maven2" 

COPY entrypoint.sh /boot/
ADD --chown=kafka:kafka plugin_download.sh /usr/local/bin/

USER root
RUN yum -y update \
    && yum install -y iproute \
    && yum clean all \
    && plugin_download.sh confluent kafka-connect-elasticsearch "${CONFLUENT_VERSION}" \
    && plugin_download.sh central io/searchbox jest 2.0.0 \
    && plugin_download.sh central io/searchbox jest-common 2.0.0 \
    && plugin_download.sh central org/apache/httpcomponents httpcore-nio 4.4.4 \
    && plugin_download.sh central org/apache/httpcomponents httpcore 4.4.4 \
    && plugin_download.sh central org/apache/httpcomponents httpclient 4.5.2 \
    && plugin_download.sh central org/apache/httpcomponents httpasyncclient 4.1.1 \
    && plugin_download.sh central commons-codec commons-codec 1.9 \
    && plugin_download.sh central commons-logging commons-logging 1.2 \
    && plugin_download.sh central com/google/code/gson gson 2.6.2 \
    && chown -R ${UNAME}:${UNAME} /etc/ 


USER ${UNAME}
WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/boot/entrypoint.sh"]