FROM debian:latest

LABEL "author"="Himanshu Shekhar <himanshu.shekhar.in@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

ARG UNAME=admin
ARG GNAME=sysadmin

RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo curl ssh \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd ${GNAME} \
    && useradd -m -g ${GNAME} -s /bin/bash ${UNAME} \
    && echo "%${GNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/' /etc/ssh/ssh_config

USER ${UNAME}

RUN ssh-keygen -q -t rsa -N "" -C "" -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

WORKDIR /home/${UNAME}

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/bin/bash"]