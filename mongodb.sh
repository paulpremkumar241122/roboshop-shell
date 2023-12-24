source common.sh

echo -e "${colour} Copy MongoDB repo file ${nocolour}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>${log_file}
stat_check $?

echo -e "${colour} Installing MongoDB Server ${nocolour}"
dnf install mongodb-org -y  &>>${log_file}
stat_check $?

echo -e "${colour} Updating MongoDB Listen address ${nocolour}"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf  &>>${log_file}
stat_check $?

echo -e "${colour} start Mongodb Server ${nocolour}"
systemctl enable mongod  &>>${log_file}
systemctl restart mongod  &>>${log_file}
stat_check $?