log=/tmp/roboshop.log

func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
  fi
}

func_nodejs() {
  echo -e "\e[36m >>>>>>>>>>>>> copy the ${component} service file <<<<<<<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>> Disable the Nodejs module <<<<<<<<<<<<<<<<<\e[0m"
  dnf module disable nodejs -y
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>> Enable the Nodejs module <<<<<<<<<<<<<<<<<\e[0m"
  dnf module enable nodejs:18 -y
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<<<<<\e[0m"
  dnf install nodejs -y
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>> Adding the user <<<<<<<<<<<<<<<<<<<\e[0m"
  useradd roboshop
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>>>> Make the directory <<<<<<<<<<<<<<<\e[0m"
  mkdir /app
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>>>>> Download the app content <<<<<<<<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>>>> Extract the app content <<<<<<<<<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/${component}.zip
  func_exit_status

  echo -e "\e[36m >>>>>>>>>>>>>>>>> download the dependencies <<<<<<<<<<<<<<\e[0m"
  npm install
  func_exit_status
}
