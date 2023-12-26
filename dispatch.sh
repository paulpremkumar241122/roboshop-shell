source common.sh
component=dispatch

echo -e "${colour} Installing Golang ${nocolour}"
dnf install golang -y  &>>${log_file}
stat_check $?

echo -e "${colour} Adding Application User ${nocolour}"
useradd roboshop  &>>${log_file}
stat_check $?

echo -e "${colour} Creating Application Directory ${nocolour}"
rm -rf  &>>${log_file}
mkdir /app  &>>${log_file}
stat_check $?

echo -e "${colour} Downloading Application Content ${nocolour}"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log_file}
stat_check $?

echo -e "${colour} Extracting Application Content ${nocolour}"
cd /app  &>>${log_file}
unzip /tmp/${component}.zip  &>>${log_file}
stat_check $?

echo -e "${colour} Downloading the Dependencies ${nocolour}"
cd /app  &>>${log_file}
go mod init ${component}  &>>${log_file}
go get  &>>${log_file}
go build  &>>${log_file}
stat_check $?

echo -e "${colour} Copying the Service File ${nocolour}"
cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service  &>>${log_file}
stat_check $?

echo -e "${colour} Starting ${component} Service ${nocolour}"
systemctl daemon-reload  &>>${log_file}
systemctl enable ${component}  &>>${log_file}
systemctl restart ${component} ; tail -f /var/log/messages