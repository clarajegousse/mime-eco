#!/usr/bin/env bash
#SBATCH --job-name=cog
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
PROFILES_DIR=$WD/sunbeam_output/profiles

cd $CONTIGS_DIR
CDBs=$CONTIGS_DIR/*.db

for db in $CDBs
do
	sample=$(basename "$db" | cut -f 1 -d ".")
	#anvi-run-hmms -c $sample.db -T 12
	#anvi-run-ncbi-cogs -c $sample.db -T 12
	anvi-profile -i $MAPDIR/$sample'.bam' -c $CONTIGS_DIR/$sample'.db' -o $PROFILES_DIR/$sample
	# anvi-export-gene-calls -c $new_name.db -o $new_name'-gene-calls.txt' --gene-caller prodigal
	# anvi-export-gene-coverage-and-detection -c $file -o $new_name
	# anvi-get-sequences-for-gene-calls -c $file -o $new_name'-gene.fasta'
done
