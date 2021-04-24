if [[ ! -d /work ]]
then
mkdir /work
Vfrp="0.16.1" && wget -qO - https://github.com/fatedier/frp/releases/download/v${Vfrp}/frp_${Vfrp}_linux_amd64.tar.gz | tar -xzC /work && mv /work/frp_${Vfrp}_linux_amd64 /work/frp
cat > /work/frp/frpc.ini << EOF
[common]
server_addr = frp2.freefrp.net
server_port = 7000
token = freefrp.net
[web01]
type = tcp
local_port = 10086
custom_domains = frp2.freefrp.net
remote_port = 10086
[ssh]
type = tcp
local_port = 22
custom_domains = frp2.freefrp.net
remote_port = 10022
EOF
ln -s /work/frp/frpc /bin/frpc
fi
frpc -c /work/frp/frpc.ini
