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

for line in `awk 'BEGIN{OFS = ";"};{print $4, $8, $9}' ../PRJEB41565.txt | grep '0m_'`
do
	R1=$( echo $line | cut -f 2 -d ';')
	R2=$( echo $line | cut -f 3 -d ';')

	echo $R1
	wget $R1

	echo $R2
	wget $R2
done
