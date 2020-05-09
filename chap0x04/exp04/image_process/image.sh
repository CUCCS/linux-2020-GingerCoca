#!/bin/bash
input=""
output=""
quality_pct="75"
resolution_pct="25"
text=""
prefix=""
postfix=""
isCompressQuality="0"
isCompressResolution="0"
isWatermark="0"
isPrefix="0"
isPostfix="0"
isTransJPG="0"


function Usage #提示信息

{
    echo "Usage:"
    echo "  -i  --input <filename>              输入文件
    echo "  -o  --output <filename>             目标存储文件
    echo "  -q, --quality <percent>             图像压缩质量，默认75%"
    echo "  -r, --resolution <percent>          图像分辨率压缩，默认25%"
    echo "  -w, --watermark <text>              添加水印"
    echo "  -p, --prefix <prefix>               添加前缀"
    echo "  -s, --postfix <postfix>             添加后缀"
    echo "  -t, --transfer                      转换为JPG格式"
    echo "  -h,  --help"
}

function compressQuality #压缩图片
{
    if [ -f "$1" ]; then  
        $(convert "$1" -quality "$2"% "$3")
        echo " 成功将"$1" 压缩为 "$3"."   
    else  
        echo " "$1" 不存在"  
    fi
}

function compressResolution  #压缩分辨率
{
    if [ -f "$1" ]; then 
        $(convert "$1" -resize "$2"% "$3")
        echo " 成功将"$1" 压缩为 "$3"."   
    else
        echo " "$1" 不存在"
    fi
}

function addWatermark
{
    if [ -f "$1" ]; then
        $(convert "$1" -draw "gravity east fill black  text 0,12 "$2" " "$3") 
        echo " 已成功添加水印 "$2"，目标文件为 "$3" "
    else 
        echo " "$1" 不存在"
    fi
}

function transFormat
{
    if [ -f "$1" ]; then 
        $(convert "$1" "$2")
        echo "Transfer "$1" into "$2""
    else
        echo " "$1" 不存在"
    fi
}

function addPrefix
{
    for name in `ls *`
    do
        cp "$name" "$1"."$name"
        echo " 成功为 "$name"添加前缀 "$1" "
    done
}

function addPostfix
{
    for name in `ls *`
        do
        cp "$name" "$name"."$1"
        echo " 成功为 "$name"添加后缀 "$1" "
        done
}


####################### Main ############################

# Option analysis and parameters

while [ $# -gt 0 ]; do   #$#代表添加到Shell的参数个数 
    case "$1" in
        -i|--input)   echo "Option i, argument \`$2'" ;
		      case "$2" in
		          "") echo "parameter is needed" ; break ;;
			  *)  input=$2; shift 2 ;;
		      esac ;;
                     
        -o|--output)  echo "Option o, argument \`$2'" ;
                      case "$2" in
		  	  "") echo "parameter is needed" ; break ;;
			  *)  output=$2; shift 2 ;;
		      esac ;;

        -q|--quality)         echo "Option q, argument \`$2'" ;
			      quality_pct=$2 ; isCompressQuality="1" ; shift 2 ;;
                      

        -r|--resolution)      echo "Option r, argument \`$2'" ;
			      resolution_pct=$2 ; isCompressResolution="1" ; shift 2 ;;
                              

        -w|--watermark)   echo "Option w, argument \`$2'" ;
			      text=$2 ; isTextWatermark="1"	 ; shift 2 ;;		  
			     
   		  	       
	-p|--prefix)	      echo "Option p " ;
			      case "$2" in
                                  "") echo "parameter is needed" ; break ;;
			          *)  isPrefix="1" ; prefix=$2 ; shift 2 ;;	  
			      esac ;;	
		
			
	-s|--postfix)	      echo "Option s " ;
			      case "$2" in
				  "") echo "parameter is needed" ; break ;;
				  *)  isPostfix="1" ; postfix=$2 ; shift 2 ;;  
			      esac ;;
			      
	-t|--transfer) 	      echo "Option f" ;
                              isTransFormat="1"
                              shift ;;

        -h|--help)	      Usage
                       	      exit
                       	      ;;

	\?)                   Usage
                              exit 1 ;;

    esac
   
done


# Execution of options

if [ "$isCompressQuality" == "1" ] ; then
	compressQuality $input $quality_pct $output
fi

if [ "$isCompressResolution" == "1" ] ; then
        compressResolution $input $resolution_pct $output
fi

if [ "$isTransJPG" == "1" ] ; then
        transFormat $input $output
fi

if [ "$isTextWatermark" == "1" ] ; then
        addWatermark $input $text $output
fi

if [ "$isPrefix" == "1"  ] ; then
        addPrefix $prefix
fi

if [ "$isPostfix" == "1" ] ; then
        addPostfix $postfix
fi

