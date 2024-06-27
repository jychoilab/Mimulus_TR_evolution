#### Denovo transcriptomic assembly using trinity
##running trinity
Trinity --seqType fq --left 19_Lwmeri_S17_R1_001.bbduk_trim.fastq.gz --right 19_Lwmeri_S17_R2_001.bbduk_trim.fastq.gz --CPU 40 --max_memory 240G --output trinity_ouput

###Post assembly: Examine the RNA-Seq read representation of the assembly. 
###To perform the alignment to just capture the read alignment statistics using bowtie
bowtie2-build Trinity.fasta Trinity.fasta
bowtie2 -p 10 -q --no-unal -k 20 -x Trinity.fasta -1 19_Lwmeri_S17_R1_001.bbduk_trim.fastq.gz -2 19_Lwmeri_S17_R2_001.bbduk_trim.fastq.gz 2>align_stats.txt | samtools view -@10 -Sb -o bowtie2.bam

##The 'Gene' Contig Nx Statistic (Based on the lengths of the assembled transcriptome contigs,  the conventional Nx length statistic is calculated)
/trinity/2.8.5/bin/util/TrinityStats.pl Trinity.fasta

##Blast step: Examine the representation of full-length reconstructed protein-coding genes
blastx -query Trinity.fasta -db uniprot_sprot.fasta -out blastx.outfmt6 -evalue 1e-20 -num_threads 6 -max_target_seqs 1 -outfmt 6

##Use BUSCO to explore completeness according to conserved ortholog content
run_BUSCO.py -c 20 -i transcripts.fasta -l /BUSCO/eudicotyledons_odb10/ -o BUSCO -m transcriptome
