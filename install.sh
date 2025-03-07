#!/bin/bash

URL do repositório no GitHub ou servidor local

REPO_URL="https://raw.githubusercontent.com/SEU-USUARIO/meu-gerenciador/main" LOCAL_REPO="http://localhost:8080" INSTALL_DIR="/data/data/com.termux/files/usr/bin" MANIFEST_URL="$REPO_URL/packages.json"

list_packages() { echo "📦 Pacotes disponíveis:" curl -s $MANIFEST_URL | jq -r 'keys[]' }

install_package() { PACKAGE=$1 echo "🔍 Buscando $PACKAGE..." URL=$(curl -s $MANIFEST_URL | jq -r ".${PACKAGE}.url")

if [ "$URL" == "null" ]; then
    echo "❌ Pacote não encontrado no repositório online!"
    echo "Tentando instalar do repositório local..."
    URL="$LOCAL_REPO/${PACKAGE}.tar.gz"
fi

echo "⬇️ Baixando $PACKAGE..."
curl -O $URL
tar -xzf "$(basename $URL)" -C $INSTALL_DIR
echo "✅ Instalação concluída!"

}

remove_package() { PACKAGE=$1 FILE_PATH="$INSTALL_DIR/$PACKAGE"

if [ -f "$FILE_PATH" ]; then
    rm -f "$FILE_PATH"
    echo "🗑️ Pacote $PACKAGE removido!"
else
    echo "❌ Pacote não encontrado!"
fi

}

package_info() { PACKAGE=$1 echo "🔍 Informações sobre $PACKAGE:" curl -s $MANIFEST_URL | jq ".${PACKAGE}" }

case "$1" in list) list_packages ;; install) install_package "$2" ;; remove) remove_package "$2" ;; info) package_info "$2" ;; *) echo "Uso: $0 {list|install <pacote>|remove <pacote>|info <pacote>}" ;; esac

