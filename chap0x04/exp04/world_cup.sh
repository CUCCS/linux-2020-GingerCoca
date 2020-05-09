#!/bin/bash

function age_statistics()
{
	age=$(awk -F '\t' '{print $6}' exp04/worldcupplayerinfo.tsv)
	sum=0 
	p1=0 #小于20
	p2=0 #20~30
	p3=0 #30以上

	for i in $age
	do
	    if [ "$i" != 'Age' ] ; then
      		sum=$[sum+1]

		    if [ "$i" -lt 20 ] ; then 
		       p1=$[p1+1]  
		    fi

      		if [ "$i" -ge 20 ] && [ "$i" -le 30 ] ; then 
		        p2=$[p2+1]  
		    fi

      		if [ "$i" -gt 30 ] ; then 
		        p3=$[p3+1] 
	    	fi

        fi
	done

	echo "----------- # 年龄区间范围统计 # -----------"
	echo "20岁以下的球员有"$p1"人，所占百分比为："
    echo "scale=2;"$p1"*100/"$sum"" | bc  #利用bc工具计算，小数点位数设置为2位
    
    echo "20岁到30岁之间的球员有"$p2"人，所占百分比为："
    echo "scale=2;"$p2"*100/"$sum"" | bc
    
    echo "30岁以上的球员有"$p3"人，所占百分比为："
    echo "scale=2;"$p3"*100/"$sum"" | bc
}

function position_statistics()
{
   sum=0
   position=$(awk -F '\t' '{print $5}' exp04/worldcupplayerinfo.tsv)
   #position是第五行参数
	
   flag=0 #用来判断键是否已经存在于pos数组中
   declare -A pos #声明一个存储 [位置——人数] 的关联数组
       for j in $position
         do
           if [ "$j" != 'Position' ] ; then
               for key in ${!pos[*]}
               do
                 if [ "$j" == "$key" ] ; then
                    flag=1
                 fi
          done
 
              if [ "$flag" != 1 ] ; then
                 pos["$j"]=1
              else
                 let pos["$j"]+=1
              fi
          fi
          flag=0
     done
 
 #输出 [位置-人数] 结果
 #for key in ${!pos[@]}
 #do
 #     echo "${key} -> ${pos[$key]}"
 #done

 for value in ${pos[@]}
 do
      let sum+=${value}   #${}用来取值
 done

echo ""----------- # 位置球员统计 # -----------""
 for key in ${!pos[@]}
 do
      echo "位置："${key} "人数："${pos[$key]} "百分比："
      echo "scale=2;"${pos[$key]}"*100/"$sum"" | bc
      echo -e "\t"
 done
}


function find_name()
{
  #利用awk的length函数可直接获得字符串长度
  player=$(awk -F '\t' '{print length($9)}' exp04/worldcupplayerinfo.tsv)
  max=0
  min=100
  
  for i in $player
  do
     if [ $i -gt $max ];then
     let max=$i
     fi
     
     if [ $i -lt $min ];then
     let min=$i
     fi
  done
 
echo "名字最短的球员是： $(awk -F '\t' '{if (length($9)=='$min') {print $9} }' exp04/worldcupplayerinfo.tsv
) 名字长度为： $min"
echo "名字最长的球员是 $(awk -F '\t' '{if (length($9)=='$max') {print $9} }' exp04/worldcupplayerinfo.tsv
) 名字长度为： $max" 
}


function find_age()
{
age=$(awk -F '\t' '{print $6}' exp04/worldcupplayerinfo.tsv)
name=$(awk -F '\t' '{print $9}' exp04/worldcupplayerinfo.tsv)

max=0
min=100
for i in $age
do
    if [ $i != 'Age' ];
    then
      if [ $i -gt $max ];
      then
       max=$i
      fi
      if [ $i -lt $min ];
      then
        min=$i
      fi

    fi

done

echo "年龄最大的球员是 "$(awk -F '\t' '{if ($6~/'$max'/) {print $9} }' exp04/worldcupplayerinfo.tsv) "他的年龄是："$min "岁"
echo "年龄最小的球员是 "$(awk -F '\t' '{if ($6~/'$min'/) {print $9} }' exp04/worldcupplayerinfo.tsv) "他的年龄是： "$max "岁"

}
age_statistics
position_statistics
find_name
find_age

