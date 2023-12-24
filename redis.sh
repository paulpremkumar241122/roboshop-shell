source common.sh

echo -e "${colour} Installing Redis Repos ${nocolour}"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>>${log_file}
stat_check $?

echo -e "${colour} Enabling Redis 6.2v ${nocolour}"
dnf module enable redis:remi-6.2 -y  &>>${log_file}
stat_check $?

echo -e "${colour} Installing Redis ${nocolour}"
dnf install redis -y  &>>${log_file}
stat_check $?

echo -e "${colour} Updating the Listen Address ${nocolour}"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf  &>>${log_file}
stat_check $?

echo -e "${colour} Starting Redis Service ${nocolour}"
systemctl enable redis  &>>${log_file}
systemctl restart redis  &>>${log_file}
stat_check $?