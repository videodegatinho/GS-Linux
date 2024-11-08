#!/bin/bash

# Verifica se está sendo executado como root
if [ "$(id -u)" -ne 0 ]; then
  echo "Por favor, execute este script como root ou utilizando 'sudo'."
  exit 1
fi

# 01 - Exibindo uma mensagem de boas-vindas ao usuário e mostrando o que o script vai fazer
echo "######################################"
echo "#‧⋆ ✧˚₊‧⋆. ✧˚₊‧⋆‧‧⋆ ✧˚₊‧⋆. ✧˚₊‧⋆‧‧⋆ ✧˚₊‧#"
echo "#⋆. ✧˚₊‧⋆‧‧SEJA BEM-VINDO AO✧˚₊‧⋆. ✧✧#"
echo "#‧⋆ ‧⋆˚₊INSTALADOR DE PACOTES‧⋆ ‧⋆˚₊‧⋆ ‧#"
echo "#‧⋆ ✧˚₊‧⋆. ✧˚₊‧⋆‧‧⋆ ✧˚₊‧⋆. ✧˚₊‧⋆‧‧⋆ ✧˚₊‧#"
echo "######################################"
echo ""
echo "Este script vai realizar as seguintes tarefas: "
echo "   * Atualizar o sistema"
echo "   * Instalar o pacote: apache2"
echo "   * Baixar o seguinte template: https://www.free-css.com/free-css-templates/page291/dozecafe"
echo "   * Configurar o template como site padrão"
echo "   * Inicializar o Apache2"
echo "   * Testar a conexão ao site via porta 80"
echo ""

# 02 - Perguntando ao usuário se ele deseja continuar
read -r -p "Você deseja prosseguir com a execução do script? (s/n): " resposta

# Remover espaços em branco extras da variável resposta
resposta=$(echo "$resposta" | tr -d '[:space:]')

# 03 - Verificando a resposta do usuário
if [[ "$resposta" != "s" && "$resposta" != "S" ]]; then
    echo ""
    echo "> INSTALAÇÃO CANCELADA PELO USUÁRIO."
    exit 1
fi

echo ""
echo "> INICIANDO INSTALAÇÃO DO SCRIPT"

# 04 - Atualizando o sistema
echo "> ATUALIZANDO O SISTEMA"
apt update -y && apt upgrade -y

# 05 - Instalando o Apache
echo "> INSTALANDO O APACHE"
apt install apache2 -y

# Verificando se o Apache foi instalado corretamente
if ! command -v apache2 &> /dev/null; then
    echo "Erro ao instalar o Apache. Verifique sua conexão e tente novamente."
    exit 1
fi

# 06 - Configurando diretório padrão do Apache
APACHE_DIR="/var/www/html"

# Limpando o diretório padrão do Apache (opcional)
rm -rf "$APACHE_DIR"/*

# 07 - Configurando a URL de onde está o template
URL_TEMPLATE="https://www.free-css.com/assets/files/free-css-templates/download/page291/dozecafe.zip"

# 08 - Baixando o template
echo "> BAIXANDO TEMPLATE HTML"
wget -q "$URL_TEMPLATE" -O /tmp/template.zip

# Verificando se o download foi bem-sucedido
if [ ! -f /tmp/template.zip ]; then
    echo "Erro ao baixar o template. Verifique sua conexão."
    exit 1
fi

# 09 - Instalando o unzip (se necessário)
echo "> INSTALANDO O UNZIP"
apt install unzip -y

# 10 - Descompactando o template diretamente no repositório do Apache
echo "> DESCOMPACTANDO O TEMPLATE"
unzip -o /tmp/template.zip -d "$APACHE_DIR"

# Movendo o conteúdo da pasta descompactada para o diretório padrão do Apache (se necessário)
if [ -d "$APACHE_DIR/html" ]; then
    mv "$APACHE_DIR/html/"* "$APACHE_DIR"
    rmdir "$APACHE_DIR/html"
fi

# 11 - Reiniciando o Apache
echo "> REINICIANDO O APACHE"
systemctl restart apache2

# 12 - Verificando se o Apache está rodando
if systemctl status apache2 | grep -q 'active (running)'; then
    echo "> O servidor Apache está rodando!"
    echo "> Acesse o site no navegador através do endereço: http://localhost"
else
    echo "Erro ao iniciar o Apache. Verifique os logs para mais detalhes."
    exit 1
fi

echo ""
echo "######################################"
echo "# INSTALAÇÃO CONCLUÍDA COM SUCESSO!  #"
echo "######################################"
