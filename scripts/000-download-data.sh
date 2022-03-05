#!/bin/bash

# to insure work with python3
source /users/home/cat3/.bashrc

# go to working directory
WD=/users/home/cat3/projects/mime-eco
cd $WD

touch data/list-ftp-url-mg.txt
for url in `cat data/PRJEB41565.txt`
do
	echo $url | grep "ftp" | grep "HI.4967" | grep "\_0m\_" | sed -e 's/;/\n/' >> data/list-ftp-url-mg.txt
done
