#!/bin/bash


if [[ $EUID -ne 0 ]]; then
        printf "\e[33m /!\ This script must be run with sudo /!\ \e[0m\n"
        exit 1
fi

clear

username=$(who am i | awk '{print $1}')
working_dir=$(pwd)

echo " -- Backup Data --"
read -p " -Folder to backup: " backup_folder
read -p " -Temp Folder (local): " backup_temp
read -p " -Dest Server: " backup_server
read -p " -Dest Username: " backup_username
read -p " -Dest Folder: " backup_destination

echo ""
echo " -- Mail Data --"
read -p " -Bot Email: " mail_username
read -p " -Bot Password: " mail_password
read -p " -Mail Server Adress: " mail_server
read -p " -Mail Server Port: " mail_port
read -p " -Report email: " mail_receiver


printf "Configuring script: "
sed -i "s|#backup_folder#|$backup_folder|g" backup.sh
sed -i "s|#backup_dest_folder#|$backup_destination|g" backup.sh
sed -i "s/#backup_dest_server#/$backup_server/g" backup.sh
sed -i "s/#backup_dest_username#/$backup_username/g" backup.sh
sed -i "s|#temp#|$backup_temp|g" backup.sh

sed -i "s/#mail_username#/$mail_username/g" mail.py
sed -i "s/#mail_pass#/$mail_password/g" mail.py
sed -i "s/#mail_serv#/$mail_server/g" mail.py
sed -i "s/#mail_port#/$mail_port/g" mail.py
sed -i "s/#mail_receiver#/$mail_receiver/g" mail.py
printf "\e[32mOK\e[0m\n"

printf "Configuring cron: "
echo "#Dist_folder_backup" >> "/var/spool/cron/crontabs/$username"
echo "* * * * * bash $working_dir/backup.sh" >> "/var/spool/cron/crontabs/$username"
printf "\e[32mOK\e[0m\n\n"




