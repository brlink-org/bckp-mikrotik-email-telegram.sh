#!/bin/bash

# Defina as variáveis de usuário e senha para se conectar ao Mikrotik
MK_USER=user
MK_PASS=password

# Defina o endereço IP do Mikrotik e o nome do arquivo de backup
MK_IP=172.16.0.1
MK_BCKP_FILE=backup.rsc



# Tentar se conectar ao Mikrotik via SSH
sshpass -p $MK_PASS ssh $MK_USER@$MK_IP "echo conectado via SSH no Mikrotik"
if [ $? -ne 0 ]; then
  echo "Erro: não foi possível se conectar ao Mikrotik via SSH"
  exit 1
fi

# Verificar se o arquivo existe no Mikrotik
IFILE_MK=$(sshpass -p $MK_PASS ssh $MK_USER@$MK_IP "file print where name=$MK_BCKP_FILE")
if ! grep -q "^$MK_BCKP_FILE" <<< "$IFILE_MK"; then
  echo "Erro: arquivo não encontrado no Mikrotik"
  exit 1
fi

# Fazer o download do arquivo
sshpass -p $MK_PASS scp $MK_USER@$MK_IP:/$MK_BCKP_FILE .
if [ $? -ne 0 ]; then
  echo "Erro ao fazer download do arquivo de backup"
  exit 1
fi

# Verificar se o arquivo de backup foi realmente baixado
if [ ! -f $MK_BCKP_FILE ]; then
  echo "Erro: arquivo de backup não foi baixado"
  exit 1
fi

# Exibir uma mensagem de sucesso
echo "Arquivo de backup baixado com sucesso!"