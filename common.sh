log=/tmp/roboshop.log

func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e  "\e[31m FAILURE \e[0m"
  fi
}


func_apppreq() {

  echo -e "\e[36m>>>>>>>>>>>>>>>> Copy ${component} service file <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>>> Adding the user <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  id roboshop &>>${log}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log}
  fi
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>>> Remove the app directory <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  rm -rf /app &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>>> create application directory <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  mkdir /app &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>>> Download the application content <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>>> Extract the application content <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cd /app &>>${log}
  unzip /tmp/${component}.zip &>>${log}
  cd /app &>>${log}
  func_exit_status
}


func_systemd() {

  echo -e "\e[36m>>>>>>>>>>>>>>>> Restart the ${component} service <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
  func_exit_status
}

func_schema_setup() {
  if [ "schema_type" == "mongodb" ]; then
    echo -e "\e[36m>>>>>>>>>>>>>>>> Download mongodb client <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    yum install mongodb-org-shell -y &>>${log}
    func_exit_status

    echo -e "\e[36m>>>>>>>>>>>>>>>> Load schema <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    mongo --host mongodb.vinithaws.online </app/schema/${component}.js &>>${log}
    func_exit_status
  fi

  if [ "schema_type" == "mysql" ]; then
    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install mysql client <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    dnf install mysql -y &>>${log}
    func_exit_status

    echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Load Schema <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    mysql -h mysql.vinithaws.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>${log}
    func_exit_status
  fi
}




func_nodejs() {

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>  Create MongoDB Repo  <<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  func_exit_status
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Disable Nodejs module <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum module disable nodejs -y &>>${log}
  func_exit_status
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Enable Nodejs module <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum module enable nodejs:18 -y &>>${log}
  func_exit_status
  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  yum install nodejs -y &>>${log}
  func_exit_status

  
  echo -e "\e[36m>>>>>>>>>>>>>>>> Download Nodejs dependencies <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  npm install &>>${log}
  func_exit_status
  
  func_schema_setup
  
  func_systemd
}

func_java () {
  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install Maven  <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  dnf install maven -y &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install java dependencies <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  mvn clean package &>>${log}
  mv target/shipping-1.0.jar shipping.jar &>>${log}
  func_exit_status

  func_schema_setup

  func_systemd
}

func_python () {
  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>>> Install Python Packages <<<<<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  dnf install python36 gcc python3-devel -y &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>>>>>>>> Install Python Dependencies <<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_status

  func_systemd
}