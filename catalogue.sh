source common.sh
component=catalogue

nodejs

echo -e "${colour} Copy Mongodb Repo ${nocolour}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo  &>>${log_file}

echo -e "${colour} Installing Mongodb ${nocolour}"
dnf install mongodb-org-shell -y  &>>${log_file}

echo -e "${colour} Loading Schema ${nocolour}"
mongo --host mongodb-dev.vagdevi.store <${app_path}/schema/$component.js  &>>${log_file}