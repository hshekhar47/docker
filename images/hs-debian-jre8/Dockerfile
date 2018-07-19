FROM hshekhar47/debian:0.1

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

ARG UNAME=deployer
ARG GNAME=sysadmin 

ENV JAVA_HOME=/usr/lib/jvm/jdk1.8.0_172

COPY server-jre-8u172-linux-x64.tar.gz /tmp/

USER root
RUN apt-get update && \
    mkdir -p /usr/lib/jvm && \
	tar -xvf /tmp/server-jre-8u172-linux-x64.tar.gz -C /usr/lib/jvm && \
    rm -rf /tmp/server-jre-8u172-linux-x64.tar.gz && \
    rm -rf /var/lib/apt/lists/* && \
    sudo chown -R ${UNAME}:${GNAME} ${JAVA_HOME} && \
    echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/environment && \
    echo "export JAVA_HOME=${JAVA_HOME}" >> /home/${UNAME}/.bashrc && \
    echo "export PATH=${PATH}:${JAVA_HOME}/bin" >>  /home/${UNAME}/.bashrc
    
USER ${UNAME}
WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c", "bash"]
CMD ["/bin/bash"]