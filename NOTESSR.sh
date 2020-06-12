#!/bin/bash
OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
echo -e "\033[34m自動安裝SSR中...... \033[0m"
echo -e "\033[34m==================== \033[0m"
echo -e "\033[32m開始設置內網穿透...... \033[0m"
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
unzip ngrok-stable-linux-amd64.zip > /dev/null 2>&1 && rm -f ngrok-stable-linux-amd64.zip
./ngrok authtoken 1byGcMs2lE1L4iV5nSygWfa0o8D_88inzKDCWZ2khchLWEouF
nohup ./ngrok tcp --region=jp 10086 > /dev/null 2>&1 
echo -e "\033[32m完成設置內網穿透...... \033[0m"
echo -e "\033[32m開始搭建SSR...... \033[0m"
wget -O shadowsocks-all.sh https://raw.githubusercontent.com/e9965/notebook-ssr/master/shadowsocks-all.sh > /dev/null 2>&1
chmod +x shadowsocks-all.sh
nohup ./shadowsocks-all.sh > /dev/null 2>&1 &
echo -e "\033[34m==================== \033[0m"
sleep 10
#開始等待完成搭建SSR
seconds_left=200
while [ $seconds_left -gt 0 ]
do
	echo -n -e "\033[34m<<<<距離搭建完成還剩下:${seconds_left}秒>>>>\033[0m"
	sleep 1
	seconds_left=$(($seconds_left - 1))
	echo -ne "\r     \r"
done
echo -e "\033[34m==================== \033[0m"
#等待完成搭建SSR
#確認搭建SSR完成狀態
echo -e "\033[33m正在查詢SSR狀態: \033[0m" && /etc/init.d/shadowsocks-r status
#獲取SSR鏈接資訊
echo -e "\033[34m正在獲取SSR鏈接信息: \033[0m"
wget -O tunnels http://127.0.0.1:4040/api/tunnels > /dev/null 2>&1
#開始篩選SSR鏈接資訊
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
IFS=$OLD_IFS
