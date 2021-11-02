#!/bin/bash

# Combine the paired FASTQ files into one single file

file1=/local/data/public/Genomics_1/assignments/assignment_1/read1.fq
file2=/local/data/public/Genomics_1/assignments/assignment_1/read2.fq
program=/local/data/public/Genomics_1/programs/velvet_1.2.10/contrib/shuffleSequences_fasta/shuffleSequences_fastq.pl

$program $file1 $file2 reads_paired.fq

# Run velveth
#############
velveth_run=/local/data/public/Genomics_1/programs/velvet_1.2.10/velveth
for k in 17 19 21 23 25 27 29 31
do
    $velveth_run assembly_kmer$k $k -fastq -shortPaired reads_paired.fq
done

#  Grid search with velvetg
#############################
velvetg_run=/local/data/public/Genomics_1/programs/velvet_1.2.10/velvetg
touch grid_search.txt

for k in 17 19 21 23 25 27 29 31
do
    for covcutoff in 10 12 14 16 18 20 22
    do
        for expcov in 10 15 20 25 30
        do 
            $velvetg_run assembly_kmer$k -exp_cov $expcov -ins_length 500 -cov_cutoff $covcutoff >> grid_search.txt
            echo "k=$k | cov_cutoff=$covcutoff | exp_cov=$expcov" >> grid_search.txt
        done
    done
done

# Aligning B. aphidicola genes with E. coli ones
################################################
ecoli_genes=/local/data/public/Genomics_1/assignments/assignment_1/Escherichia_coli_str_k_12_substr_mds42.GCA_000350185.1.23.cdna.all.names.fa
exonerate_run=/local/data/public/Genomics_1/programs/exonerate-2.2.0-x86_64/bin/exonerate
baphidicola_genes=/home/re377/Genomics1/assgn_1/Buchnera_aphidicola_bcc_gca_000090965.ASM9096v1.cdna.all.fa

$exonerate_run --query $baphidicola_genes --target $ecoli_genes --querytype dna --targettype dna --model affine:local >> local.txt 



