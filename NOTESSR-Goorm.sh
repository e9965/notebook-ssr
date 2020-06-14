#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
#=========================Variable============================#
data=$1
passwd=$2
port=$3
red='\033[31m'
green='\033[32m'
yellow='\033[33m'
blue='\033[36m'
pp='\033[35m'
endc='\033[0m'
#=========================Function============================#
	errhandle(){
		case $1 in
		1)echo -e "${red}無法下載SS搭建腳本,請檢查網絡並回報Bug${endc}" && exit 2
			;;
		2)echo -e "${red}未完成搭建SS,請回報Bug${endc}" && exit 2
			;;
		*)echo -e "${red}未知错误,错误代码$1,請回報Bug${endc}" && exit 128
			;;
		esac
	}
	
	ssr(){
	#Objective: Setup SS
		wget -q -O shadowsocks-libev.sh https://raw.githubusercontent.com/e9965/notebook-ssr/master/shadowsocks-libev.sh
		if [[ $? == 0 ]]
		then
			chmod +x shadowsocks-libev
     			./shadowsocks-libev.sh install $1
		else
			errhandle 1
		fi
	}
	
	info(){
	#Objective: Give the INFO of SSR
			if [[ ! -f "/etc/shadowsocks-r/config.json" ]]
			then
				errhandle 2
			else
				pass=$(cat /etc/shadowsocks-r/config.json | grep "password")
				pass=${pass##*:}
				pass=${pass%%,*}
				echo -e "${blue}正在獲取SSR鏈接信息:${endc}"
				echo -e "${green}服務器:\"${1}\"${endc}"
				echo -e "${green}端口:\"${2}\"${endc}"
				echo -e "${green}密碼:\"${pass}\"${endc}"
				echo -e "${green}方法:\"aes-256-cfb\"${endc}"
				echo -e "${green}協議:\"auth_aes128_md5\"${endc}"
				echo -e "${yellow}========================================${endc}"
			fi
	}
	
	determinate(){
	#Objective: Check Whether install or not
	if [[ ! -f "/etc/init.d/shadowsocks-libev" ]]
	then
		installed=0
	else
		installed=1
	fi
	return ${installed}
	}
	
	main(){
	firstrun=$1
	if [[ $firstrun == 0 ]] 
	then
		echo -e "${green}自動安裝中......${endc}"
		echo -e "${blue}開始搭建SS......${endc}"
		ss $3
    		wait && clear
	else
		echo -e "${blue}重新開啟SSR中......${endc}"
		/etc/init.d/shadowsocks-libev restart
		echo -e "${green}重新開啟SSR成功......${endc}"
	fi
	echo -e "${yellow}========================================${endc}"
	echo -e "${blue}提示:需要手動設置端口映射${endc}"
	echo -e "${yellow}========================================${endc}"
	echo -e "${yellow}正在查詢SSR狀態:${endc}"
	if [[ ! -f "/etc/init.d/shadowsocks-libev" ]]
	then
		errhandle 2
	else
		/etc/init.d/shadowsocks-libev status
	fi
	echo -e "${yellow}========================================${endc}"
	info $2 $4
	}
#=========================Main_Program============================#
echo -e "${blue}NOTESSR 腳本 Goorm-ver beta 7.5${endc}"
echo -e "${yellow}========================================${endc}"
determinate
if [[ ${data} != "info" ]]
then
	main $? $data $passwd $port
else
	info $data $port
fi
#=========================End============================#
IFS=$OLD_IFS
