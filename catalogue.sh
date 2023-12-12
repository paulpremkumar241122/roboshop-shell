echo -e "\e[33m Configuring NodeJS Repos \e[0m"
dnf module disable nodejs -y &>>/tmp/roboshop.log
dnf module enable nodejs:18 -y &>>/tmp/roboshop.log

echo -e "\e[33m Installing NodeJS \e[0m"
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33m Add Application User \e[0m"
useradd roboshop

echo -e "\e[33m Create Application Directory \e[0m"
rm-rf /app
mkdir /app

echo -e "\e[33m Downloading Application Content \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[33m Extracting Application Content \e[0m"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[33m Install NodeJS Dependencies \e[0m"
cd /app
npm install &>>/tmp/roboshop.log

echo -e "\e[33m Setup SystemD Service \e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[33m Start Catalogue Service \e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[33m Copy MongoDB Repo file \e[0m"
cp mongodb.repo /ete/yum.repos.d/mongo.repo

echo -e "\e[33m Install MongoDB Client \e[0m"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[33m Load Schema \e[0m"
mongo --host mongodb-dev.vagdevi.store </app/schema/catalogue.js