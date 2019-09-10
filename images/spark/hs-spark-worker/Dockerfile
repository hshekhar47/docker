
FROM imhshekhar47/spark:latest

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=spark
ARG GNAME=spark

ENV SPARK_WORKER_WEBUI_PORT=8081

COPY entrypoint.sh /boot/entrypoint.sh

USER root
RUN yum -y update \
    && yum clean all 

USER ${UNAME}
WORKDIR /home/${UNAME}

EXPOSE 8081 

ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "/boot/entrypoint.sh" ]