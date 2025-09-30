#!/bin/bash

source ./common.sh
check_root

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabling mysqld"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Starting mysql server"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
VALIDATE $? "Setting up root password"

print_total_time