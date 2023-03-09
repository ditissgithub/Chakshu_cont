FROM almalinux:8.7

RUN dnf install -y gcc openssl-devel bzip2-devel libffi-devel python3-devel openldap-devel openssh-server
WORKDIR /opt
RUN yum install -y wget cmake ansible-core
#RUN wget https://www.python.org/ftp/python/3.7.1/Python-3.7.1.tgz
RUN curl https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz -O
RUN tar xzf Python-3.7.0.tgz
RUN cd /opt/Python-3.7.0/
RUN bash /opt/Python-3.7.0/configure --enable-optimizations
RUN make altinstall
RUN rm Python-3.7.0.tgz

#RUN dnf  install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

#RUN dnf update -y

#RUN yum install -y virtualenv htop

RUN sed -i -e 's|#PermitRootLogin yes|PermitRootLogin yes|g' \
           -e 's|#Port 22|Port 5100|g' \
           -e 's|#UseDNS yes|UseDNS no|g' /etc/ssh/sshd_config && \
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "root:chakshu" | chpasswd

RUN yum clean all

COPY mongodb-org-4.0.repo /etc/yum.repos.d/mongodb-org-4.0.repo

RUN yum install -y mongodb-org mariadb-devel

RUN sed -i -e 's|bindIp: 127.0.0.1  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.|bindIp: 0.0.0.0  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.|g' \
           -e 's|#security|security|g' /etc/mongod.conf && \
    sed -i   "/security/a   \ \ authorization: 'enabled'" /etc/mongod.conf && \
    sed -i -e 's|ExecStartPre=/usr/bin/chown mongod:mongod /var/run/mongodb|ExecStartPre=/usr/bin/chown -R root:root /var/run/mongodb|g' \
           -e 's|User=mongod|User=root|g' \
           -e 's|Group=mongod|Group=root|g' /usr/lib/systemd/system/mongod.service



RUN python3.7 -m venv venv_chakshu
RUN source venv_chakshu/bin/activate
RUN pip3.7 install --upgrade pip && \
pip install --upgrade setuptools

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD [ "/entrypoint.sh" ]
