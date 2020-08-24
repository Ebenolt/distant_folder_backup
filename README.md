# Distant Folders backup
Automate Folders Backup and auto email when backup ended


## How to setup

1. Copy your ssh key to the distant server / pc
   To do so type 'ssh-copy-id username@server_ip' ,type yes and enter your password
   If you don't have ssh key, generate one by typing 'ssh-keygen', then Enter x 3

2. Run

```bash
sudo ./setup.sh
```

3. Fill the form and your script is up & running

## How to change frequency

Simply run
```bash
crontab -e
```
and edit the line under "#Dist_folder_backup"

Cron generators: \
https://crontab-generator.org/ \
https://crontab.guru/ \
https://crontab.cronhub.io/ \
