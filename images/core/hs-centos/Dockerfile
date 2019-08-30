FROM centos:latest

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG UNAME=admin
ARG GNAME=sysadmin

RUN yum update \
    && yum install -y sudo \
    && yum install -y curl \
    && yum -y install openssh-server openssh-clients \
    && yum clean all \
    && groupadd ${GNAME} \
    && useradd -m -g ${GNAME} -s /bin/bash ${UNAME} \
    && echo "%${GNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/' /etc/ssh/ssh_config

USER ${UNAME}

RUN ssh-keygen -q -t rsa -N "" -C "" -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c" ]
CMD ["/bin/bash"]