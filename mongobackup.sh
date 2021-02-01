#!/bin/bash


# ------------------------------------------------------------------
# date: 11-12-2020
# [Author:Vikas Tiwari] Mongodbbackup
#          
#		Description
#
#          This script name is mongobackup.sh (version 1.0)
#          
#          It will create backup For  All database at Dest: /var/mongobackup/backup/ with respected date and db name
#				
#					Example :dump11122020_admin.gz

#			we keep here 2 days backup of databases after every 2nd days it gets deleted .
#			
#			we have scheduled this script at 01:00 AM evryday
#
# Dependency:
#
#    please Do not delete ,rename ,or move dblist.js it help to find lists of  database.
#
# ------------------------------------------------------------------

echo "Mongodb Backup starting .............."

date 

echo "____________________________******************_____________________________"

#This command will list backup created 2 days ago and store in deleted_dump$datebackups.out file 
#before delete so that we have track what was deleted .

find /var/mongobackup/backup/  -mtime +1 > /var/mongobackup/backup/deleted_dump$(date +%d%m%Y)backups.out


# This command will delete all created file  two days ago .
find /var/mongobackup/backup/  -mtime +1 -type f -delete 

#mongo -u admin -p 'admin123' --quiet < /var/mongobackup/script/dblist.js | awk '{print $1}'  This will list 
#all database 
#for loop will asign in variable $i one by one databasename

for i in  `mongo -u Cmots -p 'cmots$2018' --quiet < /var/mongobackup/script/dblist.js | awk '{print $1}'`

do


#mongodump commands use to take backup . 



	mongodump --host localhost --port 27017 --db $i --authenticationDatabase admin --username Cmots --password 'cmots$2018' --archive=/var/mongobackup/backup/dump$(date +%d%m%Y)_$i.gz --gzip


	echo "****Done Backup******* " $i;


done
#-------done backup backup script.........

#To restore database please follow thease steps

#With Index Restore
#mongorestore --host localhost -d <database-name> --port 27017 backupname
#mongorestore --authenticationDatabase admin -u admin -p admin123  --gzip --archive=/var/mongobackup/backup/dump11122020_demo1.gz --db demo1

