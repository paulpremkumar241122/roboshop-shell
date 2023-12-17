colour="\e[36m"
nocolour="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

app_pre_setup() {
  echo -e "${colour} Add User ${nocolour}"
  useradd roboshop &>>${log_file}

  echo -e "${colour} Creating Application Directory ${nocolour}"
  rm -rf ${app_path}  &>>${log_file}
  mkdir ${app_path}

  echo -e "${colour} Downloading ${component} Content ${nocolour}"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log_file}

  echo -e "${colour} Extracting Application Content ${nocolour}"
  cd ${app_path}
  unzip -o /tmp/$component.zip  &>>${log_file}
}

systemd_setup() {
    echo -e "${colour} Setup Service File ${nocolour}"
    cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>${log_file}

    echo -e "${colour} Starting $component Service ${nocolour}"
    systemctl daemon-reload  &>>${log_file}
    systemctl enable $component  &>>${log_file}
    systemctl restart $component  &>>${log_file}
}

nodejs() {
  echo -e "${colour} Enable NodeJs 18v ${nocolour}"
  dnf module disable nodejs -y  &>>${log_file}
  dnf module enable nodejs:18 -y  &>>${log_file}

  echo -e "${colour} Installing NodeJS ${nocolour}"
  dnf install nodejs -y  &>>${log_file}

  app_pre_setup

  echo -e "${colour} Installing NodeJS Dependencies ${nocolour}"
  npm install  &>>${log_file}

  systemd_setup

}

mongo_schema_setup() {
  echo -e "${colour} Copy Mongodb Repo ${nocolour}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>${log_file}

  echo -e "${colour} Installing Mongodb ${nocolour}"
  dnf install mongodb-org-shell -y  &>>${log_file}

  echo -e "${colour} Loading Schema ${nocolour}"
  mongo --host mongodb-dev.vagdevi.store <${app_path}/schema/$component.js  &>>${log_file}
}

mysql_schema_setup() {
    echo -e "${colour} Installing Mysql Client ${nocolour}"
    dnf install mysql -y  &>>${log_file}

    echo -e "${colour} Loading Schema ${nocolour}"
    mysql -h mysql-dev.vagdevi.store -uroot -pRoboShop@1 < ${app_path}/schema/${component}.sql  &>>${log_file}
}


maven() {
  echo -e "${colour} Installing Maven ${nocolour}"
  dnf install maven -y  &>>${log_file}

  app_pre_setup

  echo -e "${colour} Downloading maven Dependencies  ${nocolour}"
  cd ${app_path}
  mvn clean package  &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar  &>>${log_file}

  mysql_schema_setup

  systemd_setup

}


python() {

  echo -e "${colour} Installing Python 3.6v ${nocolour}"
  dnf install python36 gcc python3-devel -y  &>>${log_file}

  app_pre_setup

  echo -e "${colour} Installing Application Dependencies ${nocolour}"
  cd ${app_path}
  pip3.6 install -r requirements.txt  &>>${log_file}

  systemd_setup
}
