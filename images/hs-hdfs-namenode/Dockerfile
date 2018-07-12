FROM hshekhar47/hdfs-core:0.1

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=deployer
ARG GNAME=hadoop

ENV INSTALL_DIR=/opt

ADD scripts/ /usr/bin/ 

RUN sudo apt-get update && \
    sudo chmod +x /usr/bin/bootstrap.sh && \
    sudo rm -rf /tmp/conf && \
    sudo rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/usr/bin/bootstrap.sh && /bin/bash"]
