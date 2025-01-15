#!/bin/bash

#By CoffE

echo "Atualizando os pacotes..."
pkg update -y

pkg install -y proot-distro

apt install -y tur-repo
apt install -y playit

termux-setup-storage

proot-distro login debian --shared-tmp <<EOF

apt update -y

apt install -y sudo wget

mkdir -p samp
cd samp

wget https://sampcenter.com/download/server/linux/03c.tar.gz

tar -xzvf 03c.tar.gz

sudo dpkg --add-architecture i386
sudo apt update -y
sudo apt install -y qemu qemu-user qemu-user-static
sudo apt-get install -y libc6:i386 libstdc++6:i386

clear

echo "Configuração completa!"
echo "Para iniciar o servidor SA-MP, execute o comando:"
echo "qemu-i386 ./samp03svr"

EOF
