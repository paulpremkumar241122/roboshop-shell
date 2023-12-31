colour="\e[33m"
nocolour="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

user_id=$(id -u)
  if [ $user_id -ne 0 ]; then
    echo Script should be run with sudo only
    exit 1
  fi

stat_check() {
  if [ $1 -eq 0 ]; then
    echo SUCCESS
  else
    echo FAILURE
    exit 1
  fi
}

app_pre_setup() {
  echo -e "${colour} Add User ${nocolour}"
  id roboshop &>>${log_file}
  if [ $? -eq 1 ]; then
    useradd roboshop &>>${log_file}
  fi

  stat_check $?

  echo -e "${colour} Creating Application Directory ${nocolour}"
  rm -rf ${app_path}  &>>${log_file}
  mkdir ${app_path}

  stat_check $?

  echo -e "${colour} Downloading ${component} Content ${nocolour}"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log_file}

  stat_check $?

  echo -e "${colour} Extracting Application Content ${nocolour}"
  cd ${app_path}
  unzip -o /tmp/$component.zip  &>>${log_file}

  stat_check $?
}

systemd_setup() {
    echo -e "${colour} Setup Service File ${nocolour}"
    cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>${log_file}
    sed -i -e "s/roboshop_app_password/$roboshop_app_password/" /etc/systemd/system/$component.service

    stat_check $?

    echo -e "${colour} Starting $component Service ${nocolour}"
    systemctl daemon-reload  &>>${log_file}
    systemctl enable $component  &>>${log_file}
    systemctl restart $component  &>>${log_file}

    stat_check $?
}

nodejs() {
  echo -e "${colour} Enable NodeJs 18v ${nocolour}"
  dnf module disable nodejs -y  &>>${log_file}
  dnf module enable nodejs:18 -y  &>>${log_file}

  stat_check $?

  echo -e "${colour} Installing NodeJS ${nocolour}"
  dnf install nodejs -y  &>>${log_file}

  stat_check $?

  app_pre_setup

  echo -e "${colour} Installing NodeJS Dependencies ${nocolour}"
  npm install  &>>${log_file}

  systemd_setup

}

mongo_schema_setup() {
  echo -e "${colour} Copy Mongodb Repo ${nocolour}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>${log_file}

  stat_check $?

  echo -e "${colour} Installing Mongodb ${nocolour}"
  dnf install mongodb-org-shell -y  &>>${log_file}

  stat_check $?

  echo -e "${colour} Loading Schema ${nocolour}"
  mongo --host mongodb-dev.vagdevi.store <${app_path}/schema/$component.js  &>>${log_file}

  stat_check $?
}

mysql_schema_setup() {
    echo -e "${colour} Installing Mysql Client ${nocolour}"
    dnf install mysql -y  &>>${log_file}

    stat_check $?

    echo -e "${colour} Loading Schema ${nocolour}"
    mysql -h mysql-dev.vagdevi.store -uroot -p${mysql_root_password} < ${app_path}/schema/${component}.sql  &>>${log_file}

    stat_check $?
}


maven() {
  echo -e "${colour} Installing Maven ${nocolour}"
  dnf install maven -y  &>>${log_file}

  stat_check $?

  app_pre_setup

  echo -e "${colour} Downloading maven Dependencies  ${nocolour}"
  cd ${app_path}
  mvn clean package  &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar  &>>${log_file}
  stat_check $?

  mysql_schema_setup

  systemd_setup

}


python() {

  echo -e "${colour} Installing Python 3.6v ${nocolour}"
  dnf install python36 gcc python3-devel -y  &>>${log_file}

  stat_check $?


  app_pre_setup

  echo -e "${colour} Installing Application Dependencies ${nocolour}"
  cd ${app_path}
  pip3.6 install -r requirements.txt  &>>${log_file}

  stat_check $?


  systemd_setup
}
