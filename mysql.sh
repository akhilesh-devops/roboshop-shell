mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo INput Password Missing
  exit 1
fi

source common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>> Create mysql repo File <<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>> Disable mysql module <<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum module disable mysql -y
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>> Install mysql  <<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
yum install mysql-community-server -y
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>> Restart the service <<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>> Set Password <<<<<<<<<<<<<<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_password}
func_exit_status