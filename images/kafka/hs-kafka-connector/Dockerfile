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
ADD --chown=kafka:kafka plugins/ /home/${UNAME}/
ADD --chown=kafka:kafka plugin_download.sh /usr/local/bin/

USER root
RUN yum -y update \
    && yum clean all \
    && mkdir -p /tmp/maven_dep/ \
    && chown -R ${UNAME}:${GNAME} /tmp/maven_dep/ \
    && chown -R ${UNAME}:${UNAME} /etc/ 


USER ${UNAME}
WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/boot/entrypoint.sh"]