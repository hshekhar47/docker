FROM imhshekhar47/centos:latest

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=deployer
ARG GNAME=deployer 

ENV JAVA_HOME=/usr/lib/jvm/jre-openjdk/

USER root
RUN yum -y update \
    && yum install -y java-1.8.0-openjdk \
    && yum clean all \
    && echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/profile \
    && echo "export PATH=\${PATH}:\${JAVA_HOME}/bin" >>  /etc/profile \
    && groupadd ${GNAME} && useradd -ms /bin/bash -g ${GNAME} ${UNAME}
    
USER ${UNAME}
WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/bin/bash"]