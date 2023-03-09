FROM almalinux:8.7

RUN dnf install -y gcc openssl-devel bzip2-devel libffi-devel python3-devel openldap-devel
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

RUN yum clean all
COPY mongodb-org-4.0.repo  /etc/yum.repos.d/mongodb-org-4.0.repo
 
RUN yum install -y mongodb-org mariadb-devel 
RUN python3.7 -m venv venv_chakshu && \
source venv_chakshu/bin/activate

RUN pip3.7 install --upgrade pip && \
pip install --upgrade setuptools

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD [ "/entrypoint.sh" ]
