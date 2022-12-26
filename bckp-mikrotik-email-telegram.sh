#!/bin/bash

# Defina as variáveis de usuário e senha para se conectar ao Mikrotik
MK_USER=user
MK_PASS=password

# Defina o endereço IP do Mikrotik e o nome do arquivo de backup
MK_IP=172.16.0.1
MK_BCKP_FILE=backup.rsc

# Defina o opções de endereço
EMAIL_TO=seu-email@gmail.com
EMAIL_SUBJECT="Backup Mikrotik"
EMAIL_BODY="Corpo do e-mail"

# Define opções para o Telegram
TOKEN="000000000:0000000000000-0000000000000000000000000000000"
CHATID="-1234567890123"

# Formato de compactação desejado: zip ou tar
COMPAC="zip"



# Tenta se conectar ao Mikrotik via SSH
sshpass -p $MK_PASS ssh $MK_USER@$MK_IP "echo conectado via SSH no Mikrotik"
if [ $? -ne 0 ]; then
  echo "Erro: não foi possível se conectar ao Mikrotik via SSH"
  exit 1
fi

# Envia e-mail pelo Mikrotik
 sshpass -p $MK_PASS ssh $MK_USER@$MK_IP '/tool e-mail send to="'"$EMAIL_TO"'" subject="'"$EMAIL_SUBJECT"'" body="'"$EMAIL_BODY"'" file='"$MK_BCKP_FILE"
echo "Email enviado pelo Mikrotik"

# Faz o download do arquivo
sshpass -p $MK_PASS scp $MK_USER@$MK_IP:/$MK_BCKP_FILE .
if [ $? -ne 0 ]; then
  echo "Erro ao fazer download do arquivo de backup"
  exit 1
fi

# Verifica se o arquivo de backup foi realmente baixado
if [ ! -f $MK_BCKP_FILE ]; then
  echo "Erro: arquivo de backup não foi baixado"
  exit 1
fi

# Exibe uma mensagem de sucesso
echo "Arquivo de backup baixado com sucesso!"

# Compacta o arquivo de backup
if [ "$COMPAC" = "zip" ]; then
  zip -r "$MK_BCKP_FILE.zip" "$MK_BCKP_FILE"
  ARQ_BKP="$MK_BCKP_FILE.zip"
else
  tar -zcvf "$MK_BCKP_FILE.tar.gz" "$MK_BCKP_FILE"
  ARQ_BKP="$MK_BCKP_FILE.tar.gz"
fi
echo "Arquivo compactado"

# Envia o backup baixado para o telegram
curl -F document=@"$ARQ_BKP" -F caption="EMAIL_SUBJECT" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHATID" &>/dev/null
echo "Arquivo enviado para o Telegram"