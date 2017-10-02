#!/bin/bash

#STR_ARRAY=(`cat fasta.fejlec | sed -e 's/,/\n/g'`)
#for x in "${STR_ARRAY[@]}"
#IFS=$'\n'
#LINES=($(cat fasta.fejlec))
#for x in "${LINES[@]}"

sql="fasta_1.sql"
file="fasta_head.fejlec"

if [ "$#" -ne 1 ]
then
    cat SSRs_2-mers_min-repeats\=7_flank-len\=40.fasta |sed -n '1~2p'> fasta.fejlec
    cat SSRs_2-mers_min-repeats\=7_flank-len\=40.fasta |sed -n '2~2p'> fasta.adat
else
    cat $1 |sed -n '1~2p'> fasta.fejlec
    cat $1 |sed -n '2~2p'> fasta.adat
fi
echo ''> $sql
n=1
while read x 
do
    m=`echo $x | sed "s/[^:]\+/'&'/g"| sed 's/:/,/g'`
    reg=($(echo $x | awk -F : '{print $10}' | grep -E -o '[0-9]+,[0-9]+'))
	c=(`tail -n+$n fasta.adat | head -n1`)
    i=1
    for regio in "${reg[@]}"
    do 
        if ((${#reg[@]}==1));then
            eleje=${regio%,*}
    	    vege=${regio#*,}
            e=$(echo $c |cut -c $((eleje-40))-$((eleje-1)))
            v=$(echo $c |cut -c $((vege+1))-$((vege+40)))
        elif (($i==1));then
            eleje=${regio%,*}
            e=$(echo $c |cut -c $((eleje-40))-$((eleje-1)))
        elif ((${#reg[@]}==$i));then
    	    vege=${regio#*,}
            v=$(echo $c |cut -c $((vege+1))-$((vege+40)))
        fi
        i=$((i+1))
    done
    regio=$(echo ${reg[*]}|sed 's/1://g')
	echo "INSERT INTO fasta (\"H1\",\"H2\",\"H3\",\"H4\",\"H5\",\"H6\",\"H7\",\"H8\",\"H9\",\"H10\",\"regio\",\"eleje\",\"vege\") VALUES ($m,'$regio','$e','$v');" >> $sql
    n=$((n+1))
done < $file
