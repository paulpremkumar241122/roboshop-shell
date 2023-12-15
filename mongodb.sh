echo -e "\e[33m Copy MongoDB repo file \e[0m"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>/tmp/roboshop.log

echo -e "\e[33m Installing MongoDB Server \e[0m"
dnf install mongodb-org -y  &>>/tmp/roboshop.log

echo -e "\e[33m Updating MongoDB Listen address \e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  &>>/tmp/roboshop.log

echo -e "\e[33m start Mongodb Server \e[0m"
systemctl enable mongod  &>>/tmp/roboshop.log
systemctl restart mongod  &>>/tmp/roboshop.log