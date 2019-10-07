# bedtools_for_marker_design
Using bedtools and blat to make a file to submit to Thermo's Agriseq team.

#### Make sure you have bedtools and blat installed, then run:
`./run_bedtools.sh [full_path_to_reference_fasta] [input_file] [output_file]`

#### Input file needs to look like this (tab-delimited): `marker_ID chr start end reference_allele  alternate_allele`
##### e.g.,:
```
marker1 chr1    1000    1001    C       A
marker2 chr2    1000    1001    A       -
marker3 chr3    1000    1001    -       A
```
