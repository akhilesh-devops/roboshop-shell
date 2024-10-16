mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo Input Password is Missing
  exit 1
fi

cp mysql.repo /etc/yum.repos.d/mysql.repo &>>${log}
yum module disable mysql -y &>>${log}
yum install mysql-community-server -y &>>${log}
systemctl enable mysqld &>>${log}
systemctl start mysqld &>>${log}
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log}