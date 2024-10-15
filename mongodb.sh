log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>>>> Download the mongo repo file <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>> Install mongodb <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum install mongodb-org -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>> Update the config file <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>> Restart Service <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
systemctl restart mongod &>>${log}
systemctl enable mongod &>>${log}
