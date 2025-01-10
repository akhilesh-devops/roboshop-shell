log=/tmp/roboshop.log

echo -e "\e[36m >>>>>>>> copy the mongo repo <<<<<<<<<<<\e[0m" | tee -a ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m >>>>>>> Install mongodb client <<<<<<<<<<<\e[0m" | tee -a ${log}
dnf install mongodb-org -y &>>${log}

echo -e "\e[36m >>>>>>>> Update Listen address <<<<<<<<<<<<\e[0m" | tee -a ${log}
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}

echo -e "\e[36m >>>>>>>>> Restart the service <<<<<<<<<<<<\e[0m" | tee -a ${log}
systemctl enable mongod &>>${log}
systemctl restart mongod &>>${log}
