source common.sh

echo -e "\e[36m >>>>>>>>>>>>> copy Mongo repo file <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>>>> Install Mongodb <<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
dnf install mongodb-org -y &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>>>> Update Listen address <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>>> Restart the mongodb service <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl enable mongod &>>${log}
systemctl restart mongod &>>${log}
func_exit_status