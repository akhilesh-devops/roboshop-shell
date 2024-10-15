rabbitmq_user_password=$1
if [ -z "${rabbitmq_user_password}" ]; then
  echo Input Password is Missing
  exit 1
fi


log=/tmp/roboshop.log

source common.sh

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Create the Rabbitmq repos <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Download the Rabbitmq repos <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install rabbitmq server <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
dnf install rabbitmq-server -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Restart the service <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
systemctl enable rabbitmq-server &>>${log}
systemctl start rabbitmq-server &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Adding user and password <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
rabbitmqctl add_user roboshop ${rabbitmq_user_password} &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Setting permissions <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log}
func_exit_status