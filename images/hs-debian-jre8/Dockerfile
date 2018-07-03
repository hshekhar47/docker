FROM hshekhar47/debian:0.1

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

ARG UNAME=deployer
ARG GNAME=sysadmin 

ENV JAVA_HOME=/usr/lib/jvm/jdk1.8.0_172 \
	PATH=${PATH}:/usr/lib/jvm/jdk1.8.0_172/bin

COPY server-jre-8u172-linux-x64.tar.gz /tmp/

USER root
RUN apt-get update && \
    mkdir -p /usr/lib/jvm && \
	tar -xvf /tmp/server-jre-8u172-linux-x64.tar.gz -C /usr/lib/jvm && \
    rm -rf /tmp/server-jre-8u172-linux-x64.tar.gz && \
    rm -rf /var/lib/apt/lists/* && \
    echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/environment

USER ${UNAME}
WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c", "bash"]
CMD ["/bin/bash"]