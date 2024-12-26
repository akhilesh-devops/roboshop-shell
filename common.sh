log=/tmp/roboshop.log

func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
  fi
}

func_apppreq() {
  echo -e "\e[36m >>>>>>>>>>>>> copy the ${component} service file <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>> Adding the user <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  id roboshop &>>${log}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log}
  fi
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>>> clean up app directory <<<<<<<<<<<<<<<<< \e[0m" | tee -a /tmp/roboshop.log
  rm -rf /app &>>${log}

  echo -e "\e[36m >>>>>>>>>>>>>>> Make the directory <<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  mkdir /app &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>>>>> Download the app content <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>>>> Extract the app content <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cd /app &>>${log}
  unzip /tmp/${component}.zip &>>${log}
  func_exit_status

}

func_nodejs() {

  func_apppreq

  echo -e "\e[36m>>>>>>>>>>>>  Create MongoDB Repo  <<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>> Disable the Nodejs module <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf module disable nodejs -y &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>> Enable the Nodejs module <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf module enable nodejs:18 -y &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  dnf install nodejs -y &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>>>>>> download the dependencies <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  npm install &>>${log}
  func_exit_status

  func_schema_setup

  func_systemd
}

func_schema_setup() {
  if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[36m >>>>>>>>>>>>> Install Mongo repo <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    yum install mongodb-org-shell -y &>>${log}
    func_exit_status

    echo -e "\e[36m >>>>>>>>>>>>> Install Mongo repo <<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    mongo --host mongodb.vinithaws.online </app/schema/${component}.js &>>${log}
    func_exit_status
  fi

  if [ "${schema_type}" == "mysql" ]; then
    echo -e "\e[36m >>>>>>>>>>>>> Install MySQL Client <<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    yum install mysql -y &>>${log}
    func_exit_status

    echo -e "\e[36m>>>>>>>>>>>>  Load Schema   <<<<<<<<<<<<\e[0m"
    mysql -h mysql.vinithaws.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
    func_exit_status
  fi
}

func_systemd() {
  echo -e "\e[36m >>>>>>>>>>>>>>>>>> Enable and restart the ${component} service" | tee -a /tmp/roboshop.log
  systemctl daemon-reload &>>${log}
  systemctl enable catalogue &>>${log}
  systemctl start catalogue &>>${log}
  func_exit_status
}
