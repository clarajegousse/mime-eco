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

WD=/users/home/cat3/projects/mime-eco
CONTIGS_DIR=$WD/sunbeam_output/assembly/contigs
RAW_DATA_DIR=$WD/data
MAPDIR=$WD/sunbeam_output/mapping
NUM_THREADS=12

# go to working directory
cd $CONTIGS_DIR
FILES=$CONTIGS_DIR/*.fa

#for file in $FILES
#do
#	sample=$(basename "$file" | cut -f 1 -d "-")
#	bowtie2-build $file $MAPDIR/$sample
#done


for file in $FILES
do
	sample=$(basename "$file" | cut -f 1 -d ".")
echo $sample
echo '''#!/bin/bash
#SBATCH --job-name='$sample'-bowtie2
#SBATCH -p normal
#SBATCH --time=10:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --output='$sample'-bowtie2.%j.out
#SBATCH --error='$sample'-bowtie2.%j.err

echo $HOSTNAME
source /users/home/cat3/.bashrc
conda activate anvio-master


WD=/users/home/cat3/projects/mime-eco
CONTIGS_DIR=$WD/sunbeam_output/assembly/contigs
RAW_DATA_DIR=$WD/data
MAPDIR=$WD/sunbeam_output/mapping
NUM_THREADS=12

# go to working directory
cd $CONTIGS_DIR
FILES=$CONTIGS_DIR/*-contigs.fa


# echo $file $new_name
bowtie2 --threads $NUM_THREADS -x $MAPDIR/'$sample' -1 $RAW_DATA_DIR/'$sample'_1.fastq.gz -2 $RAW_DATA_DIR/'$sample'_2.fastq.gz -S $MAPDIR/'$sample'.sam
# samtools view -F 4 -bS $MAPDIR/'$sample'.sam > $MAPDIR/'$sample'-RAW.sam
# anvi-init-bam $MAPDIR/'$sample'-RAW.sam -o $MAPDIR/'$sample'.bam
# rm 04_MAPPING/Sample_01.sam 04_MAPPING/Sample_01-RAW.bam

''' > $WD/$sample-bowtie-pbs.sh

done
