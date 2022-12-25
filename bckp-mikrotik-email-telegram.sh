#!/bin/bash

# Defina as variáveis de usuário e senha para se conectar ao Mikrotik
MK_USER=user
MK_PASS=password

# Defina o endereço IP do Mikrotik e o nome do arquivo de backup
MK_IP=172.16.0.1
MK_BCKP_FILE=backup.rsc

# Conectar ao Mikrotik via SSH e baixar o arquivo de backup
sshpass -p $MK_PASS ssh $MK_USER@$MK_IP "export file=$MK_BCKP_FILE"
if [ $? -ne 0 ]; then
  echo "Erro ao se conectar ao Mikrotik via SSH"
  exit 1
fi

sshpass -p $MK_PASS scp $MK_USER@$MK_IP:/$MK_BCKP_FILE .
if [ $? -ne 0 ]; then
  echo "Erro ao fazer download do arquivo de backup"
  exit 1
fi

# Exibir uma mensagem de sucesso
echo "Arquivo de backup baixado com sucesso!"