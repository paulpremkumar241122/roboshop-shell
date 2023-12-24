source common.sh

echo -e "${colour} Disable MySQL Default Version ${nocolour}"
dnf module disable mysql -y  &>>${log_file}
stat_check $?

echo -e "${colour} Copying MySQL Repo File ${nocolour}"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo
stat_check $?

echo -e "${colour} Install MySQL Community Server ${nocolour}"
dnf install mysql-community-server -y  &>>${log_file}
stat_check $?

echo -e "${colour} Starting MySQL Service ${nocolour}"
systemctl enable mysqld  &>>${log_file}
systemctl restart mysqld  &>>${log_file}
stat_check $?

echo -e "${colour} Setup MySQL Password ${nocolour}"
mysql_secure_installation --set-root-pass $1  &>>${log_file}
stat_check $?