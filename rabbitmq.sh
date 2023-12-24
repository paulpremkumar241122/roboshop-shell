source common.sh

echo -e "${colour} Configuring Erlang Repos ${nocolour}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>${log_file}
stat_check $?

echo -e "${colour} Configuring RabbitMQ Repos ${nocolour}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>${log_file}
stat_check $?

echo -e "${colour} Install RabbitMQ Server ${nocolour}"
dnf install rabbitmq-server -y  &>>${log_file}
stat_check $?

echo -e "${colour} Starting RabbitMQ Server ${nocolour}"
systemctl enable rabbitmq-server  &>>${log_file}
systemctl restart rabbitmq-server  &>>${log_file}
stat_check $?

echo -e "${colour} Adding RabbitMQ Application User ${nocolour}"
rabbitmqctl add_user roboshop roboshop123  &>>${log_file}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${log_file}
stat_check $?