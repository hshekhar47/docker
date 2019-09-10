
FROM imhshekhar47/spark:latest

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=spark
ARG GNAME=spark

ENV SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_WEBUI_PORT=8080 

COPY entrypoint.sh /boot/entrypoint.sh

USER root
RUN yum -y update \
    && yum clean all 

USER ${UNAME}
WORKDIR /home/${UNAME}

EXPOSE 8080 7077

ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "/boot/entrypoint.sh" ]