source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo "Input Password is Missing"
  exit 1
fi

echo -e "\e[36m >>>>>>>>>>> create mysql repo <<<<<<<<<<<\e[0m" | tee -a ${log}
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>> Disable mysql <<<<<<<<<<<<<< \e[0m"
dnf module disable mysql -y &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>> Install mysql community server <<<<<<<<<<<\e[0m"
dnf install mysql-community-server -y &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>>> Enable mysql <<<<<<<<<<<\e[0m"
systemctl enable mysqld &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>>> Restart the mysql <<<<<<<<<<<<\e[0m"
systemctl restart mysqld &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>>> Set password <<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log}
func_exit_status
