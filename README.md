# Backup do Mikrotik
Este é um script de backup automatizado para o Mikrotik RouterOS. O script realiza o backup do Mikrotik, envia o arquivo por email e também envia uma cópia do backup compactado para o Telegram.



## Pré-requisitos
`sshpass`

`curl`

`tar` (opcional)



## Instalação

1) Faça o download do script `bckp-mikrotik.sh`

2) Defina as variáveis de usuário e senha para se conectar ao Mikrotik no início do script

3) Defina o endereço IP do Mikrotik e o nome do arquivo de backup

4) Defina o endereço de email para onde o backup será enviado

5) Defina o token e o chatid do seu bot do Telegram

6) Defina o formato de compactação desejado: "zip" ou "tar"

7) Salve as alterações no script

8) Dê permissão de execução ao script: `chmod +x bckp-mikrotik.sh` ou `chmod 777 bckp-mikrotik.sh`



## Utilização
Execute o script: ./bckp-mikrotik.sh



## Observações
O script só foi testado no Linux, mas deve funcionar também em outros sistemas operacionais compatíveis com os requisitos.

Caso o envio do backup pelo email ou pelo Telegram não funcione, verifique se o firewall do Mikrotik está liberando a conexão de saída para esses serviços (/ip services).

Certifique-se de que o arquivo de backup esteja sendo armazenado em uma pasta com espaço suficiente no Mikrotik (https://github.com/brlink-org/bckp-mikrotik-email-telegram).




# Equipe BrLink.org
