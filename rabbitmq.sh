source common.sh

echo -e "\e[36m >>>>>>>>>> Install Erlang repos <<<<<<<<<<<<<<\e[0m" | tee -a ${log}
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>>>>> Download the rabbitmq repositories <<<<<<<<<<<<<\e[0m" | tee -a ${log}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>>> Install rabbitmq-server <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
dnf install rabbitmq-server -y &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>> Enable and restart the service <<<<<<<<<<<<\e[0m" | tee -a ${log}
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
func_exit_status

echo -e "\e[36m >>>>>>>>>>> Adding user <<<<<<<<<<<\e[0m" | tee -a ${log}
rabbitmqctl add_user roboshop roboshop123 &>>${log}
func_exit_status

echo -e "\e[36m >>>>>>>>>>> set permissions for user <<<<<<<<<<<<\e[0m" | tee -a ${log}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log}
func_exit_status