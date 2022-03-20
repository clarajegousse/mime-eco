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
conda activate anvio-master

# go to working directory
WD=/users/home/cat3/projects/mime-eco
CONTIGS_DIR=$WD/sunbeam_output/assembly/contigs
MAPDIR=$WD/sunbeam_output/mapping
CDBs=$CONTIGS_DIR/*.db
PROFILES_DIR=$WD/sunbeam_output/profiles

cd $CONTIGS_DIR
FILES=$CONTIGS_DIR/*-contigs.fa

for file in $FILES
do
	new_name=$(echo $file | cut -f 1,2 -d "-")
	# echo $file $new_name
	anvi-script-reformat-fasta $file -o $new_name.fa -l 1000 --simplify-names
	anvi-gen-contigs-database -f $new_name.fa -o $new_name.db
done
