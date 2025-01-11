source common.sh

echo -e "\e[36m>>>>>>>>>>> Install Nginx <<<<<<<<<<<<\e[0m" | tee -a ${log}
yum install nginx -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>> copy roboshop config <<<<<<<<<<<\e[0m" | tee -a ${log}
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>> Remove app content <<<<<<<<<<<\e[0m" | tee -a ${log}
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>> Download the application content <<<<<<<<<<<<<\e[0m" | tee -a ${log}
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>> change the directory <<<<<<<<<<<<<\e[0m" | tee -a ${log}
cd /usr/share/nginx/html &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>> unzip the app content <<<<<<<<<<<<<\e[0m" | tee -a ${log}
unzip /tmp/frontend.zip &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>> Restart the service <<<<<<<<<<<\e[0m" | tee -a ${log}
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
func_exit_status


