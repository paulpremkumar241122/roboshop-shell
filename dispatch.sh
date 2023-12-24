source common.sh
component=

echo -e "${colour} Installing Golang ${nocolour}"
dnf install golang -y  &>>${log_file}

echo -e "${colour} Adding Application User ${nocolour}"
useradd roboshop  &>>${log_file}

echo -e "${colour} Creating Application Directory ${nocolour}"
rm -rf  &>>${log_file}
mkdir /app  &>>${log_file}

echo -e "${colour} Downloading Application Content ${nocolour}"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip  &>>${log_file}

echo -e "${colour} Extracting Application Content ${nocolour}"
cd /app  &>>${log_file}
unzip /tmp/dispatch.zip  &>>${log_file}

echo -e "${colour} Downloading the Dependencies ${nocolour}"
cd /app  &>>${log_file}
go mod init dispatch  &>>${log_file}
go get  &>>${log_file}
go build  &>>${log_file}

echo -e "${colour} Copying the Service File ${nocolour}"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service  &>>${log_file}

echo -e "${colour} Starting Dispatch Service ${nocolour}"
systemctl daemon-reload  &>>${log_file}
systemctl enable dispatch  &>>${log_file}
systemctl restart dispatch ; tail -f /var/log/messages