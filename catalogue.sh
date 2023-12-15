
echo -e "\e[33m Enable NodeJs 18v \e[0m"
dnf module disable nodejs -y  &>>/tmp/roboshop.log
dnf module enable nodejs:18 -y  &>>/tmp/roboshop.log

echo -e "\e[33m Installing NodeJS \e[0m"
dnf install nodejs -y  &>>/tmp/roboshop.log

echo -e "\e[33m Add User \e[0m"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "\e[33m Creating Application Directory \e[0m"
mkdir /app  &>>/tmp/roboshop.log

echo -e "\e[33m Downloading Application Content \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip  &>>/tmp/roboshop.log

echo -e "\e[33m Extracting Application Content \e[0m"
cd /app  &>>/tmp/roboshop.log
unzip /tmp/catalogue.zip  &>>/tmp/roboshop.log

echo -e "\e[33m Installing Dependencies \e[0m"
cd /app  &>>/tmp/roboshop.log
npm install  &>>/tmp/roboshop.log

echo -e "\e[33m Setup Service File \e[0m"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service  &>>/tmp/roboshop.log

echo -e "\e[33m Starting Catalogue Service \e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable catalogue  &>>/tmp/roboshop.log
systemctl restart catalogue  &>>/tmp/roboshop.log

echo -e "\e[33m Copy Mongodb Repo \e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>/tmp/roboshop.log

echo -e "\e[33m Installing Mongodb \e[0m"
dnf install mongodb-org-shell -y  &>>/tmp/roboshop.log

echo -e "\e[33m Loading Schema \e[0m"
mongo --host mongodb-dev.vagdevi.store </app/schema/catalogue.js  &>>/tmp/roboshop.log