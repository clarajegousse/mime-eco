#!/usr/bin/env bash
#SBATCH --job-name=make-kaiju-db
#SBATCH -p himem
#SBATCH --time=4-00:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=cat3@hi.is
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

echo $HOSTNAME

# to insure work with python3
source /users/home/cat3/.bashrc
conda activate anvio-master

# go to working directory
WD=/users/work/cat3/db
KAIJU_DIR=$WD/kaijudb

cd $KAIJU_DIR

kaiju-makedb -s nr_euk
