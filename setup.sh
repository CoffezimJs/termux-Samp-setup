#!/bin/bash


# Por CoffE)

echo "=== Iniciando configuração do servidor SA-MP no Termux ==="
echo "Atualizando os pacotes..."
pkg update -y

echo "Instalando proot-distro..."
pkg install -y proot-distro

echo "Configurando acesso ao armazenamento..."
termux-setup-storage

echo "Instalando Debian no proot-distro..."
proot-distro install debian
proot-distro login debian --shared-tmp

# Criando script para ser executado dentro do Debian
cat > setup-samp-debian.sh << 'EOL'
#!/bin/bash

echo "Atualizando repositórios Debian..."
apt update -y

echo "Instalando pacotes necessários..."
apt install -y wget tar sudo

echo "Adicionando suporte a arquitetura i386..."
dpkg --add-architecture i386
apt update -y

echo "Instalando bibliotecas de 32 bits e QEMU..."
apt install -y libc6:i386 libstdc++6:i386 libncurses5:i386
apt install -y qemu-user qemu-user-static

echo "Criando diretório para o servidor SA-MP..."
mkdir -p ~/samp
cd ~/samp

echo "Baixando o servidor SA-MP..."
wget https://sampcenter.com/download/server/linux/03c.tar.gz -O samp-server.tar.gz

echo "Extraindo arquivos do servidor..."
tar -xzvf samp-server.tar.gz

echo "Configurando permissões..."
chmod +x samp03svr

# Criando server.cfg básico
cat > server.cfg << 'EOF'
echo Iniciando servidor SA-MP...

hostname Meu Servidor SA-MP
gamemode0 grandlarc 1
filterscripts admin gl_actions
announce 0
query 1
weburl www.meusite.com
maxplayers 50
port 7777
rcon_password senhasegura
language Português
EOF

echo "=== Instalação concluída com sucesso! ==="
echo "Para iniciar o servidor SA-MP, execute os seguintes comandos:"
echo "1. proot-distro login debian"
echo "2. cd ~/samp"
echo "3. ./samp03svr"
echo ""
echo "Se ocorrer algum erro, tente:"
echo "qemu-i386 ./samp03svr"
echo ""
echo "Lembre-se de editar o arquivo server.cfg conforme suas necessidades."
EOL

# Tornando o script executável
chmod +x setup-samp-debian.sh

echo "Executando script de configuração dentro do Debian..."
proot-distro login debian -- bash -c "bash $(pwd)/setup-samp-debian.sh"

echo "=== Configuração completa! ==="
echo "Para iniciar o servidor SA-MP, execute:"
echo "proot-distro login debian"
echo "cd ~/samp"
echo "qemu-i386 ./samp03svr  # ou ./samp03svr se funcionar direto"
