
echo -e "\e[33m INSTALLING NGINX SERVER \e[0m"
dnf install nginx -y  >/tmp/roboshop.log

echo -e "\e[33m REMOVING OLD APP CONTENT \e[0m"
rm -rf /usr/share/nginx/html/*  >/tmp/roboshop.log

echo -e "\e[33m  DOWNLOADING FRONTEND CONTENT  \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  >/tmp/roboshop.log

echo -e "\e[33m EXTRACTING FRONTEND CONTENT \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip  >/tmp/roboshop.log


# here we need to copy and update config file

echo -e "\e[33m STARTING NGINX SERVER \e[0m"
systemctl enable nginx
systemctl restart nginx