rabbitmq_user_password=$1
if [ -z "${rabbitmq_user_password}" ]; then
  echo Input Password is Missing
  exit 1
fi


curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log}
dnf install rabbitmq-server -y &>>${log}
systemctl enable rabbitmq-server &>>${log}
systemctl start rabbitmq-server &>>${log}
rabbitmqctl add_user roboshop ${rabbitmq_user_password} &>>${log}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log}