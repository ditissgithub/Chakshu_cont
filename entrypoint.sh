#!/bin/bash

sed -i -e 's|bindIp: 127.0.0.1  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.|bindIp: 0.0.0.0  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.|g' /etc/mongod.conf 
sed -i -e 's|#security|security|g' /etc/mongod.conf  
sed -i "/security/a   \ \ authorization: 'enabled'" /etc/mongod.conf 
sed -i -e 's|ExecStartPre=/usr/bin/chown mongod:mongod /var/run/mongodb|ExecStartPre=/usr/bin/chown -R root:root /var/run/mongodb|g' /usr/lib/systemd/system/mongod.service 
sed -i -e 's|User=mongod|User=root|g' /usr/lib/systemd/system/mongod.service 
sed -i -e 's|Group=mongod|Group=root|g' /usr/lib/systemd/system/mongod.service

systemctl daemon-reload 
systemctl restart mongod


# creating directory for copy all the logs related to chakshu
mkdir -p /var/log/chakshu

# install the chakshu repo on / directory of host machine because we mount the repo from / directory inside contianer
sed -i -e 's|mysqlclient==1.3.6|mysqlclient==2.1.1|g' /home/apps/chakshu/requirements.txt

pip install -r /home/apps/chakshu/requirements.txt

# Start the MongoDB shell as a root user on the admin database
mongo admin --eval "db.auth('root', 'root');"

# Create the admin database
mongo admin --eval "db.getSiblingDB('admin').createUser({user: 'admin', pwd: 'admin@@123', roles: [{ role: 'root', db: 'admin' }]})"

cat > file1.js << EOF
db.createUser({
          user: 'root',
          pwd: 'root',
          roles: ['root']
    });

EOF

mongo mongodb://admin:admin@@123@localhost/admin  file1.js

mongo admin --eval "db.auth('root', 'root'); db.getSiblingDB('chakshudb').createUser({user: 'chakshu', pwd: 'chakshumanager', roles: [{ role: 'readWrite', db: 'chakshudb' }]})"


