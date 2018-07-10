FROM hshekhar47/debian-jre8:0.1

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive
ARG HADOOP_VERSION=2.7.6
ARG SPARK_VERSION=2.3.0
ARG SQOOP_VERSION=1.4.7

ARG UNAME=deployer
ARG GNAME=hadoop

ENV INSTALL_DIR=/opt \
    HADOOP_HOME=/opt/hadoop-2.7.6 \
    HADOOP_APPDATA=/opt/data/apps \
    SPARK_HOME=/opt/spark-2.3.0 \
    SQOOP_HOME=/opt/sqoop-1.4.7

#COPY http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz /tmp/
COPY hadoop-${HADOOP_VERSION}.tar.gz /tmp/
COPY spark-${SPARK_VERSION}-bin-hadoop2.7.tgz /tmp/
COPY sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0.tar.gz /tmp/
COPY ojdbc6.jar /tmp/
COPY mysql-connector-java-5.1.45-bin.jar /tmp/

ADD conf /tmp/conf

USER ${UNAME}

RUN sudo apt-get update && \
    sudo groupadd ${GNAME} && \
    sudo usermod -a -G ${GNAME} ${UNAME} && \
    sudo mkdir -p ${INSTALL_DIR}/common-libs && \
    sudo tar -xvf /tmp/hadoop-${HADOOP_VERSION}.tar.gz -C ${INSTALL_DIR} && \
    sudo rm -rf /tmp/hadoop-${HADOOP_VERSION}* && \
    sudo cp /tmp/conf/hadoop/* ${HADOOP_HOME}/etc/hadoop/ && \
    sudo tar -xvf /tmp/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz -C ${INSTALL_DIR} && \
    sudo mv ${INSTALL_DIR}/spark-${SPARK_VERSION}-bin-hadoop2.7 ${INSTALL_DIR}/spark-${SPARK_VERSION} && \
    sudo rm -rf /tmp/spark-${SPARK_VERSION}* && \
    sudo cp /tmp/conf/spark/* ${SPARK_HOME}/conf/ && \
    sudo tar -xvf /tmp/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0.tar.gz -C ${INSTALL_DIR} && \
    sudo mv ${INSTALL_DIR}/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0 ${INSTALL_DIR}/sqoop-${SQOOP_VERSION} && \
    sudo rm -rf /tmp/sqoop-${SQOOP_VERSION}* && \
    sudo mv /tmp/ojdbc6.jar ${INSTALL_DIR}/common-libs && \
    sudo ln -s ${INSTALL_DIR}/common-libs/ojdbc6.jar ${SQOOP_HOME}/lib/ojdbc6.jar && \
    sudo mv /tmp/mysql-connector-java-5.1.45-bin.jar ${INSTALL_DIR}/common-libs && \
    sudo ln -s ${INSTALL_DIR}/common-libs/mysql-connector-java-5.1.45-bin.jar ${SQOOP_HOME}/lib/mysql-connector-java.jar && \
    sudo ln -s ${INSTALL_DIR}/common-libs/mysql-connector-java-5.1.45-bin.jar ${SPARK_HOME}/jars/mysql-connector-java.jar && \
    sudo chown -R ${UNAME}:${GNAME} ${INSTALL_DIR} && \ 
    echo "export HADOOP_HOME=${HADOOP_HOME}" >> ~/.bashrc && \
    echo "export SPARK_HOME=${SPARK_HOME}" >> ~/.bashrc && \
    echo "export SQOOP_HOME=${SQOOP_HOME}" >> ~/.bashrc && \
    echo 'export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop' >> ~/.bashrc && \
    echo 'export LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native' >> ~/.bashrc && \
    echo 'export HADOOP_CLASSPATH=/opt/common-libs/*:${HADOOP_HOME}/lib/*:${SPARK_HOME}/jars/*' >> ~/.bashrc && \
    echo 'export PATH=${PATH}:${HADOOP_HOME}/bin:${SPARK_HOME}/bin:${SQOOP_HOME}/bin' >> ~/.bashrc && \
    sudo rm -rf /tmp/conf && \
    sudo rm -rf /var/lib/apt/lists/* 

# Spark ports
EXPOSE 7077 6066 8080 8081
# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088

WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/bin/bash"]