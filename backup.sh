#!/bin/bash

clear


# What to backup
backup_folder="#backup_folder#"
dest="#backup_dest_folder#"
dest_server="#backup_dest_server#"
dest_username"#backup_dest_username#"
temp='#temp#'
day=$(date -I)
hostname=$(hostname -s)

working_directory=$(pwd)
starttime=$(date +%s)
startsize=$(echo $(du --block-size=KB -s "$backup_folder" | awk '{print $1}' | rev | cut -c 3- | rev)" * 1000" | bc)
total_size=1


touch "$temp/$day.log"


log() {
	text=$1
	if [ "$text" != "" ]
	then
		if [ "$text" == "/" ]
		then
			echo "" | tee -a "$temp/$day.log"
		else
			echo "[$(date '+%H:%M:%S')] $text" | tee -a "$temp/$day.log"
		fi
	fi
}

new_device(){
	name=$1
	log "/"
	log "/"
	log "--- $name ---"
	log "/"
}

two_digit_time(){
	o_time=$1
	if [ $o_time -lt 10 ]
	then
		echo "0$o_time"
	else
		echo "$o_time"
	fi
}

readeable_size(){
	size=$1
	if [ $size -gt 1024000 ]
	then
		if [ $size -gt 1024000000 ]
		then
			echo $(echo "scale=2; $size/1024000000" | bc)" Go"
		else
			echo $(echo "scale=2; $size/1024000" | bc)" Mo"
		fi
	else
		echo $size" Ko";
	fi
}
cd $backup_folder
echo "Backup of $backup_folder on $(date)" | tee -a "$temp/$day.log"


for vm_folder in *
do
        if [[ -d $vm_folder ]]
	then
		######  Backup Creation  #########

		new_device "$vm_folder"
		archive_file="$vm_folder-$day.tgz"

		log "Backing up $vm_folder to $temp/$archive_file"

		tar czf "$temp/$archive_file" "$backup_folder/$vm_folder" >/dev/null 2>&1 && log "  --> OK"

		arch_size=$(ls -l "$temp/$archive_file" | awk '{print $5}')
		total_size=$(echo "$total_size + $arch_size" | bc)

		########  Backup Copy  ###########

		log "Copying backup to Destination ($(readeable_size $arch_size))"

		scp "$temp/$archive_file" $dest_username@$dest_server:$dest >/dev/null 2>&1 && log "  --> OK"


		#######  Backup Delete  ##########

		log "Deleting local backup"

		rm -rf "$temp/$archive_file" >/dev/null 2>&1 && log "  --> OK" || log "  --> Error"
	fi
done



#Stats

time_to_backup=$(echo "$(date +%s)+61-$starttime" | bc)
hour_to_backup=$(echo "$time_to_backup / 3600" | bc)
mins_to_backup=$(echo "($time_to_backup-(3600*$hour_to_backup)) / 60" | bc)
secs_to_backup=$(echo "($time_to_backup-((3600*$hour_to_backup)+(60*$mins_to_backup)))" | bc)

log "/"
log "Backup Done in $(two_digit_time $hour_to_backup):$(two_digit_time $mins_to_backup):$(two_digit_time $secs_to_backup)"


log "Backuped $(readeable_size $startsize) to $(readeable_size $total_size) ("$(echo "scale=2; 100-(($total_size / $startsize)*100)" | bc)"% Compression)"

scp "$temp/$day.log" $dest_username@$dest_server:$dest >/dev/null 2>&1

python3 "$working_directory/mail.py" "$temp/$day.log"

rm -f "$temp/$day.log"
