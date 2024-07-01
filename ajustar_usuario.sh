#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Uso: $0 [caminho] [lojas|cadastroproduto|notificador|transportefront|transporteback|admin|maislog]"
    exit 1
fi

parametro=$2
caminho=$1
use_credentials=""

# Função para executar o comando em config.php
executar_comando_config() {
    case "$parametro" in
        "lojas" | "notificador" | "crm")
            go run ~/dev/scripts/adjust_user/adjust_user.go local.php "$usuario" "$senha"
            ;;
        "admin" | "transportefront" | "transporteback" | "cadastroproduto")
            go run ~/dev/scripts/adjust_user/adjust_user.go application.ini "$usuario" "$senha"
            ;;
        "maislog")
            go run ~/dev/scripts/adjust_user/adjust_user.go config.local.php "$usuario" "$senha"
            ;;
        *)
            echo "Comando não reconhecido."
            ;;
    esac
}

# Pergunta se deseja usar o arquivo credentials.json
read -p "Deseja utilizar o arquivo credentials.json para autenticação? (y/n): " use_credentials

if [ "$use_credentials" == "y" ]; then
    # Verifica se o arquivo credentials.json existe
    if [ -f "credentials.json" ]; then
        usuario=$(jq -r '.user' credentials.json)
        senha=$(jq -r '.password' credentials.json)
    else
        echo "Arquivo credentials.json não encontrado."
        exit 1
    fi
else
    # Pergunta pelos valores
    read -p "Digite o valor para 'usuario': " usuario
    read -p "Digite o valor para 'senha': " senha
fi

# Verifica se o parâmetro é "lojas" ou "admin"
if [ "$parametro" == "lojas" ] || [ "$parametro" == "admin" ] || [ "$parametro" == "notificador" ]; then
    # Executa o comando para pastas 1, 2, 3, 4 e 5
    for pasta in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 "autoload"; do
        if [ -d $caminho/config/$pasta ]; then
            cd $caminho/config/$pasta || exit 1
            echo "Executando para a pasta $pasta"
            executar_comando_config
            cd - || exit 1
        fi
    done
# TRANSPORTE FRONT-END
elif [ "$parametro" == "transportefront" ] || [ "$parametro" == "cadastroproduto" ]; then
    # Executa o comando apenas para a pasta config
    cd $caminho/application/configs || exit 1
    echo "Executando para a pasta configs"
    executar_comando_config
    cd - || exit 1
# TRANSPORTE BACK-END
elif [ "$parametro" == "transporteback" ]; then
    # Executa o comando apenas para a pasta config
    cd $caminho/config || exit 1
    echo "Executando para a pasta config"
    executar_comando_config
    cd - || exit 1
# MAISLOG
elif [ "$parametro" == "maislog" ]; then
    # Executa o comando apenas para a pasta config
    cd $caminho/application/configs || exit 1
    echo "Executando para a pasta configs"
    executar_comando_config
    cd - || exit 1
else
    echo "Parâmetro inválido. Use [lojas|notificador|cadastroproduto|transportefront|transporteback|admin|maislog|crm]"
    exit 1
fi
