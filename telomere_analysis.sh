##### commands that were used for analyzing the telomere repeat content

## Reference genome based telomere sequence analysis to grep telomere sequences (AAACCG or CGGTTT) from the chromosomes ends
## $CHR: chromosome, $END_B: start of window, $END: end of window to search for telomere sequence
samtools faidx Mguttatus_256_v2.0.fa "$CHR":"$END_B"-"$END" | grep -aob "AAACCG\|CGGTTT" | wc -l | perl -pe 's,\s,,g'

### Nanopore data analysis
##align nanopore fastq data to reference genome using minimp2
minimap2 -L -t "$SLURM_CPUS_ON_NODE" -ax map-ont "$REFGENOME" "$FASTQ" > "$FILENAME".sam

## Calculate the genome coverage
bedtools genomecov -ibam Mlew_ont.csort.bam -d > genomecov.txt

## Counting the number of bases in a merged fasta file
cat Mlew_merged.fastq.gz | paste - - - - | cut -f 2 | tr -d '\n' | wc -c

## Calcualate N50 of Fastq file (script from https://github.com/sandyjmacdonald/fast_stats)
python fast_stats.py -i Mlew_merged.fastq.gz -n 50

## Extract nanopore sequencing reads from telomere region. Use the reference genome alignment BAM file to extract reads.
samtools view -F 256 Mver_merged.bam "MvBL_chr1:45,823,203-45,823,703" |  awk '{OFS="\t"; print ">"$1"\n"$10}' > Chr1_End.fa

## Count GGG repeats
samtools faidx Chr3_End.fa "$CHR":"$END_B"-"$END" | grep -aob "GGG" | wc -l | perl -pe 's,\s,,g'
