
echo -e "\e[33m Disable MySQL Default Version \e[0m"
dnf module disable mysql -y  &>>/tmp/roboshop.log

echo -e "\e[33m Copying MySQL Repo File \e[0m"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[33m Install MySQL Community Server \e[0m"
dnf install mysql-community-server -y  &>>/tmp/roboshop.log

echo -e "\e[33m Starting MySQL Service \e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[33m Setup MySQL Password \e[0m"
mysql_secure_installation --set-root-pass RoboShop@1  &>>/tmp/roboshop.log

# mysql -uroot -pRoboShop@1