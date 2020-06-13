#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
#=========================Variable============================#
data=$1
passwd=$2
red='\033[31m'
green='\033[32m'
yellow='\033[33m'
blue='\033[36m'
pp='\033[35m'
endc='\033[0m'
#=========================Function============================#
	errhandle(){
		case $1 in
		1)echo -e "${red}無法下載SSR搭建腳本,請檢查網絡並回報Bug${endc}" && exit 2
			;;
		2)echo -e "${red}未完成搭建SSR,請回報Bug${endc}" && exit 2
			;;
		*)echo -e "${red}未知错误,错误代码$1,請回報Bug${endc}" && exit 128
			;;
		esac
	}
	
	ssr(){
	#Objective: Setup SSR
		wget -O shadowsocks-all.sh https://raw.githubusercontent.com/e9965/notebook-ssr/master/shadowsocks-all.sh > /dev/null 2>&1
		if [[ $? == 0 ]]
		then
			chmod +x shadowsocks-all.sh
      ./shadowsocks-all.sh install $1 > /dev/null 2>&1
		else
			errhandle 2
		fi
	}
	
	info(){
	#Objective: Give the INFO of SSR
			echo -e "${blue}正在獲取SSR鏈接信息:${endc}"
			echo -e "${green}服務器:\"需要在控制台讀取\"${endc}"
			echo -e "${green}端口:\"需要在控制台設置\"${endc}"
			echo -e "${green}密碼:\"${pass}\"${endc}"
			echo -e "${green}混淆:\"http_simple\"${endc}"
			echo -e "${green}方法:\"aes-256-cfb\"${endc}"
			echo -e "${green}協議:\"auth_aes128_md5\"${endc}"
			echo -e "${yellow}========================================${endc}"
	}
	
	determinate(){
	#Objective: Check Whether install or not
	if [[ ! -f "/etc/init.d/shadowsocks-r" ]]
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
		echo -e "${blue}開始搭建SSR......${endc}"
		ssr $3
    wait
	else
		echo -e "${blue}重新開啟SSR中......${endc}"
		/etc/init.d/shadowsocks-r restart
		echo -e "${green}重新開啟SSR成功......${endc}"
	fi
	echo -e "${yellow}========================================${endc}"
	echo -e "${blue}提示:需要手動設置端口映射${endc}"
	echo -e "${yellow}========================================${endc}"
	echo -e "${yellow}正在查詢SSR狀態:${endc}"
	if [[ ! -f "/etc/init.d/shadowsocks-r" ]]
	then
		errhandle 4
	else
		/etc/init.d/shadowsocks-r status
	fi
	echo -e "${yellow}========================================${endc}"
	info
	}
#=========================Main_Program============================#
echo -e "${blue}NOTESSR 腳本 -ver beta 7.1${endc}"
echo -e "${yellow}========================================${endc}"
determinate
if [[ ${data} != "info" ]]
then
	main $? $data $passwd
else
	info
fi
#=========================End============================#
IFS=$OLD_IFS
