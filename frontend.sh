log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> Install Nginx <<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
yum install nginx -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> Copy the roboshop configuration <<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cp nginx-roboshop.conf \etc/nginx/default.d/roboshop.conf &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> Cleaning the old content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
rm -rf /usr/share/nginx/html/* &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> Download application content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> Extract application content <<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
cd /usr/share/nginx/html &>>${log}
unzip /tmp/frontend.zip &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> Start the service <<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
