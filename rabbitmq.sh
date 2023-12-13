echo -e "\e[33m Configuring Erlang Repos \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>/tmp/roboshop.log

echo -e "\e[33m Configuring RabbitMQ Repos \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>/tmp/roboshop.log

echo -e "\e[33m Install RabbitMQ Server \e[0m"
dnf install rabbitmq-server -y  &>>/tmp/roboshop.log

echo -e "\e[33m Starting RabbitMQ Server \e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[33m Adding RabbitMQ Application User \e[0m"
rabbitmqctl add_user roboshop roboshop123  &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>/tmp/roboshop.log