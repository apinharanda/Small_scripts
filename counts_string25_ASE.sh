#!/bin/bash

#install ugrep
#git clone https://github.com/Genivia/ugrep
#then the path is /moto/palab/users/apinharanda/bin/ugrep/bin/ugrep
# /moto/palab/users/apinharanda/bin/ugrep/bin/ug

#usage: bash test.sh out_file_name reads_end path	string	numberAIMs
#example: bash counts_string25_ASE.sh test _R1_001.fastq.gz 1.wnt9/gDNA_reads ATTAAAACAAGATGTGATGATTGGT ACTAAAACAAGATGTGATGATTGGC 2 gDNA 1.wnt9


out=$1
reads_end=$2
path=$3
stringBmori=$4
stringBmand=$5
numberAIMs=$6
what=$7 #cDNA or gDNA
gene=$8 #name

cd $path

###with mismatches
##the output columns File\tnrBmori_reads\tnrBmand_reads\tAmplicon

for file in *$reads_end; do
        echo "Working on $file"
        num_reads_Bmori=$(gunzip -c $file | /moto/palab/users/apinharanda/bin/ugrep/bin/ugrep -Z~$numberAIMs $stringBmori - | grep -v $stringBmand | wc -l )
		num_reads_Bmand=$(gunzip -c $file | /moto/palab/users/apinharanda/bin/ugrep/bin/ugrep -Z~$numberAIMs $stringBmand - | grep -v $stringBmori | wc -l )
        echo "${file} ${num_reads_Bmori} ${num_reads_Bmand} ${what} ${gene}" >> $out
done

##this part of the script uses grep (so no mismatches)

##the output columns file are 
#File\tnrBmori_reads\tnrBmand_reads\tAmplicon

#for file in *$reads_end; do
#        echo "Working on $file"
#		num_reads_Bmori=$(gunzip -c $file | grep $stringBmori | wc -l )
#        num_reads_Bmand=$(gunzip -c $file | grep $stringBmand | wc -l )
#        echo "${file} ${num_reads_Bmori} ${num_reads_Bmand} ${what} ${gene}" >> $out
        
#done

