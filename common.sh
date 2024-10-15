log=/tmp/roboshop.log

func_nodejs() {
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Copy ${component} service file <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Copy the mongo repo file <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Disable Nodejs module <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum module disable nodejs -y &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Enable Nodejs module <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum module enable nodejs:18 -y &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum install nodejs -y &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Adding the user <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  useradd roboshop &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Remove the app directory <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  rm -rf /app &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> create application directory <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  mkdir /app &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Download the application content <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Extract the application content <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cd /app &>>${log}
  unzip /tmp/${component}.zip &>>${log}
  cd /app &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Download Nodejs dependencies <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  npm install &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Download mongodb client <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum install mongodb-org-shell -y &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Load schema <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  mongo --host mongodb.vinithaws.online </app/schema/${component}.js &>>${log}
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Restart the ${component} service <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}