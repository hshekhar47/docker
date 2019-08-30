FROM imhshekhar47/debian:latest

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

ARG UNAME=deployer
ARG GNAME=deployer 

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

USER root
RUN apt-get update \
    && apt-get install -y openjdk-8-jre \
    && rm -rf /var/lib/apt/lists/* \
    && echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/profile \
    && echo "export PATH=\${PATH}:\${JAVA_HOME}/bin" >>  /etc/profile \
    && groupadd ${GNAME} && useradd -ms /bin/bash -g ${GNAME} ${UNAME}
    
USER ${UNAME}
WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/bin/bash"]