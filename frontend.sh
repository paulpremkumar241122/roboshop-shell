source common.sh
component=frontend

echo -e "${colour} INSTALLING NGINX SERVER ${nocolour}"
dnf install nginx -y  &>>${log_file}

echo -e "${colour} REMOVING OLD APP CONTENT ${nocolour}"
rm -rf /usr/share/nginx/html/*  &>>${log_file}

echo -e "${colour}  DOWNLOADING ${component} CONTENT  ${nocolour}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log_file}

echo -e "${colour} EXTRACTING ${component} CONTENT ${nocolour}"
cd /usr/share/nginx/html  &>>${log_file}
unzip /tmp/${component}.zip &>>${log_file}

echo -e "${colour} UPDATE ${component} CONFIGURATION ${nocolour}"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>${log_file}

echo -e "${colour} STARTING NGINX SERVER ${nocolour}"
systemctl enable nginx  &>>${log_file}
systemctl restart nginx  &>>${log_file}
