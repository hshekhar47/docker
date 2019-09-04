FROM imhshekhar47/centos:latest AS builder

ARG KAFKA_VERSION=2.12
ARG SCALA_VERSION=2.3.0

USER root 
RUN curl "https://www.apache.org/dist/kafka/${SCALA_VERSION}/kafka_${KAFKA_VERSION}-${SCALA_VERSION}.tgz" -o /tmp/kafka.tgz \
    && tar xzf /tmp/kafka.tgz -C /etc/ \
    && rm -rf /tmp/kafka.tgz \
    && rm -r /etc/kafka_${KAFKA_VERSION}-${SCALA_VERSION}/site-docs \
    && rm -r /etc/kafka_${KAFKA_VERSION}-${SCALA_VERSION}/bin/windows


FROM imhshekhar47/centos-jre8:latest

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=kafka
ARG GNAME=deployer 
ARG KAFKA_VERSION=2.12
ARG SCALA_VERSION=2.3.0

ENV KAFKA_HOME=/etc/kafka_${KAFKA_VERSION}-${SCALA_VERSION}

COPY --from=builder /etc/kafka_${KAFKA_VERSION}-${SCALA_VERSION}/ /etc/kafka_${KAFKA_VERSION}-${SCALA_VERSION}/
COPY entrypoint.sh /boot/

USER root
RUN yum -y update \
    && yum install -y iproute \
    && yum clean all \
    && echo "export KAFKA_HOME=${KAFKA_HOME}" >> /etc/profile \
    && mkdir -p /var/log/kafka \
    && useradd -ms /bin/bash  ${UNAME} \
    && chown -R ${UNAME}:${UNAME} /etc/ /var/log/kafka /boot/ 

USER ${UNAME}
WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/boot/entrypoint.sh"]