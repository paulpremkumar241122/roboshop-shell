source common.sh
component=cart

echo -e "${colour} Configuring NodeJS Repos ${nocolour}"
dnf module disable nodejs -y  &>>${log_file}
dnf module enable nodejs:18 -y  &>>${log_file}

echo -e "${colour} Installing NodeJS ${nocolour}"
dnf install nodejs -y  &>>${log_file}

echo -e "${colour} Add Application User ${nocolour}"
useradd roboshop  &>>${log_file}

echo -e "${colour} Create Application Directory ${nocolour}"
rm -rf ${app_path}  &>>${log_file}
mkdir ${app_path}  &>>${log_file}

echo -e "${colour} Downloading Application Content ${nocolour}"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log_file}
cd ${app_path}

echo -e "${colour} Extracting Application Content ${nocolour}"
unzip /tmp/${component}.zip &>>${log_file}

echo -e "${colour} Install NodeJS Dependencies ${nocolour}"
cd ${app_path}
npm install &>>${log_file}

echo -e "${colour} Setup SystemD Service ${nocolour}"
cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service  &>>${log_file}

echo -e "${colour} Start ${component} Service ${nocolour}"
systemctl daemon-reload  &>>${log_file}
systemctl enable ${component}  &>>${log_file}
systemctl restart ${component}  &>>${log_file}