#!/bin/bash

# Defina as variáveis de usuário e senha para se conectar ao Mikrotik
MK_USER=user
MK_PASS=password

# Defina o endereço IP do Mikrotik e o nome do arquivo de backup
MK_IP=172.16.0.1
MK_BCKP_FILE=backup.rsc

# Defina o endereço de email
EMAIL=seu-email@gmail.com

# Defina opções para o Telegram token e id do bot
TOKEN="000000000:0000000000000-0000000000000000000000000000000"
CHATID="-1234567890123"

# Defina o formato de compactação desejado: "zip" ou "tar"
COMPAC="zip"



# Não alterar mais nada abaixo
# Exceto por sua conta e risco

# Captura data do envio do backup
DATA=$(date +%d/%m/%Y)

# Mensagens para email e notificação do Telegram
MSG="Mikrotik - Backup do dia $DATA"

# Conecta-se ao Mikrotik via SSH
sshpass -p $MK_PASS ssh $MK_USER@$MK_IP "echo conectado via SSH no Mikrotik"
# Verifica se a conexão SSH foi bem sucedida 
if [ $? -ne 0 ]; then
  # Exibe mensagem de erro de conexão ao Mikrotik via SSH
  echo "Erro: não foi possível se conectar ao Mikrotik via SSH"
  exit 1
fi

# Envia o backup por e-mail pelo Mikrotik
sshpass -p $MK_PASS ssh $MK_USER@$MK_IP '/tool e-mail send to="'"$EMAIL"'" subject="'"$MSG"'" body="'"$MSG"'" file='"$MK_BCKP_FILE"
# Exibe mensagem de envio do backup por email pelo Mikrotik
echo "Backup enviado por email pelo Mikrotik"

# Faz o download do arquivo de dentro do Mikrotik
sshpass -p $MK_PASS scp $MK_USER@$MK_IP:/$MK_BCKP_FILE .

# Comente da linha 32 até 47 se desejar mudar o método de conexão de SSH para FTP
# Destacando que não será possível executar o envio do arquivo por e-mail através do FTP
# Conecta-se ao Mikrotik via FTP

#ftp -in $MK_IP <<END_SCRIPT
#quote USER $MK_USER
#quote PASS $MK_PASS
#get $MK_BCKP_FILE
#quit
#END_SCRIPT

# Verifica se o download foi bem sucedido
if [ $? -ne 0 ]; then
  # Exibe mensagem de erro ao fazer download do arquivo de backup
  echo "Erro ao fazer download do arquivo de backup"
  exit 1
fi

# Verifica se o arquivo de backup foi realmente baixado do Mikrotik
if [ ! -f $MK_BCKP_FILE ]; then
  # Exibe mensagem de erro informando que o backup não foi baixado 
  echo "Erro: arquivo de backup não foi baixado"
  exit 1
fi

# Exibe uma mensagem de que o arquivo de backup foi baixado com sucesso
echo "Arquivo de backup baixado com sucesso!"

# Compacta o arquivo de backup e armazena na variável ARQ_BKP
if [ "$COMPAC" = "zip" ]; then
  zip -r "$MK_BCKP_FILE.zip" "$MK_BCKP_FILE"
  ARQ_BKP="$MK_BCKP_FILE.zip"
else
  tar -zcvf "$MK_BCKP_FILE.tar.gz" "$MK_BCKP_FILE"
  ARQ_BKP="$MK_BCKP_FILE.tar.gz"
fi
# Exibe uma mensagem de que o arquivo foi compactado
echo "Arquivo compactado"

# Envia o backup baixado para o Telegram
curl -F document=@"$ARQ_BKP" -F caption="$MSG" "https://api.telegram.org/bot${TOKEN}/sendDocument?chat_id=$CHATID" &>/dev/null
echo "Arquivo enviado para o Telegram"