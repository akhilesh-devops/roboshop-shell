cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
yum install mongodb-org -y &>>${log}
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}
systemctl restart mongod &>>${log}
systemctl enable mongod &>>${log}