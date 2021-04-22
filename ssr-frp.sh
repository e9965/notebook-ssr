#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
#=========================Variable============================#
if [ ! -f "/etc/shadowsocksR-tmp" ]
then
	data=$1
	passwd=$2
else
	data=$(head -n 1 /etc/shadowsocksR-tmp)
	passwd=$(tail -n 1 /etc/shadowsocksR-tmp)
fi
port=10085
method="chacha20-ietf"
protocol="auth_sha1_v4"
obfs="http_simple"
FILENAME="ShadowsocksR-v3.2.2"
URL="https://github.com/shadowsocksrr/shadowsocksr/archive/3.2.2.tar.gz"
BASE=`pwd`
red='\033[31m'
green='\033[32m'
yellow='\033[33m'
blue='\033[36m'
pp='\033[35m'
plain='\033[0m'
line="========================================================"
#=========================Function============================#
	errhandle(){
		case $1 in
		1) echo -e "${red}初始化出錯,Ngrok搭建失败,檢查網絡&請回報Bug${plain}" && exit 2
			;;
		2) echo "${red}SSR端口被占用,匯報BUG${plain}" && exit 2
			;;
		3) echo -e "${red}未正確啟動Ngrok,請回報Bug${plain}" && exit 2
			;;
		4) echo -e "${red}未完成搭建SSR,請回報Bug${plain}" && exit 2
			;;
		*) echo -e "${red}未知错误,错误代码$1,請回報Bug${plain}" && exit 128
			;;
		esac
	}
	
	preinstall(){
		touch /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list.d/aliyun.list
		sudo echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse"  >> /etc/apt/sources.list.d/aliyun.list
		sudo apt-get update -y
		for i in telnet net-tools libsodium23 openssl unzip wget net-tools; do apt-get install ${i} -y ; done
		apt autoremove -y
		res=`which python`
		if [ "$?" != "0" ]; then
			ln -s /usr/bin/python3 /usr/bin/python
		fi
	}

	installSSR(){
    if [ ! -d /usr/local/shadowsocks ]; then
        if ! wget --no-check-certificate -O ${FILENAME}.tar.gz ${URL}; then
            errhandle 4
        fi

        tar -zxf ${FILENAME}.tar.gz
        mv shadowsocksr-3.2.2/shadowsocks /usr/local
        if [ ! -f /usr/local/shadowsocks/server.py ]; then
            cd ${BASE} && rm -rf shadowsocksr-3.2.2 ${FILENAME}.tar.gz
            errhandle 4
        fi
    fi

     cat > /etc/shadowsocksR.json<<-EOF
{
    "server":"0.0.0.0",
    "server_ipv6":"[::]",
    "server_port":${port},
    "local_port":1081,
    "password":"${passwd}",
    "timeout":600,
    "method":"${method}",
    "protocol":"${protocol}",
    "protocol_param":"",
    "obfs":"${obfs}",
    "obfs_param":"",
    "redirect":"",
    "dns_ipv6":false,
    "fast_open":false,
    "workers":1
}
EOF

	/usr/local/shadowsocks/server.py -c /etc/shadowsocksR.json -d start
    sleep 3
    res=`netstat -nltp | grep ${port} | grep python`
    if [ "${res}" = "" ]; then
        errhandle 2
    fi
	}

	ssr(){
	#Objective: Setup SSR
		preinstall
		installSSR
		cd ${BASE} && rm -rf shadowsocksr-3.2.2 ${FILENAME}.tar.gz
		touch /etc/shadowsocksR-tmp
		echo ${data} > /etc/shadowsocksR-tmp
		echo ${passwd} >> /etc/shadowsocksR-tmp
	}
	
	info(){
	#Objective: Give the INFO of SSR
		echo -e "${blue}正在獲取SSR鏈接信息:${plain}"
		echo -e "${green}服務器:\"frp2.freefrp.net\"${plain}"
		echo -e "${green}端口:\"10085\"${plain}"
		echo -e "${green}密碼:\"${passwd}\"${plain}"
		echo -e "${green}混淆:\"${obfs}\"${plain}"
		echo -e "${green}方法:\"${method}\"${plain}"
		echo -e "${green}協議:\"${protocol}\"${plain}"
		echo -e "${yellow}${line}${plain}"
	}
	
	waitcounting(){
	#Objective: Time Waiting Process
		seconds_left=$1
		while [ $seconds_left -gt 0 ]
		do
			echo -n -e "${pp}<<<<距離搭建完成還剩下:${seconds_left}秒>>>>${plain}"
			sleep 1
			seconds_left=$(($seconds_left - 1))
			echo -ne "\r                                                       \r"
		done
	}
	
	determinate(){
		#Objective: Check Whether install or not
		if [[ ! -f "/etc/shadowsocksR.json" ]]
		then
			installed=0
		else
			installed=1
		fi
		return ${installed}
	}
	
	main(){
		echo -e "${yellow}${line}${plain}"
		determinate
		if [[ $? == 0 ]] 
		then
			echo -e "${green}自動安裝中......${plain}"
			echo -e "${blue}開始搭建SSR......${plain}"
			ssr > /dev/null 2>&1 & waitcounting 120
		else
			echo -e "${blue}重新開啟SSR中......${plain}"
			/usr/local/shadowsocks/server.py -c /etc/shadowsocksR.json -d start
			echo -e "${green}重新開啟SSR成功......${plain}"
		fi
		echo -e "${yellow}${line}${plain}"
		info
	}
#=========================Main_Program============================#
echo -e "${yellow}${line}${plain}"
echo -e "${blue}|| NOTESSR -ver 1.1.0 || By:E9965 || 可免流 || ${plain}"
if [[ ${1} != "info" ]]
then
	main
else
	info
fi
exit 0
#=========================End============================#
IFS=$OLD_IFS
