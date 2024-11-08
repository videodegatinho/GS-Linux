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
read -r -p "Você deseja prosseguir com a execução do script? (s/n): " resposta

# Remover espaços em branco extras da variável resposta
resposta=$(echo "$resposta" | tr -d '[:space:]')

# 03 - Verificando a resposta do usuário
if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
    echo ""
    echo "> INICIANDO INSTALAÇÃO DO SCRIPT"
else
    echo ""
    echo "> INSTALAÇÃO CANCELADA PELO USUÁRIO."
    exit 1
fi

# 04 - Atualizando o sistema
echo "> ATUALIZANDO O SISTEMA"
apt update -y

# 05 - Instalando o Apache
echo "> INSTALANDO O APACHE"
apt install apache2 -y

# 06 - Configurando diretório padrão do Apache
APACHE_DIR="/var/www/html"

# 07 - Configurando a URL de onde está o template
URL_TEMPLATE="https://www.free-css.com/assets/files/free-css-templates/download/page291/dozecafe.zip"

# 08 - Baixando o template
echo "> BAIXANDO TEMPLATE HTML"
wget -q "$URL_TEMPLATE" -O /tmp/template.zip

# 09 - Instalando o unzip
echo "> INSTALANDO O UNZIP"
apt install unzip -y

# 10 - Descompactando o template diretamente no repositório do Apache
echo "> DESCOMPACTANDO O TEMPLATE"
unzip -o /tmp/template.zip -d "$APACHE_DIR"

# Movendo o conteúdo da pasta descompactada para o diretório padrão do Apache
mv "$APACHE_DIR/html/"* "$APACHE_DIR"

# 11 - Reiniciando o Apache
echo "> REINICIANDO O APACHE"
systemctl restart apache2
