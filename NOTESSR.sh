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
		1)echo -e "${red}初始化出錯,Ngrok搭建失败,檢查網絡&請回報Bug${endc}" && exit 2
			;;
		2)echo -e "${red}無法下載SSR搭建腳本,請檢查網絡並回報Bug${endc}" && exit 2
			;;
		3)echo -e "${red}未正確啟動Ngrok,請回報Bug${endc}" && exit 2
			;;
		4)echo -e "${red}未完成搭建SSR,請回報Bug${endc}" && exit 2
			;;
		*)echo -e "${red}未知错误,错误代码$1,請回報Bug${endc}" && exit 128
			;;
		esac
	}
	
	installtuning(){
	#Objective: Setup Tuning
		echo -e "${yellow}========================================${endc}"
		echo -e "${blue}開始初始化......${endc}"
		wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
		if [[ $? != 0 ]] ; then errhandle 1 ; fi
		unzip -q -o ngrok-stable-linux-amd64.zip && rm -f ngrok-stable-linux-amd64.zip
		./ngrok authtoken $1 > /dev/null 2>&1
		if [[ $? != 0 ]] ; then errhandle 1 ; fi
		echo -e "${blue}初始化中......${endc}"
		apt-get install nodejs -y > /dev/null 2>&1
		if [[ $? != 0 ]] ; then errhandle 1 ; fi
		npm install -g qrcode-terminal > /dev/null 2>&1
		if [[ $? != 0 ]] ; then errhandle 1 ; fi
		echo -e "${green}完成初始化......${endc}"
		echo -e "${yellow}========================================${endc}"
	}
	
	ssr(){
	#Objective: Setup SSR
		wget -O shadowsocks-all.sh https://raw.githubusercontent.com/e9965/notebook-ssr/master/shadowsocks-all.sh > /dev/null 2>&1
		if [[ $? == 0 ]]
		then
			chmod +x shadowsocks-all.sh && nohup ./shadowsocks-all.sh install $1 > /dev/null 2>&1 &
		else
			errhandle 2
		fi
	}
	
	info(){
	#Objective: Give the INFO of SSR
		wget -O tunnels http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1
		if [[ $? == 0 ]]
		then
			echo -e "${blue}正在獲取SSR鏈接信息:${endc}"
			raw=$(grep -o "tcp://\{1\}[[:print:]].*,\{1\}" tunnels)
			raw=${raw##*/}
			raw=${raw%%\"*}
			adress=${raw%%:*}
			port=${raw##*:}
			pass=$(cat /etc/shadowsocks-r/config.json | grep "password")
			pass=${pass##*:}
			pass=${pass#*\"}
			pass=${pass%%,*}
			pass=${pass%\"*}
			ssrlinktmp=$(echo -n "${pass}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g')
			ssrlink=$(echo -n "${adress}:${port}:auth_aes128_md5:aes-256-cfb:http_simple:${ssrlinktmp}/?obfsparam=" | base64 -w0)
			echo -e "${green}服務器:\"${adress}\"${endc}"
			echo -e "${green}端口:\"${port}\"${endc}"
			echo -e "${green}密碼:\"${pass}\"${endc}"
			echo -e "${green}混淆:\"http_simple\"${endc}"
			echo -e "${green}方法:\"aes-256-cfb\"${endc}"
			echo -e "${green}協議:\"auth_sha1_v4\"${endc}"
			echo -e "${green}二维码:${endc}"
			qrcode-terminal ssr://${ssrlink}
			echo -e "${yellow}========================================${endc}"
		else
			errhandle 3
		fi
	}
	
	waitcounting(){
	#Objective: Time Waiting Process
		seconds_left=$1
		while [ $seconds_left -gt 0 ]
		do
			echo -n -e "${pp}<<<<距離搭建完成還剩下:${seconds_left}秒>>>>${endc}"
			sleep 1
			seconds_left=$(($seconds_left - 1))
			echo -ne "\r                                                       \r"
		done
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
	token=$2
	if [[ $firstrun == 0 ]] 
	then
		echo -e "${green}自動安裝中......${endc}"
		installtuning $token
		echo -e "${blue}開始搭建SSR......${endc}"
		ssr $3
	else
		echo -e "${blue}重新開啟SSR中......${endc}"
		/etc/init.d/shadowsocks-r restart
		echo -e "${green}重新開啟SSR成功......${endc}"
	fi
	echo -e "${yellow}========================================${endc}"
	echo -e "${blue}開始設置內網穿透......${endc}"
	nohup ./ngrok tcp --region=jp 10086 > /dev/null 2>&1 &
	echo -e "${green}完成設置內網穿透......${endc}"
	echo -e "${yellow}========================================${endc}"
	if [[ $firstrun == 0 ]] ; then waitcounting 200 ; fi
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
echo -e "${blue}NOTESSR -ver 0.01 || By:E9965 || 可免流 || ${endc}"
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
