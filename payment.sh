
echo -e "\e[33m Installing Python 3.6v \e[0m"
dnf install python36 gcc python3-devel -y  &>>/tmp/roboshop.log

echo -e "\e[33m Adding Application User \e[0m"
useradd roboshop

echo -e "\e[33m Creating Application Directory \e[0m"
rm -rf
mkdir /app

echo -e "\e[33m Downloading Application Content \e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip  &>>/tmp/roboshop.log


echo -e "\e[33m Extracting Application Content \e[0m"
cd /app
unzip /tmp/payment.zip  &>>/tmp/roboshop.log

echo -e "\e[33m Installing Application Dependencies \e[0m"
cd /app
pip3.6 install -r requirements.txt  &>>/tmp/roboshop.log

echo -e "\e[33m Copy Payment Service File  \e[0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service

echo -e "\e[33m Starting Payment Service \e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment