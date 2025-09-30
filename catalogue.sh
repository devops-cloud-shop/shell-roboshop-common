#!/bin/bash

source ./common.sh

app_name=catalogue

check_root
app_setup
nodejs_setup

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
    VALIDATE $? "Creating system user"
else
    echo -e "User already exists... $Y SKIPPING $N"
fi

systemd_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongo repo"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Installing mongodb client"

INDEX=$(mongosh mongodb.prav4cloud.online --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Load $app_name Products"
else
    echo -e "$app_name Products already exists... $Y SKIPPING $N" 
fi

app_restart
print_total_time
