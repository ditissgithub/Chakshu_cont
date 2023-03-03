#!/bin/bash

# install the chakshu repo on / directory of host machine because we mount the repo from / directory inside contianer
RUN sed -i -e 's|mysqlclient==1.3.6|mysqlclient==2.1.1|g' /chakshu_conf/chakshu_backend-v2.5/requirements.txt

pip install -r /chakshu_conf/chakshu_backend-v2.5/requirements.txt

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


