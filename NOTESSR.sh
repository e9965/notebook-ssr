#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
#=========================Variable============================#
data=$1
#=========================Function============================#
	errhandle(){
		case $1 in
		1)echo -e "\033[31m初始化出錯,Ngrok搭建失败,檢查網絡&請回報Bug\033[0m" && exit 2
			;;
		2)echo -e "\033[31m無法下載SSR搭建腳本,請檢查網絡並回報Bug\033[0m" && exit 2
			;;
		3)echo -e "\033[31m未正確啟動Ngrok,請回報Bug\033[0m" && exit 2
			;;
		4)echo -e "\033[31m未完成搭建SSR,請回報Bug\033[0m" && exit 2
			;;
		5)echo -e "\033[31m無法下載BBR搭建腳本,請檢查網絡並回報Bug\033[0m" && exit 2
			;;
		*)echo -e "\033[31m未知错误,错误代码$1,請回報Bug\033[0m" && exit 128
			;;
		esac
	}
	
	installtuning(){
	#Objective: Setup Tuning
		echo -e "\033[34m========================================\033[0m"
		echo -e "\033[34m開始初始化...... \033[0m"
		wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
		if [[ $? != 0 ]] ; then errhandle 1 ; fi
		unzip -q -o ngrok-stable-linux-amd64.zip && rm -f ngrok-stable-linux-amd64.zip
		./ngrok authtoken $1 > /dev/null 2>&1
		if [[ $? != 0 ]] ; then errhandle 1 ; fi
		echo -e "\033[34m完成初始化...... \033[0m"
		echo -e "\033[34m========================================\033[0m"
	}
	
	ssr(){
	#Objective: Setup SSR
		wget -O shadowsocks-all.sh https://raw.githubusercontent.com/e9965/notebook-ssr/master/shadowsocks-all.sh > /dev/null 2>&1
		if [[ $? == 0 ]]
		then
			chmod +x shadowsocks-all.sh && nohup ./shadowsocks-all.sh > /dev/null 2>&1 &
		else
			errhandle 2
		fi
	}
	
	info(){
	#Objective: Give the INFO of SSR
		wget -O tunnels http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1
		if [[ $? == 0 ]]
		then
			echo -e "\033[34m正在獲取SSR鏈接信息: \033[0m"
			raw=$(grep -o "tcp://\{1\}[[:print:]].*,\{1\}" tunnels)
			raw=${raw##*/}
			raw=${raw%%\"*}
			adress=${raw%%:*}
			port=${raw##*:}
			echo "服務器:${adress}"
			echo "端口:${port}"
			echo "密碼:KennyBoy"
			echo "混淆:http_simple"
			echo "方法:aes-256-cfb"
			echo "協議:auth_aes128_md5"
			echo -e "\033[34m========================================\033[0m"
		else
			errhandle 3
		fi
	}
	
	waitcounting(){
	#Objective: Time Waiting Process
		seconds_left=$1
		while [ $seconds_left -gt 0 ]
		do
			echo -n -e "\033[34m<<<<距離搭建完成還剩下:${seconds_left}秒>>>>\033[0m"
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
		echo -e "\033[34m自動安裝中...... \033[0m"
		installtuning $token
		echo -e "\033[32m開始搭建SSR...... \033[0m"
		ssr
		echo -e "\033[32m開始搭建BBR...... \033[0m"
		nohup ./tcp.sh 5 > /dev/null 2>&1 &
	else
		echo -e "\033[34m重新開啟SSR中...... \033[0m"
		/etc/init.d/shadowsocks-r start
	fi
	echo -e "\033[34m========================================\033[0m"
	echo -e "\033[32m開始設置內網穿透...... \033[0m"
	nohup ./ngrok tcp --region=jp 10086 > /dev/null 2>&1 &
	echo -e "\033[32m完成設置內網穿透...... \033[0m"
	echo -e "\033[34m========================================\033[0m"
	if [[ $firstrun == 0 ]] ; then waitcounting 200 ; fi
	echo -e "\033[33m正在查詢SSR狀態: \033[0m"
	if [[ ! -f "/etc/init.d/shadowsocks-r" ]]
	then
		errhandle 4
	else
		/etc/init.d/shadowsocks-r status
	fi
	echo -e "\033[34m========================================\033[0m"
	info
	}
	
	bbr(){
		apt-get update -y  > /dev/null 2>&1
		apt-get install grub2-common -y > /dev/null 2>&1
		wget -O tcp.sh https://raw.githubusercontent.com/e9965/notebook-ssr/master/tcp.sh > /dev/null 2>&1
		if [[ $? == 0 ]]
		then
			chmod +x tcp.sh && nohup ./tcp.sh 1 > /dev/null 2>&1 &
			waitcounting 120
			echo -e "\033[33m請手動重啟NOTEBOOK & 運行 ./NOTESSR.sh {NgrokToken} \033[0m"
		else
			errhandle 2
		fi
	}
#=========================Main_Program============================#
echo -e "\033[32mNOTESSR 腳本 -ver beta 5.0 \033[0m"
echo -e "\033[32m========================================\033[0m"
determinate
if [[ ${data} != "info" ]]
then
	if [[ ${data} != "bbr" ]]
	then
		main $? $data
	else
		bbr
	fi
else
	info
fi
#=========================End============================#
IFS=$OLD_IFS
