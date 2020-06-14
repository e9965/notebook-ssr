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
		0)echo -e "${red}初始化失败,請檢查網絡並回報Bug${endc}" && exit 2
			;;
		1)echo -e "${red}無法下載SS搭建腳本,請檢查網絡並回報Bug${endc}" && exit 2
			;;
		2)echo -e "${red}未完成搭建SS,請回報Bug${endc}" && exit 2
			;;
		*)echo -e "${red}未知错误,错误代码$1,請回報Bug${endc}" && exit 128
			;;
		esac
	}
	
	ss(){
	#Objective: Setup SS
		apt-get install shadowsocks-libev -y > /dev/null 2>&1
		if [[ $? == 0 ]]
		then
			echo "{" > /etc/shadowsocks-libev/config.json
			echo "\"server\":\"0.0.0.0\"," >> /etc/shadowsocks-libev/config.json
			echo "\"server_port\":10086," >> /etc/shadowsocks-libev/config.json
			echo "\"local_port\":1081," >> /etc/shadowsocks-libev/config.json
			echo "\"password\":\"${1}\"," >> /etc/shadowsocks-libev/config.json
			echo "\"timeout\":60," >> /etc/shadowsocks-libev/config.json
			echo "\"method\":\"chacha20\"," >> /etc/shadowsocks-libev/config.json
			echo "\"local\":\"127.0.0.1\"," >> /etc/shadowsocks-libev/config.json
			echo "\"fast_open\":false" >> /etc/shadowsocks-libev/config.json
			echo "}" >> /etc/shadowsocks-libev/config.json
			service shadowsocks-libev restart
			nohup ss-server -c config.json > /dev/null 2>&1 &
		else
			errhandle 1
		fi
	}
	
	info(){
	#Objective: Give the INFO of SSR
			if [[ ! -f "/etc/shadowsocks-libev/config.json" ]]
			then
				errhandle 2
			else
				echo -e "${blue}正在獲取SS鏈接信息:${endc}"
				pass=$(cat /etc/shadowsocks-libev/config.json | grep "password")
				pass=${pass##*:}
				pass=${pass%%,*}
				sslink=$(echo -n "chacha20:${pass}@${1}:${2}" | base64 -w0)
				echo -e "${green}服務器:\"${1}\"${endc}"
				echo -e "${green}端口:\"${2}\"${endc}"
				echo -e "${green}密碼:\"${pass}\"${endc}"
				echo -e "${green}方法:\"chacha20\"${endc}"
				echo -e "${green}協議:\"origin\"${endc}"
				echo -e "${green}Obfs:\"plain\"${endc}"
				echo -e "${green}链接:\"ss://${sslink}\"${endc}"
				echo -e "${green}二维码:${endc}"
				qrcode-terminal ss://${sslink}
				echo -e "${yellow}========================================${endc}"
			fi
	}
	
	determinate(){
	#Objective: Check Whether install or not
	if [[ ! -f "/etc/shadowsocks-libev/config.json" ]]
	then
		installed=0
	else
		installed=1
	fi
	return ${installed}
	}
	
	iniqrcode(){
		echo -e "${blue}初始化中......${endc}"
		apt-get install nodejs -y > /dev/null 2>&1
		if [[ $? != 0 ]] ; then errhandle 0 ; fi
		npm install -g qrcode-terminal > /dev/null 2>&1
		if [[ $? != 0 ]] ; then errhandle 0 ; fi
		echo -e "${green}完成初始化......${endc}"
	}
	
	main(){
	firstrun=$1
	if [[ $firstrun == 0 ]] 
	then
		echo -e "${green}自動安裝中......${endc}"
		echo -e "${yellow}========================================${endc}"
					iniqrcode
		echo -e "${yellow}========================================${endc}"
		echo -e "${blue}開始搭建SS......${endc}"
					ss $3
		echo -e "${yellow}========================================${endc}"
	else
		echo -e "${blue}重新開啟SS中......${endc}"
		/etc/init.d/shadowsocks-libev restart
		nohup ss-server -c config.json > /dev/null 2>&1 &
		echo -e "${green}重新開啟SS成功......${endc}"
	fi
	echo -e "${red}提示:需要手動設置端口映射${endc}"
	echo -e "${yellow}========================================${endc}"
	echo -e "${yellow}正在查詢SS狀態:${endc}"
	if [[ ! -f "/etc/init.d/shadowsocks-libev" ]]
	then
		errhandle 2
	else
		/etc/init.d/shadowsocks-libev status
	fi
	echo -e "${yellow}========================================${endc}"
	info $2 $4
	wait
	}
#=========================Main_Program============================#
echo -e "${blue}NOTESSR 腳本 Goorm-ver beta 9.0${endc}"
echo -e "${yellow}========================================${endc}"
determinate
if [[ ${data} != "info" ]]
then
	port=${data##*:}
	data=${data%%:*}
	main $? $data $passwd $port
	wait
else
	info $data $port
fi
#=========================End============================#
IFS=$OLD_IFS
