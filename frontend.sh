source common.sh

echo -e "\e[32m >>>>>>>>>>>>>>>>> Copy Nginx configuration <<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status

echo -e "\e[32m >>>>>>>>>>>>>>>>> Install Nginx <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
dnf install nginx -y &>>${log}
func_exit_status

echo -e "\e[32m >>>>>>>>>>>>>>>>> Remove the app content <<<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status

echo -e "\e[32m >>>>>>>>>>>>>>>> Download app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> ${log}
func_exit_status

echo -e "\e[32m >>>>>>>>>>>>>>>> Extract the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cd /usr/share/nginx/html &>>${log}
unzip /tmp/frontend.zip &>>${log}
func_exit_status

echo -e "\e[32m >>>>>>>>>>>>>>> Restart the Nginx service <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl restart nginx &>>${log}
systemctl enable nginx &>>${log}
func_exit_status

