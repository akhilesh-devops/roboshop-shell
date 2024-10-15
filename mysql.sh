
log=/tmp/roboshop.log

source common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>> Create mysql repo File <<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>> Disable mysql module <<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum module disable mysql -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>> Install mysql  <<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install mysql-community-server -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>> Restart the service <<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable mysqld &>>${log}
systemctl start mysqld &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>> Set Password <<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>${log}
func_exit_status