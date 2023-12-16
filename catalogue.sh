component=catalogue

echo -e "\e[33m Enable NodeJs 18v \e[0m"
dnf module disable nodejs -y  &>>/tmp/roboshop.log
dnf module enable nodejs:18 -y  &>>/tmp/roboshop.log

echo -e "\e[33m Installing NodeJS \e[0m"
dnf install nodejs -y  &>>/tmp/roboshop.log

echo -e "\e[33m Add User \e[0m"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "\e[33m Creating Application Directory \e[0m"
rm -rf  &>>/tmp/roboshop.log
mkdir /app  &>>/tmp/roboshop.log

echo -e "\e[33m Downloading Application Content \e[0m"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[33m Extracting Application Content \e[0m"
unzip -o /tmp/$component.zip  &>>/tmp/roboshop.log
cd /app

echo -e "\e[33m Installing Dependencies \e[0m"
npm install  &>>/tmp/roboshop.log

echo -e "\e[33m Setup Service File \e[0m"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service  &>>/tmp/roboshop.log

echo -e "\e[33m Starting $component Service \e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable $component  &>>/tmp/roboshop.log
systemctl restart $component  &>>/tmp/roboshop.log

echo -e "\e[33m Copy Mongodb Repo \e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>/tmp/roboshop.log

echo -e "\e[33m Installing Mongodb \e[0m"
dnf install mongodb-org-shell -y  &>>/tmp/roboshop.log

echo -e "\e[33m Loading Schema \e[0m"
mongo --host mongodb-dev.vagdevi.store </app/schema/$component.js  &>>/tmp/roboshop.log