component=catalogue
colour="\e[35m"
nocolour="\e[0m"

echo -e "${colour} Enable NodeJs 18v ${nocolour}"
dnf module disable nodejs -y  &>>/tmp/roboshop.log
dnf module enable nodejs:18 -y  &>>/tmp/roboshop.log

echo -e "${colour} Installing NodeJS ${nocolour}"
dnf install nodejs -y  &>>/tmp/roboshop.log

echo -e "${colour} Add User ${nocolour}"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "${colour} Creating Application Directory ${nocolour}"
rm -rf  &>>/tmp/roboshop.log
mkdir /app  &>>/tmp/roboshop.log

echo -e "${colour} Downloading Application Content ${nocolour}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip  &>>/tmp/roboshop.log
cd /app

echo -e "${colour} Extracting Application Content ${nocolour}"
unzip -o /tmp/$component.zip  &>>/tmp/roboshop.log
cd /app

echo -e "${colour} Installing Dependencies ${nocolour}"
npm install  &>>/tmp/roboshop.log

echo -e "${colour} Setup Service File ${nocolour}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>/tmp/roboshop.log

echo -e "${colour} Starting $component Service ${nocolour}"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable $component  &>>/tmp/roboshop.log
systemctl restart $component  &>>/tmp/roboshop.log

echo -e "${colour} Copy Mongodb Repo ${nocolour}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>/tmp/roboshop.log

echo -e "${colour} Installing Mongodb ${nocolour}"
dnf install mongodb-org-shell -y  &>>/tmp/roboshop.log

echo -e "${colour} Loading Schema ${nocolour}"
mongo --host mongodb-dev.vagdevi.store </app/schema/$component.js  &>>/tmp/roboshop.log