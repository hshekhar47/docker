FROM hshekhar47/debian-jre8:0.1

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive
ARG HADOOP_VERSION=2.7.6
ARG SPARK_VERSION=2.3.0
ARG HBASE_VERSION=2.0.1

ARG UNAME=deployer
ARG GNAME=hadoop

ENV INSTALL_DIR=/opt \
    HADOOP_HOME=/opt/hadoop-2.7.6 \
    SPARK_HOME=/opt/spark-2.3.0 \
    HBASE_HOME=/opt/hbase-2.0.1

#COPY http://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz /tmp/
COPY hadoop-${HADOOP_VERSION}.tar.gz /tmp/
COPY spark-${SPARK_VERSION}-bin-hadoop2.7.tgz /tmp/
COPY hbase-${HBASE_VERSION}-bin.tar.gz /tmp/
COPY ojdbc6.jar /tmp/
COPY mysql-connector-java-5.1.45-bin.jar /tmp/

ADD conf /tmp/conf

RUN sudo apt-get update && \
    sudo groupadd ${GNAME} && \
    sudo usermod -a -G ${GNAME} ${UNAME} && \
    sudo tar -xvf /tmp/hadoop-${HADOOP_VERSION}.tar.gz -C ${INSTALL_DIR} && \
    sudo rm -rf /tmp/hadoop-${HADOOP_VERSION}* && \
    sudo cp /tmp/conf/hadoop/* ${HADOOP_HOME}/etc/hadoop/ && \
    sudo mv /tmp/ojdbc6.jar ${HADOOP_HOME}/share/hadoop/common/lib && \
    sudo mv /tmp/mysql-connector-java-5.1.45-bin.jar ${HADOOP_HOME}/share/hadoop/common/lib && \
    sudo chown -R root:root ${JAVA_HOME} && \ 
    sudo tar -xvf /tmp/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz -C ${INSTALL_DIR} && \
    sudo mv ${INSTALL_DIR}/spark-${SPARK_VERSION}-bin-hadoop2.7 ${SPARK_HOME} && \
    sudo rm -rf /tmp/spark-${SPARK_VERSION}* && \
    sudo tar -xvf /tmp/hbase-${HBASE_VERSION}-bin.tar.gz -C ${INSTALL_DIR} && \
    sudo rm -rf /tmp/hbase-${HBASE_VERSION}-bin.tar.gz && \
    sudo cp /tmp/conf/hbase/hbase-*.xml ${HBASE_HOME}/conf/ && \
    sudo chown -R ${UNAME}:${GNAME} ${INSTALL_DIR} && \ 
    echo "export HADOOP_HOME=${HADOOP_HOME}" >> ~/.bashrc && \
    echo 'export HADOOP_MAPRED_HOME=${HADOOP_HOME}' >> ~/.bashrc && \
    echo 'export HADOOP_COMMON_HOME=${HADOOP_HOME}' >> ~/.bashrc && \
    echo 'export HADOOP_HDFS_HOME=${HADOOP_HOME}' >> ~/.bashrc && \
    echo 'export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop' >> ~/.bashrc && \
    echo 'export YARN_HOME=${HADOOP_HOME}' >> ~/.bashrc && \
    echo "export SPARK_HOME=${SPARK_HOME}" >> ~/.bashrc && \
    echo "export HBASE_HOME=${HBASE_HOME}" >> ~/.bashrc && \
    echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native' >> ~/.bashrc && \
    echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib -Djava.security.egd=file:/dev/../dev/urandom"' >>  ~/.bashrc && \
    echo "export CLASSPATH=$CLASSPATH:${HADOOP_HOME}/lib/*:${HBASE_HOME}/lib/*:." >> ~/.bashrc && \
    echo 'export PATH=${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${SPARK_HOME}/bin:${HBASE_HOME}/bin' >> ~/.bashrc && \
    echo 'export JAVA_LIBRARY_PATH=${JAVA_LIBRARY_PATH}:${HADOOP_HOME}/lib/native' >> ~/.bashrc && \
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