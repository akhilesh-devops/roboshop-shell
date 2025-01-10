log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Install Nginx <<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
yum install nginx -y &>>${log}

echo -e "\e[36m>>>>>>>>>> copy roboshop config <<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}

echo -e "\e[36m>>>>>>>>>> Remove app content <<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
rm -rf /usr/share/nginx/html/* &>>${log}

echo -e "\e[36m>>>>>>>>>> Download the application content <<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}

echo -e "\e[36m>>>>>>>>> change the directory <<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cd /usr/share/nginx/html &>>${log}

echo -e "\e[36m>>>>>>>> unzip the app content <<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
unzip /tmp/frontend.zip &>>${log}

echo -e "\e[36m>>>>>>> Restart the service <<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}


