source common.sh
component=dispatch

echo -e "${colour} Installing Golang ${nocolour}"
dnf install golang -y  &>>${log_file}

stat_check $?

app_pre_setup

echo -e "${colour} Downloading the Dependencies ${nocolour}"
cd /app  &>>${log_file}
go mod init ${component}  &>>${log_file}
go get  &>>${log_file}
go build  &>>${log_file}
stat_check $?

systemd_setup

systemctl restart ${component} ; tail -f /var/log/messages