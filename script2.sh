#!/bin/bash

# 01 - Exibindo uma mensagem de boas-vindas ao usuário e mostrando o que o script vai fazer
echo "######################################"
echo "#‧⋆ ✧˚₊‧⋆. ✧˚₊‧⋆‧‧⋆ ✧˚₊‧⋆. ✧˚₊‧⋆‧‧⋆ ✧˚₊‧#"
echo "#⋆. ✧˚₊‧⋆‧‧SEJA BEM-VINDO AO✧˚₊‧⋆. ✧✧#"
echo "#‧⋆ ‧⋆˚₊INSTALADOR DE PACOTES‧⋆ ‧⋆˚₊‧⋆ ‧#"
echo "#‧⋆ ✧˚₊‧⋆. ✧˚₊‧⋆‧‧⋆ ✧˚₊‧⋆. ✧˚₊‧⋆‧‧⋆ ✧˚₊‧#"
echo "######################################"
echo ""
echo "Este script vai realizar as seguinte tarefas: "
echo "   * atualizar o sistema"
echo "   * instalar o pacote: apache2"
echo "   * baixar o seguinte template: https://www.free-css.com/free-css-templates/page291/dozecafe"
echo "   * configurar o template como site padrão"
echo "   * inicializar o apache2"
echo "   * testar conexão ao site via porta 80"
echo ""

# 02 - Perguntando ao usuário se ele deseja continuar
read -p "Você deseja prosseguir com a execução do script? (s/n): " resposta

# 03 - Verificando a resposta do usuário
if [[ "$resposta" != "s" && "$resposta" != "S" ]]; then
        echo ""
        echo "> INSTALAÇÃO CANCELADA PELO USUÁRIO."
        exit 1
else
        echo ""
        echo "> INICIANDO INSTALAÇÃO DO SCRIPT"

fi

# 04 - Atualizando o sistema
echo "> ATUALIZANDO O SISTEMA"
sudo apt update -y 

# 05 - Instalando o Apache
echo "> INSTALANDO O APACHE"
sudo apt install apache2 -y

# 06 - CONFIGURANDO DIRETÓRIO PADRÃO DO APACHE
APACHE_DIR="/var/www/html"

# 07 - CONFIGURANDO A URL DE ONDE ESTÁ O TEMPLATE
URL_TEMPLATE="https://www.free-css.com/assets/files/free-css-templates/download/page291/dozecafe.zip"

# 08 - Baixando o template:
echo "> BAIXANDO TEMPLATE HTML"
wget -q $URL_TEMPLATE -O /tmp/template.zip

# 09 - INSTALANDO O UNZIP
echo "> INSTALANDO O UNZIP"
sudo apt install unzip -y

# 10 - DESCOMPACTANDO O TEMPLATE DIRETAMENTE NO REPOSITÓRIO DO APACHE
echo "> DESCOMPACTANDO O TEMPLATE"
sudo unzip -o /tmp/template.zip -d $APACHE_DIR

# Quando descompactamos o template.zip, todos os arquivos de do site estão dentro de uma pastinha html
# portanto, é necessário mover o conteúdo do diretório HTML para o diretório padrão do apache2 (/var/www/html)
sudo mv $APACHE_DIR/html/* $APACHE_DIR 

# 11 - REINICIANDO O APACHE:
echo "> REINICIANDO O APACHE"
sudo systemctl restart apache2