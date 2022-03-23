# to insure work with python3
source /users/home/cat3/.bashrc
#conda activate anvio-master

WD=/users/home/cat3/projects/mime-eco
CONTIGS_DIR=$WD/sunbeam_output/assembly/contigs
RAW_DATA_DIR=$WD/data
MAPDIR=$WD/sunbeam_output/mapping
NUM_THREADS=12

# go to working directory
cd $CONTIGS_DIR
FILES=$CONTIGS_DIR/*.fa

for file in $FILES
do
	sample=$(basename "$file" | cut -f 1 -d ".")
echo $sample
echo '''#!/usr/bin/env bash
#SBATCH --job-name=profiling
#SBATCH -p normal
#SBATCH --time=2-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc

WD=/users/home/cat3/projects/mime-eco
CONTIGS_DIR=$WD/sunbeam_output/assembly/contigs
RAW_DATA_DIR=$WD/data
MAPDIR=$WD/sunbeam_output/mapping
PROFILES_DIR=$WD/sunbeam_output/profiles
NUM_THREADS=12

sample='$sample'

conda activate anvio-master

bowtie2-build $CONTIGS_DIR/$sample".fa" $MAPDIR/$sample
bowtie2 --threads $NUM_THREADS -x $MAPDIR/$sample -1 $RAW_DATA_DIR/$sample"_1.fastq.gz" -2 $RAW_DATA_DIR/$sample"_2.fastq.gz" -S $MAPDIR/$sample".sam"

conda deactivate

samtools view -F 4 -bS $MAPDIR/$sample".sam" > $MAPDIR/$sample"-RAW.sam"

conda activate anvio-master

anvi-init-bam $MAPDIR/$sample"-RAW.sam" -o $MAPDIR/$sample".bam"
anvi-profile -i $MAPDIR/$sample".bam" -c $CONTIGS_DIR/$sample".db" -o $PROFILES_DIR/$sample -T $NUM_THREADS
''' > $WD/$sample-mapping-pbs.sh

done
