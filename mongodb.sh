echo -e "\e[33m Copy MongoDB repo file \e[0m"
cp mongodb.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[33m Installing MongoDB Server \e[0m"
dnf install mongodb-org -y
echo -e "\e[32m Modify the config file \e[0m"
# modify the config file
echo -e "\e[33m start Mongodb Server \e[0m"
systemctl enable mongod
systemctl restart mongod