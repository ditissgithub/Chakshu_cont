FROM almalinux:8.7

RUN dnf install -y gcc openssl-devel bzip2-devel libffi-devel python3-devel openldap-devel
WORKDIR /opt
RUN yum install -y wget cmake
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

RUN yum clean all
RUN cat > /etc/yum.repos.d/mongodb-org-4.0.repo <<EOF \
[mongodb-org-4.0] \
name=MongoDB Repository \
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/ \
gpgcheck=1 \
enabled=1 \
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc \
EOF

RUN yum install -y mongodb-org mariadb-devel && sed -i -e 's|bindIp: 127.0.0.1  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.|bindIp: 0.0.0.0  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.|g' /etc/mongod.conf && \
sed -i -e 's|#security|security|g' /etc/mongod.conf  && \
sed -i "/security/a   \ \ authorization: 'enabled'" /etc/mongod.conf && \
sed -i -e 's|ExecStartPre=/usr/bin/chown mongod:mongod /var/run/mongodb|ExecStartPre=/usr/bin/chown -R root:root /var/run/mongodb|g' /usr/lib/systemd/system/mongod.service && \
sed -i -e 's|User=mongod|User=root|g' /usr/lib/systemd/system/mongod.service && \
sed -i -e 's|Group=mongod|Group=root|g' /usr/lib/systemd/system/mongod.service && \
systemctl daemon-reload && \
systemctl restart mongod
RUN pip3.7 install --upgrade pip && \
pip install --upgrade setuptools

