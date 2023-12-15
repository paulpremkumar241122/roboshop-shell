echo -e "\e[33m Installing Golang \e[0m"
dnf install golang -y  &>>/tmp/roboshop.log

echo -e "\e[33m Adding Application User \e[0m"
useradd roboshop  &>>/tmp/roboshop.log

echo -e "\e[33m Creating Application Directory \e[0m"
rm -rf  &>>/tmp/roboshop.log
mkdir /app  &>>/tmp/roboshop.log

echo -e "\e[33m Downloading Application Content \e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip  &>>/tmp/roboshop.log

echo -e "\e[33m Extracting Application Content \e[0m"
cd /app  &>>/tmp/roboshop.log
unzip /tmp/dispatch.zip  &>>/tmp/roboshop.log

echo -e "\e[33m Downloading the Dependencies \e[0m"
cd /app  &>>/tmp/roboshop.log
go mod init dispatch  &>>/tmp/roboshop.log
go get  &>>/tmp/roboshop.log
go build  &>>/tmp/roboshop.log

echo -e "\e[33m Copying the Service File \e[0m"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service  &>>/tmp/roboshop.log

echo -e "\e[33m Starting Dispatch Service \e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable dispatch  &>>/tmp/roboshop.log
systemctl restart dispatch ; tail -f /var/log/messages