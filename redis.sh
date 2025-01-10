log=/tmp/roboshop.log

echo -e "\e[36m >>>>>>>>>> Download the remi repos <<<<<<<<<<\e[0m" | tee -a ${log}
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log}

echo -e "\e[36m >>>>>>>>>>>>> Enable redis module <<<<<<<<<<<<\e[0m" | tee -a ${log}
dnf module enable redis:remi-6.2 -y &>>${log}

echo -e "\e[36m >>>>>>>>>>>> Install redis <<<<<<<<<<<<<\e[0m" | tee -a ${log}
dnf install redis -y &>>${log}

echo -e "\e[36m >>>>>>>>>>>> Update Listen address <<<<<<<<<<<<\e[0m" | tee -a ${log}
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log}

echo -e "\e[36m >>>>>>>>>>>> Restart the redis service <<<<<<<<<<<<\e[0m" | tee -a ${log}
systemctl enable redis &>>${log}
systemctl restart redis &>>${log}