#!/bin/bash
#SBATCH -J nrReads
#SBATCH --account palab
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH -t 12:00:00

###little script to count how many reads each sample has that passed the filters
#AP Jan2021
#it is to use before AncestryHMM or just in general to count how many reads a fq file has 

#usage: sbatch nrReads.sbatch out reads_end
###read 1 and read 4 are equivalent since it is the F and R
#example: sbatch nrReads.sbatch read_number.txt _1.fastq.gz

out=$1
reads_end=$2

rm -rf $out

for file in *$reads_end; do
	echo "Working on $file"
 	num_reads=$(($(zcat $file | wc -l) / 4 ))
	echo "${file} ${num_reads}" >> $out 
done




