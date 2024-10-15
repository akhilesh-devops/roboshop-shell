log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>>>>>> Copy user service file <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cp user.service /etc/systemd/system/user.service &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Copy the mongo repo file <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Disable Nodejs module <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum module disable nodejs -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Enable Nodejs module <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum module enable nodejs:18 -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum install nodejs -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Adding the user <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
useradd roboshop &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Remove the app directory <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
rm -rf /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> create application directory <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
mkdir /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Download the application content <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Extract the application content <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cd /app &>>${log}
unzip /tmp/user.zip &>>${log}
cd /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Download Nodejs dependencies <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
npm install &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Download mongodb client <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Load schema <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
mongo --host mongodb.vinithaws.online </app/schema/user.js &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Restart the User service <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
systemctl daemon-reload &>>${log}
systemctl enable user &>>${log}
systemctl restart user &>>${log}