DPort=${1}
TPort=${2}
ODPort=${3}
OTPort=${4}
if [[ ! -d /work ]]
then
mkdir /work
Vfrp="0.36.2" && wget -qO - https://github.com/fatedier/frp/releases/download/v${Vfrp}/frp_${Vfrp}_linux_amd64.tar.gz | tar -xzC /work && mv /work/frp_${Vfrp}_linux_amd64 /work/frp
cat > /work/frp/frpc.ini << EOF
[common]
server_addr = frp2.freefrp.net
server_port = 7000
token = freefrp.net
[$(head -c 6 /dev/random | base64)]
type = tcp
local_port = ${ODPort}
custom_domains = frp2.freefrp.net
remote_port = ${DPort}
[$(head -c 6 /dev/random | base64)]
type = tcp
local_port = ${OTPort}
custom_domains = frp2.freefrp.net
remote_port = ${TPort}
EOF
ln -s /work/frp/frpc /bin/frpc
fi
frpc -c /work/frp/frpc.ini
