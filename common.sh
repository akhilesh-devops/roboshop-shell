func_nodejs() {
  log=/tmp/roboshop.log
  
  echo -e "\e[36m >>>>>>>>>>>> create ${component} service file <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>>> create mongo repo <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>> Disable the nodejs module <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  dnf module disable nodejs -y &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>> Enable the nodejs module <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  dnf module enable nodejs:18 -y &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  dnf install nodejs -y &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>>>>>> Adding roboshop user <<<<<<<<<<<<<\e[0m" | tee -a ${log}
  useradd roboshop &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>>>>> cleanup the app directory <<<<<<<<<<<\e[0m" | tee -a ${log}
  rm -rf /app &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>>>> create app directory <<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  mkdir /app &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>>> Download the app content <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>>> unzip the app content <<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cd /app &>>${log}
  unzip /tmp/${component}.zip &>>${log}
  cd /app &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>> Download nodejs dependencies <<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  npm install &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>> Install Mongodb client <<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  dnf install mongodb-org-shell -y &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>>>> Load the schema <<<<<<<<<<<<\e[0m" | tee -a ${log}
  mongo --host mongodb-dev.vinithaws.online </app/schema/${component}.js &>>${log}
  
  echo -e "\e[36m >>>>>>>>>>>> Restart the ${component} service <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl start ${component} &>>${log}
}