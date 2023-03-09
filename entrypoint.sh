#!/bin/bash

systemctl daemon-reload 
systemctl restart mongod


# creating directory for copy all the logs related to chakshu
mkdir -p /var/log/chakshu

# install the chakshu repo on / directory of host machine because we mount the repo from / directory inside contianer
sed -i -e 's|mysqlclient==1.3.6|mysqlclient==2.1.1|g' /home/apps/chakshu/requirements.txt

pip install -r /home/apps/chakshu/requirements.txt

###create a root user on mongodb####
# Set variables for the MongoDB server connection
MONGO_HOST=localhost
MONGO_PORT=27017
MONGO_DB=admin

# Connect to the MongoDB server and create the root user
mongo --host $MONGO_HOST --port $MONGO_PORT <<EOF
use $MONGO_DB
db.createUser({
  user: "root",
  pwd: "root",
  roles: [ { role: "root", db: "admin" } ]
})
EOF

# Print the root user credentials
echo "Root user created:"
echo "Username: root"
echo "Password: root"


# Start the MongoDB shell as a root user on the admin database
# Create the database as 'admin'
mongo admin --eval "db.auth('root', 'root'); db.getSiblingDB('admin').createUser({user: 'admin', pwd: 'admin123', roles: [{ role: 'root', db: 'admin' }]})"

#Create new database as 'chakshudb'


mongo admin --eval "db.auth('root', 'root'); db.getSiblingDB('chakshudb').createUser({user: 'chakshu', pwd: 'chakshumanager', roles: [{ role: 'readWrite', db: 'chakshudb' }]})"


