
# Top 100

echo -e"\n统计访问来源主机TOP 100和分别对应出现的总次数"
echo -e
top100Host=$(more exp04/web_log.tsv | awk -F '\t' '{print $1}'| sort | uniq -c | sort -k1 -nr | head -n 100)
echo "$top100Host"


echo -e "\n统计访问来源主机TOP 100 IP和分别对应出现的总次数"
echo -e
top100IP=$(more exp04/web_log.tsv | awk -F '\t' '{print $1}' | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sort | uniq -c | sort -k1 -nr | head -n 100)
echo "$top100IP"


echo -e"\n统计最频繁被访问的URL TOP 100"
echo -e
top100URL=$(more exp04/web_log.tsv |awk -F '\t' '{print $5}' | sort | uniq -c | sort -k1 -nr | head -n 100)
echo "$top100URL"


	rCode=$(sed -n '2,$ p' exp04/web_log.tsv |awk -F'\t' '{print $6}'| sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}')

	rCount=$(sed -n '2,$ p' exp04/web_log.tsv |awk -F'\t' '{print $6}'| sort | uniq -c |sort -nr | head -n 10 | awk '{print $1}')

	code=($rCode)
	count=($rCount)

	sum=0
	for i in $rCount
	do
		sum=$((${sum}+${i}))
	done

	p=0
	for k in ${count[@]}
	do	
		ratio[${p}]=$(echo "scale=4; 100*${k}/$sum"|bc)
		let p+=1
	done

	echo -e "\n不同响应状态码的出现次数和对应百分比"
	echo -e
	for i in $(seq 0 $(echo "${#count[@]}-1"|bc))
	do
		echo "状态码: "${code[${i}]}" "
		echo "次数: "${count[${i}]}" "
		echo "百分比: "${ratio[${i}]}" %"
	done
	echo -e

	temp=$(more exp04/web_log.tsv | awk -F'\t' '{if(substr($6,1,1)==4)print $5"\t"$6}' > target2.txt)
	codes_type=$(more target2.txt | awk -F'\t' '{print $2}'| sort | uniq -c | awk '{print $2}')
	codes_count=$(more target2.txt | awk -F'\t' '{print $2}'| sort | uniq -c | awk '{print $1}')

	for t in $codes_type
	do	
		echo -e "\n状态码： $t 对应的TOP 10 URL 以及出现的总次数"
		echo -e
		url=$(more target2.txt | awk -F'\t' '{if($2=='$t')print $1}' | sort | uniq -c | sort -nr | head)	
		echo "$url"
		echo -e
	done

	
	url="/images/NASA-logosmall.gif"
	
	echo -e
	echo -e "\n给定URL输出TOP 100访问来源主机"
	echo -e 
	hosts=$(more exp04/web_log.tsv | awk -F'\t' '{if("'$url'"==$5)print $1}' | sort | uniq -c | sort -k1 -nr |head -n 100)
	echo "$hosts"

