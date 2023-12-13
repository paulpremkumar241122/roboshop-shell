
echo -e "\e[33m Installing Maven \e[0m"
dnf install maven -y

echo -e "\e[33m Adding Application User \e[0m"
useradd roboshop

echo -e "\e[33m Creating Application Directory \e[0m"
rm -rf
mkdir /app

echo -e "\e[33m Downloading Shipping Content \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip


echo -e "\e[33m Extracting Application Content \e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[33m Downloading maven Dependencies  \e[0m"
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[33m Updating Service file \e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[33m Installing Mysql Client \e[0m"
dnf install mysql -y

echo -e "\e[33m Loading Schema \e[0m"
mysql -h mysql-dev.vagdevi.store -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[33m Starting Shipping Service \e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping
