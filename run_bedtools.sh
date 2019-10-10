reference=$1
input=$2
output=$3

set -x
W=$(wc -l < ${input})

x=1
while [ $x -le $W ]
do

      string="sed -n ${x}p ${input}"

        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1, $2, $3, $4, $5}')
        set -- $var
        marker=$1 #the first variable (column 1 in files)
	chr=$2
	start=$3
	end=$4
	ref=$5
	alt=$6

# First make bed file:
start=$(echo "${start} - 1" | bc)
start_ref=$(echo "${start} - 200" | bc)
end_ref=$(echo "${end} + 200" | bc)

echo "${chr}	${start_ref}	${start}" > ${marker}.bed
echo "${chr}	${end}	${end_ref}" >> ${marker}.bed

bedtools getfasta -fi ${reference} -bed ${marker}.bed -fo ${marker}.fa

paste --delimiter="" <(echo "${marker}	") <(sed -n '2p' ${marker}.fa) <(echo "[${ref}/${alt}]") <(sed -n '4p' ${marker}.fa)

rm ${marker}.bed ${marker}.fa

x=$(( $x + 1 ))
done > ${output}

for marker in $(awk '{print $1}' ${output}); do
	echo ">${marker}"
	awk -v var=${marker} '$1==var {print $2}' ${output} | sed 's/\[//g' | sed 's/\/.*]//g' | sed 's/-//g'
done > ${output}.check.fasta

blat ${reference} ${output}.check.fasta -stepSize=5 -repMatch=2253 -minScore=0 -minIdentity=0 -out=blast8 ${output}.check.fasta.blat.out

awk '($3==100 && $4>399) {print}' ${output}.check.fasta.blat.out > correct.matches.final.out
