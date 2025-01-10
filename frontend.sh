log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>> Install Nginx <<<<<<<<<<<<\e[0m" 
yum install nginx -y &>>${log}

echo -e "\e[36m>>>>>>>>>> copy roboshop config <<<<<<<<<<<\e[0m" 
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}

echo -e "\e[36m>>>>>>>>>> Remove app content <<<<<<<<<<<\e[0m" 
rm -rf /usr/share/nginx/html/* &>>${log}

echo -e "\e[36m>>>>>>>>>> Download the application content <<<<<<<<<<<<<\e[0m" 
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}

echo -e "\e[36m>>>>>>>>> change the directory <<<<<<<<<<<<<\e[0m" 
cd /usr/share/nginx/html &>>${log}

echo -e "\e[36m>>>>>>>> unzip the app content <<<<<<<<<<<<<\e[0m" 
unzip /tmp/frontend.zip &>>${log}

echo -e "\e[36m>>>>>>> Restart the service <<<<<<<<<<<\e[0m" 
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}


