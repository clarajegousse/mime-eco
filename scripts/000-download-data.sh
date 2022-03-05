#!/usr/bin/env bash
#SBATCH --job-name=download-marine-mg
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

# go to working directory
WD=/users/home/cat3/projects/mime-eco
cd $WD/data

touch list-ftp-url-mg.txt
for line in `cat PRJEB41565.txt`
do
	echo $line | grep "ftp" | grep "HI.4967" | grep "\_0m\_" | sed -e 's/;/\n/' >> list-ftp-url-mg.txt
done

cd data
for url in `cat list-ftp-url-mg.txt`
do
	echo $url
	wget $url
done
