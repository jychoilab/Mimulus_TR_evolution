#!/bin/bash

# calculate per site coverage genome wide
bedtools genomecov -ibam "$BAM" -g "$GENOME" > "$SAMPLENAME".persite.cov

# calculate average genome coverage and report is with sample name
paste <(echo "$SAMPLENAME") <(echo "$(awk '{sum+=($2*$3)}END{print sum}' "$COV")/ $(awk '{print $4}' "$COV" | sort | uniq | awk '{sum+=$1}END{print sum}')" | bc -l) > "$SAMPLENAME".cov

