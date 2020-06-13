#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
#=========================Variable============================#
Token=1byGcMs2lE1L4iV5nSygWfa0o8D_88inzKDCWZ2khchLWEouF
#=========================Function============================#
	errhandle(){
		exit 1
	}
	
	installtuning(){
	#Objective: Setup Tuning
		wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
		if [[ $? != 0 ]]
		then
		echo -e "\033[31m初始化出錯,檢查網絡&請回報Bug\033[0m" && errhandle
		fi
		unzip ngrok-stable-linux-amd64.zip > /dev/null 2>&1 && rm -f ngrok-stable-linux-amd64.zip
		./ngrok authtoken ${token}
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
	if [[ $firstrun == 0 ]] 
	then
		echo -e "\033[34m自動安裝SSR中...... \033[0m"
		installtuning
		echo -e "\033[32m開始搭建SSR...... \033[0m"
		ssr
	else
		echo -e "\033[34m重新開啟SSR中...... \033[0m"
	fi
	echo -e "\033[32m開始設置內網穿透...... \033[0m"
	nohup ./ngrok tcp --region=jp 10086 > /dev/null 2>&1 &
	echo -e "\033[32m完成設置內網穿透...... \033[0m"
	echo -e "\033[34m========================================\033[0m"
	if [[ $firstrun == 0 ]] ; then waitcounting ; fi
	echo -e "\033[33m正在查詢SSR狀態: \033[0m"
	if [[ ! -f "/etc/init.d/shadowsocks-r" ]]
	then
		echo -e "\033[31m未完成搭建SSR,請回報Bug\033[0m" && errhandle
	else
		/etc/init.d/shadowsocks-r status
	fi
	echo -e "\033[34m========================================\033[0m"
	echo -e "\033[34m正在獲取SSR鏈接信息: \033[0m"
	info
	echo -e "\033[34m========================================\033[0m"
	}
	
#=========================Main_Program============================#
echo -e "\033[30mNOTESSR 腳本 -ver beta 2.5 \033[0m"
echo -e "\033[30m========================================\033[0m"
determinate
main $?
#=========================End============================#
IFS=$OLD_IFS
