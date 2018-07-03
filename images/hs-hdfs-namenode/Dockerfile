FROM hshekhar47/hdfs-core:0.1

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=deployer
ARG GNAME=hadoop

ARG HIVE_VERSION=2.3.3

ENV INSTALL_DIR=/opt \
    HIVE_HOME=/opt/hive-2.3.3

COPY apache-hive-${HIVE_VERSION}-bin.tar.gz /tmp
ADD conf /tmp/conf
ADD scripts/ /usr/bin/ 

RUN sudo apt-get update && \
    sudo tar -xvf /tmp/apache-hive-${HIVE_VERSION}-bin.tar.gz -C ${INSTALL_DIR} && \
    sudo rm -rf /tmp/apache-hive-${HIVE_VERSION}* && \
    mv ${INSTALL_DIR}/apache-hive-${HIVE_VERSION}-bin ${INSTALL_DIR}/hive-${HIVE_VERSION} && \
    sudo rm -rf ${INSTALL_DIR}/hive-${HIVE_VERSION}/lib/log4j-slf4j-impl-*.jar && \
    sudo cp /tmp/conf/hive/* ${HIVE_HOME}/conf && \
    sudo ln -s ${INSTALL_DIR}/common-libs/mysql-connector-java-5.1.45-bin.jar ${HIVE_HOME}/lib/mysql-connector-java-5.1.45-bin.jar && \
    sudo chown -R ${UNAME}:${GNAME} ${INSTALL_DIR} && \
    echo "export HIVE_HOME=${HIVE_HOME}" >> ~/.bashrc && \
    export PATH=${PATH}:${HIVE_HOME}/bin && \
    sudo chmod +x /usr/bin/bootstrap.sh && \
    sudo rm -rf /tmp/conf && \
    sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/usr/bin/bootstrap.sh && /bin/bash"]
