
echo -e "\e[33m INSTALLING NGINX SERVER \e[0m"
dnf install nginx -y  &>>/tmp/roboshop.log

echo -e "\e[33m REMOVING OLD APP CONTENT \e[0m"
rm -rf /usr/share/nginx/html/*  &>>/tmp/roboshop.log

echo -e "\e[33m  DOWNLOADING FRONTEND CONTENT  \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>/tmp/roboshop.log

echo -e "\e[33m EXTRACTING FRONTEND CONTENT \e[0m"
cd /usr/share/nginx/html  &>>/tmp/roboshop.log
unzip /tmp/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[33m UPDATE FRONTEND CONFIGURATION \e[0m"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>/tmp/roboshop.log

echo -e "\e[33m STARTING NGINX SERVER \e[0m"
systemctl enable nginx  &>>/tmp/roboshop.log
systemctl restart nginx  &>>/tmp/roboshop.log
