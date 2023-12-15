
echo -e "\e[33m Installing Redis Repos \e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>>/tmp/roboshop.log

echo -e "\e[33m Enabling Redis 6.2v \e[0m"
dnf module enable redis:remi-6.2 -y  &>>/tmp/roboshop.log

echo -e "\e[33m Installing Redis \e[0m"
dnf install redis -y  &>>/tmp/roboshop.log

echo -e "\e[33m Updating the Listen Address \e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf  &>>/tmp/roboshop.log
# update the listen address

echo -e "\e[33m Starting Redis Service \e[0m"
systemctl enable redis
systemctl restart redis