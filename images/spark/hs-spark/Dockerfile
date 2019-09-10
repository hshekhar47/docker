FROM imhshekhar47/centos:latest AS builder

ARG SPARK_VERSION=2.4.4
ARG HADOOP_VERSION=2.7
ARG SCALA_VERSION=2.12.4

USER root 
RUN yum -y update \
    && curl "http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" -o /tmp/spark.tgz \
    && tar -xf /tmp/spark.tgz -C /etc/ \
    && find /etc/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} -name "*.cmd" -delete \
    && rm -r /etc/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/kubernetes \
    && tar -xf /tmp/spark.tgz 

#----------------------#

FROM imhshekhar47/centos-jre8:latest

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=spark
ARG GNAME=deployer 

ARG SPARK_VERSION=2.4.4
ARG HADOOP_VERSION=2.7
ARG SCALA_VERSION=2.12.4

ENV SCALA_HOME=/etc/scala-${SCALA_VERSION}/ \
    SPARK_HOME=/etc/spark-${SPARK_VERSION}

COPY --from=builder /etc/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /etc/spark-${SPARK_VERSION}/

USER root
RUN yum -y update \
    && yum clean all \
    && echo "export SCALA_HOME=${SCALA_HOME}" >> /etc/profile \
    && echo "export SPARK_HOME=${SPARK_HOME}" >> /etc/profile \
    && mkdir -p /var/log/spark /boot/ \
    && useradd -ms /bin/bash ${UNAME} \ 
    && usermod -a -G ${GNAME} ${UNAME} \
    && chown -R ${UNAME}:${UNAME} /etc/ /var/log/spark /boot/ 

USER ${UNAME}
WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/bin/bash"]