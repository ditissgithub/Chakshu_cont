#!/bin/bash

yum clean all
cat > /etc/yum.repos.d/mongodb-org-4.0.repo <<EOF
[mongodb-org-4.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc

EOF

yum install -y mongodb-org mariadb-devel

sed -i -e 's|bindIp: 127.0.0.1  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.|bindIp: 0.0.0.0  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.|g' /etc/mongod.conf


sed -i -e 's|#security|security|g' /etc/mongod.conf

sed -i "/security/a   \ \ authorization: 'enabled'" /etc/mongod.conf

sed -i -e 's|ExecStartPre=/usr/bin/chown mongod:mongod /var/run/mongodb|ExecStartPre=/usr/bin/chown -R root:root /var/run/mongodb|g' /usr/lib/systemd/system/mongod.service

sed -i -e 's|User=mongod|User=root|g' /usr/lib/systemd/system/mongod.service
sed -i -e 's|Group=mongod|Group=root|g' /usr/lib/systemd/system/mongod.service

systemctl daemon-reload
systemctl restart mongod



# Start the MongoDB shell as a root user on the admin database
mongo admin --eval "db.auth('root', 'root');"

# Create the admin database
mongo admin --eval "db.getSiblingDB('admin').createUser({user: 'admin', pwd: 'password', roles: [{ role: 'root', db: 'admin' }]})"

cat > file1.js << EOF
db.createUser({
          user: 'root',
          pwd: 'root',
          roles: ['root']
    });

EOF





mongo mongodb://admin:password@localhost/admin  file1.js

mongo admin --eval "db.auth('root', 'root'); db.getSiblingDB('chakshudb').createUser({user: 'chakshu', pwd: 'chakshumanager', roles: [{ role: 'readWrite', db: 'chakshudb' }]})"


pip3.7 install --upgrade pip
pip install --upgrade setuptools
yum install -y  python3-devel mariadb-devel openldap-devel
#replace  mysqlclient-v.1.3.6 with v.2.1.1 from requirements.txt file
sed -i -e 's|mysqlclient==1.3.6|mysqlclient==2.1.1|g' /chakshu_conf/chakshu_backend-v2.5/requirements.txt

pip install -r /chakshu_conf/chakshu_backend-v2.5/requirements.txt
