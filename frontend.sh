log = /tmp/roboshop.log

echo -e "\e[32m >>>>>>>>>>>>>>>>> Copy Nginx configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}

echo -e "\e[32m >>>>>>>>>>>>>>>>> Install Nginx <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
dnf install nginx -y &>>${log}

echo -e "\e[32m >>>>>>>>>>>>>>>>> Remove the app content <<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
rm -rf /usr/share/nginx/html/* &>>${log}

echo -e "\e[32m >>>>>>>>>>>>>>>> Download and extract the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> ${log}
cd /usr/share/nginx/html &>>${log}
unzip /tmp/frontend.zip &>>${log}

echo -e "\e[32m >>>>>>>>>>>>>>> Restart the Nginx service <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl restart nginx &>>${log}
systemctl enable nginx &>>${log}

