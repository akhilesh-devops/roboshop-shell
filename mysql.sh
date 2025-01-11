source common.sh

echo -e "\e[36m >>>>>>>>>>> create mysql repo <<<<<<<<<<<\e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo
func_exit_status

echo -e "\e[36m >>>>>>>>>> Disable mysql <<<<<<<<<<<<<< \e[0m"
dnf module disable mysql -y
func_exit_status

echo -e "\e[36m >>>>>>>>>> Install mysql community server <<<<<<<<<<<\e[0m"
dnf install mysql-community-server -y
func_exit_status

echo -e "\e[36m >>>>>>>>>>> Enable mysql <<<<<<<<<<<\e[0m"
systemctl enable mysqld
func_exit_status

echo -e "\e[36m >>>>>>>>>>> Restart the mysql <<<<<<<<<<<<\e[0m"
systemctl restart mysqld
func_exit_status

echo -e "\e[36m >>>>>>>>>>> Set password <<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
func_exit_status
