log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>>> Copy the Catalogue Service File <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Copy the mongo repo File <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Disable nodejs module <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum module disable nodejs -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Enable the nodejs module <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum module enable nodejs:18 -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum install nodejs -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Adding the Functional user <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
useradd roboshop &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Cleanup application content <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
rm -rf /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Create the application directory <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
mkdir /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Download application content <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Extract the application content <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cd /app &>>${log}
unzip /tmp/catalogue.zip &>>${log}
cd /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Install Dependencies <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
npm install &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Install Mongo client <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Load Schema <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
mongo --host mongodb.vinithaws.online </app/schema/catalogue.js &>>${log}

echo -e "\e[36m>>>>>>>>>>>>> Restart Service <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
systemctl enable catalogue &>>${log}
systemctl restart catalogue &>>${log}

