
echo -e "\e[33m Installing Maven \e[0m"
dnf install maven -y  &>>/tmp/roboshop.log

echo -e "\e[33m Adding Application User \e[0m"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "\e[33m Creating Application Directory \e[0m"
rm -rf  &>>/tmp/roboshop.log
mkdir /app  &>>/tmp/roboshop.log

echo -e "\e[33m Downloading Shipping Content \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip  &>>/tmp/roboshop.log


echo -e "\e[33m Extracting Application Content \e[0m"
cd /app
unzip /tmp/shipping.zip  &>>/tmp/roboshop.log

echo -e "\e[33m Downloading maven Dependencies  \e[0m"
cd /app
mvn clean package  &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar  &>>/tmp/roboshop.log

echo -e "\e[33m Updating Service file \e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service  &>>/tmp/roboshop.log

echo -e "\e[33m Installing Mysql Client \e[0m"
dnf install mysql -y  &>>/tmp/roboshop.log

echo -e "\e[33m Loading Schema \e[0m"
mysql -h mysql-dev.vagdevi.store -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>/tmp/roboshop.log

echo -e "\e[33m Starting Shipping Service \e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable shipping  &>>/tmp/roboshop.log
systemctl restart shipping  &>>/tmp/roboshop.log
