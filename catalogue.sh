component=catalogue
colour="\e[35m"
nocolour="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

echo -e "${colour} Enable NodeJs 18v ${nocolour}"
dnf module disable nodejs -y  &>>${log_file}
dnf module enable nodejs:18 -y  &>>${log_file}

echo -e "${colour} Installing NodeJS ${nocolour}"
dnf install nodejs -y  &>>${log_file}

echo -e "${colour} Add User ${nocolour}"
useradd roboshop  &>>${log_file}

echo -e "${colour} Creating Application Directory ${nocolour}"
rm -rf ${app_path}  &>>${log_file}
mkdir ${app_path}

echo -e "${colour} Downloading Application Content ${nocolour}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip  &>>${log_file}
cd ${app_path}

echo -e "${colour} Extracting Application Content ${nocolour}"
unzip -o /tmp/$component.zip  &>>${log_file}
cd ${app_path}

echo -e "${colour} Installing Dependencies ${nocolour}"
npm install  &>>${log_file}

echo -e "${colour} Setup Service File ${nocolour}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>${log_file}

echo -e "${colour} Starting $component Service ${nocolour}"
systemctl daemon-reload  &>>${log_file}
systemctl enable $component  &>>${log_file}
systemctl restart $component  &>>${log_file}

echo -e "${colour} Copy Mongodb Repo ${nocolour}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>${log_file}

echo -e "${colour} Installing Mongodb ${nocolour}"
dnf install mongodb-org-shell -y  &>>${log_file}

echo -e "${colour} Loading Schema ${nocolour}"
mongo --host mongodb-dev.vagdevi.store <${app_path}/schema/$component.js  &>>${log_file}