log=/tmp/roboshop.log

func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
  fi
}


func_apppreq() {

  echo -e "\e[36m >>>>>>>>>>>> create ${component} service file <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>>>> create application user <<<<<<<<<<<<<\e[0m" | tee -a ${log}
  id roboshop &>>${log}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log}
  fi
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>>> cleanup the app directory <<<<<<<<<<<\e[0m" | tee -a ${log}
  rm -rf /app &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>> create app directory <<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  mkdir /app &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>> Download the app content <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>> Extract the app content <<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cd /app &>>${log}
  unzip /tmp/${component}.zip &>>${log}
  func_exit_status
}

func_nodejs() {

  echo -e "\e[36m >>>>>>>>>>>> create mongo repo <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>> Disable the nodejs module <<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  dnf module disable nodejs -y &>>${log}

  echo -e "\e[36m >>>>>>>>>>> Enable the nodejs module <<<<<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  dnf module enable nodejs:18 -y &>>${log}

  echo -e "\e[36m >>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  dnf install nodejs -y &>>${log}
  func_exit_status

  func_apppreq

  echo -e "\e[36m >>>>>>>>>>> Download nodejs dependencies <<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  npm install &>>${log}
  func_exit_status

  func_schema

  func_systemd
}

func_systemd () {

  echo -e "\e[36m >>>>>>>>>>>> Restart the ${component} service <<<<<<<<<<<<<<<\e[0m" | tee -a ${log}
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl start ${component} &>>${log}
  func_exit_status
}

func_schema_setup() {

  if [ "${schema_type}" == "mongodb" ]; then
    echo -e "\e[36m >>>>>>>>>>> Install Mongodb client <<<<<<<<<<<<<<\e[0m" | tee -a ${log}
    dnf install mongodb-org-shell -y &>>${log}
    func_exit_status

    echo -e "\e[36m >>>>>>>>>>>>> Load the schema <<<<<<<<<<<<\e[0m" | tee -a ${log}
    mongo --host mongodb-dev.vinithaws.online </app/schema/${component}.js &>>${log}
    func_exit_status
  fi

  if [ "${schema_type}" == "mysql" ]; then
    echo -e "\e[36m>>>>>>>>>>>>  Install MySQL Client   <<<<<<<<<<<<\e[0m"
    yum install mysql -y &>>${log}
    func_exit_status

    echo -e "\e[36m>>>>>>>>>>>>  Load Schema   <<<<<<<<<<<<\e[0m"
    mysql -h mysql.vinithaws.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
    func_exit_status
  fi
}