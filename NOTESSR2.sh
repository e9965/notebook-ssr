#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
#=========================Variable============================#
DomainName=nthykyldss.serveo.net
#=========================Function============================#
	errhandle(){
		exit 1
	}
	
	installtuning(){
	#Objective: Setup Tuning
		apt-get update -y > /dev/null 2>&1 && apt-get install autossh -y > /dev/null 2>&1
		if [[ $? != 0 ]]
		then
			echo -e "\033[31m無法安裝autossh,請檢查網絡並回報Bug\033[0m"
			errhandle
		fi
		echo -e "\033[34m========================================\033[0m"
	}
	
	ssr(){
	#Objective: Setup SSR
		wget -O shadowsocks-all.sh https://raw.githubusercontent.com/e9965/notebook-ssr/master/shadowsocks-all.sh > /dev/null 2>&1
		if [[ $? == 0 ]]
		then
			chmod +x shadowsocks-all.sh && nohup ./shadowsocks-all.sh > /dev/null 2>&1 &
		else
			echo -e "\033[31m無法下載SSR搭建腳本,請檢查網絡並回報Bug\033[0m"
			errhandle
		fi
	}
	
	info(){
	#Objective: Give the INFO of SSR
		wget -O tunnels http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1
		if [[ $? == 0 ]]
		then
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
		else
			echo -e "\033[31m獲取服務器出錯,請回報Bug\033[0m"
			errhandle
		fi
	}
	
	waitcounting(){
	#Objective: Time Waiting Process
		sleep 10
		seconds_left=200
		while [ $seconds_left -gt 0 ]
		do
			echo -n -e "\033[34m<<<<距離搭建完成還剩下:${seconds_left}秒>>>>\033[0m"
			sleep 1
			seconds_left=$(($seconds_left - 1))
			echo -ne "\r     \r"
		done
	}
	
	determinate(){
	#Objective: Check Whether install or not
	installed=0
	/etc/init.d/shadowsocks-r status || installed=1
	return ${installed}
	}
	
	main(){
	firstrun=$1
	if [[ $flag -eq 0 ]] 
	then
		echo -e "\033[34m自動安裝SSR中...... \033[0m"
		installtuning
		echo -e "\033[32m開始搭建SSR...... \033[0m"
		ssr
	else
		echo -e "\033[34m重新開啟SSR中...... \033[0m"
	fi
	echo -e "\033[32m開始設置內網穿透...... \033[0m"
	autossh -M 0 -o "ServerAliveInterval 30" -R ${DomainName}:80:localhost:10086 serveo.net
	echo -e "\033[32m完成設置內網穿透...... \033[0m"
	echo -e "\033[34m========================================\033[0m"
	[ $flag -eq 0 ] && waitcounting
	echo -e "\033[33m正在查詢SSR狀態: \033[0m"
	/etc/init.d/shadowsocks-r status || echo -e "\033[31m未完成搭建SSR,請回報Bug\033[0m" && errhandle
	echo -e "\033[34m========================================\033[0m"
	echo -e "\033[34m正在獲取SSR鏈接信息: \033[0m"
	info
	echo -e "\033[34m========================================\033[0m"
	}
	
#=========================Main_Program============================#
flag=determinate
echo -e "\033[34mNOTESSR2 腳本 -ver beta 0.1 \033[0m"
main $flag
#=========================End============================#
IFS=$OLD_IFS
