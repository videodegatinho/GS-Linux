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

#SISTEMA OPERACIONAL 

# 03 - Validando sistema operacional
operational_system=$(cat /etc/os-release | grep 'NAME="Debian GNU/Linux"' | cut -d '"' -f2) # Essa linha vai retornar: Debian GNU/Linux, caso o sistema seja Debian
# O cut é uma ferramenta de "corte" do linux, de maneira simples, estamos basicamente filtrando o que queremos pegar de forma direta.
# ao executar o grep ele nos retorna: NAME="Debian GNU/Linux"
# o cut -d'"' -f2 divide a frase toda a partir das aspas duplas, logo o:
# -f1 retorna NAME
# -f2 retorna Debian GNU/Linux
# -f3 retorna nada.


echo "" # Pulando uma linha para facilitar o log

# Nessa linha, valida se o sistema operacional é o Debian, se for o programa continua executando, senão for, o programa encerra automaticamente (exit 1
if [[ "$operational_system" == 'Debian GNU/Linux' ]]; then
        echo "> SISTEMA OPERACIONAL: ok"
else
        echo "> SISTEMA OPERACIONAL: Sistema não corresponde ao requisito (Debian)"
        echo "> Parando o script..."
        exit 1
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