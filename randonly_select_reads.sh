#!/bin/bash

#13Oct 2022
#need to have conda env with seqkit active
#it is used to randomly select reads (or read pairs) from fq for downsampling

#usage
#sbatch --account=palab --time=12:00:00 randonly_select_reads.sh read1 number seed #for HPC

# e.g.
# sbatch --account=palab --time=12:00:00 randonly_select_reads.sh H4_1_val_1.fq.gz 50000000 1 
#is important to use the same seed for both F and R reads when its not SE (so that the pairs that match are extracted)   
##### read in command line
read=$1
number=$2
seed=$3

echo "seqtk sample -s $seed $read $number > $read"_"$number"

seqtk sample -s $seed $read $number > $read"_"$number



gzip $read"_""$number

