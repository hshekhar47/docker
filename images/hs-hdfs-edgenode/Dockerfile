FROM hshekhar47/hdfs-core:0.1

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=deployer
ARG GNAME=hadoop

ARG HIVE_VERSION=2.3.3
ARG SQOOP_VERSION=1.4.7

ENV INSTALL_DIR=/opt \
    HIVE_HOME=/opt/hive-2.3.3 \
    SQOOP_HOME=/opt/sqoop-1.4.7

COPY apache-hive-${HIVE_VERSION}-bin.tar.gz /tmp/
COPY sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0.tar.gz /tmp/
COPY conf /tmp/conf/

ADD scripts/ /usr/bin/

RUN sudo apt-get update && \
    sudo chmod +x /usr/bin/bootstrap.sh && \
    sudo tar -xvf /tmp/apache-hive-${HIVE_VERSION}-bin.tar.gz -C ${INSTALL_DIR} && \
    sudo rm -rf /tmp/apache-hive-*tar.gz && \
    mv ${INSTALL_DIR}/apache-hive-${HIVE_VERSION}-bin ${HIVE_HOME} && \
    sudo rm -f ${HIVE_HOME}/lib/log4j-slf4j-impl*jar && \
    sudo cp /tmp/conf/hive/hive-site*xml ${HIVE_HOME}/conf && \
    sudo tar -xvf /tmp/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0.tar.gz -C ${INSTALL_DIR} && \
    sudo rm -rf /tmp/sqoop-${SQOOP_VERSION}* && \
    sudo mv ${INSTALL_DIR}/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0 ${SQOOP_HOME} && \
    sudo chown -R ${UNAME}:${GNAME} ${HIVE_HOME} && \
    sudo chown -R ${UNAME}:${GNAME} ${SQOOP_HOME} && \
    echo "export HIVE_HOME=${HIVE_HOME}" >> ~/.bashrc && \
    echo 'export HIVE_CONF_DIR=${HIVE_HOME}/conf' >> ~/.bashrc && \
    echo "export SQOOP_HOME=${SQOOP_HOME}" >> ~/.bashrc && \
    echo 'export PATH=${PATH}:${HIVE_HOME}/bin:${SQOOP_HOME}/bin' >> ~/.bashrc && \
    echo 'export CLASSPATH=${CLASSPATH}:${HIVE_HOME}/lib/*' >> ~/.bashrc && \
    sudo rm -rf /tmp/conf && \
    sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/usr/bin/bootstrap.sh && /bin/bash"]