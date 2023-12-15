echo -e "\e[33m Configuring NodeJS Repos \e[0m"
dnf module disable nodejs -y &>>/tmp/roboshop.log
dnf module enable nodejs:18 -y &>>/tmp/roboshop.log

echo -e "\e[33m Installing NodeJS \e[0m"
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33m Add Application User \e[0m"
useradd roboshop

echo -e "\e[33m Create Application Directory \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[33m Downloading Application Content \e[0m"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[33m Extracting Application Content \e[0m"
unzip /tmp/cart.zip &>>/tmp/roboshop.log

echo -e "\e[33m Install NodeJS Dependencies \e[0m"
cd /app
npm install &>>/tmp/roboshop.log

echo -e "\e[33m Setup SystemD Service \e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[33m Start Cart Service \e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
