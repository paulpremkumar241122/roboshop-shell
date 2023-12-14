echo -e "\e[33m Enable NodeJS 18v \e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[33m Installing NodeJS \e[0m"
dnf install nodejs -y

echo -e "\e[33m Adding Application User \e[0m"
useradd roboshop

echo -e "\e[33m Creating Application Directory \e[0m"

rm -rf
mkdir /app

echo -e "\e[33m Downloading Application Content \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[33m Extracting Application Content \e[0m"
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[33m Installing Application Dependencies \e[0m"
cd /app
npm install

echo -e "\e[33m Setup SystemD Service \e[0m"
cp /home/centos/roboshop-shell/catalogue.service  /etc/systemd/system/catalogue.service

echo -e "\e[33m Starting Catalogue Service \e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[33m Copying Mongodb Repo \e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m Installing Mongodb \e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[33m Loading Schema \e[0m"
mongo --host mongodb-dev.vagdevi.store </app/schema/catalogue.js
