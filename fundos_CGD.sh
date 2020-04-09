#!/usr/bin/env bash

# ---------- CONSTANTES
CX_ACOES_EUROPA_SOC_RESP="Cx Ações Europa Soc Resp"
CX_ACOES_EUROPA_SOC_RESP_ABREV="EU"
CX_ACOES_EUA="Cx Ações EUA"
CX_ACOES_EUA_ABREV="EUA"
CX_ACOES_PORTUGAL_ESPANHA="Cx Ações Portugal Espanha"
CX_ACOES_PORTUGAL_ESPANHA_ABREV="PT"
CX_ACOES_ORI="Cx Ações Oriente"
CX_ACOES_ORI_ABREV="ORI"
CX_ACOES_EMERGENTES="Cxg Ações Emergentes"
CX_ACOES_EMERGENTES_ABREV="EMER"
CX_ACOES_LIDERES_GLOBAIS="Cx Ações Líderes Globais"
CX_ACOES_LIDERES_GLOBAIS_ABREV="GLOB"
CAIXA_REFORMA_ACTIVA="Caixa Reforma Activa"
CAIXA_REFORMA_ACTIVA_ABREV="Reforma"

NOME_ESTUDANTE_1="Ricardo José Ramalhete Ribeiro"
NOME_ESTUDANTE_2="Tiago Amaro Reis Jorge"
NUMERO_ESTUDANTE_1="2191261"
NUMERO_ESTUDANTE_2="2191236"

DATA_ATUAL_YMD="$(date +"%Y%m%d")"
DATA_ATUAL_Y_M_D="$(date +"%d-%m-%Y")"
NOME_FICHEIRO="fundos_CGD_$DATA_ATUAL_YMD.html"

CABECALHO_DATA=" data|$DATA_ATUAL_Y_M_D"
CABECALHO="Fundo|data|data-1|12meses|24meses"

CAMINHO_DIRETORIO_ARQUIVO="ARQUIVO"

ARRAY_SIGLAS=(
    ["11"]=$CX_ACOES_EUROPA_SOC_RESP ["12"]=$CX_ACOES_EUROPA_SOC_RESP_ABREV 
    ["21"]=$CX_ACOES_EUA ["22"]=$CX_ACOES_EUA_ABREV 
    ["31"]=$CX_ACOES_PORTUGAL_ESPANHA ["32"]=$CX_ACOES_PORTUGAL_ESPANHA_ABREV 
    ["41"]=$CX_ACOES_ORI ["42"]=$CX_ACOES_ORI_ABREV 
    ["51"]=$CX_ACOES_EMERGENTES ["52"]=$CX_ACOES_EMERGENTES_ABREV 
    ["61"]=$CX_ACOES_LIDERES_GLOBAIS ["62"]=$CX_ACOES_LIDERES_GLOBAIS_ABREV 
    ["71"]=$CAIXA_REFORMA_ACTIVA ["72"]=$CAIXA_REFORMA_ACTIVA_ABREV)

NUMERO_ENTRADAS=${#ARRAY_SIGLAS[@]}/2

# ---------- FUNÇÕES
# Manual de Utilização do Comando
function ajuda(){
    echo "_HELP_"
}

# Descarrega a página 
function descarregarPagina(){
    # Descarregar ficheiro para o caminho desejado (fundos_CGD_DATA.html)
    $(wget https://www.cgd.pt/Particulares/Poupanca-Investimento/Fundos-de-Investimento/Pages/CotacoeseRendibilidades.aspx -O $NOME_FICHEIRO)
    
}

function lerFicheiro(){
    i=0
    # Verifica se o ficheiro existe no diretório atual
    if test -f "$NOME_FICHEIRO"; then
        echo "$CABECALHO_DATA"
        echo "$CABECALHO"

        # Checks if "ARQUIVO" directory is created. If not, creates the directory
        if test ! -d "$CAMINHO_DIRETORIO_ARQUIVO"; then
            mkdir "$CAMINHO_DIRETORIO_ARQUIVO"
        fi

        for ((i=1; i<=$NUMERO_ENTRADAS; i++)); do

            dat_filename="$CAMINHO_DIRETORIO_ARQUIVO/${ARRAY_SIGLAS["${i}2"]}.dat"
            
            if test ! -f "$dat_filename"; then
                actual_datetime="$(date +"%d.%m.%Y_%Hh:%M:%S")"
                touch "$dat_filename"

                echo "# Dados para o fundo ${ARRAY_SIGLAS["${i}2"]}" > $dat_filename
                echo "# $NOME_ESTUDANTE_1/$NUMERO_ESTUDANTE_1" >> $dat_filename
                echo "# $NOME_ESTUDANTE_2/$NUMERO_ESTUDANTE_2" >> $dat_filename
                echo "# Criado: $actual_datetime" >> $dat_filename
            fi
   

# TODO: ESCREVER NO FICHEIRO E NA BASH AO MESMO TEMPO
            echo $(grep -A7 "${ARRAY_SIGLAS["${i}1"]}" $NOME_FICHEIRO \
            | sed "s/\b${ARRAY_SIGLAS["${i}1"]}\b/${ARRAY_SIGLAS["${i}2"]}/g" \
            | tr -d " " \
            | sed "s/<[^>]\+>//g" \
            | sed 's/\[.\]//g' \
            | tr -d "€" \
            | tr "," "." \
            | sed -r '/^\s*$/d' \
            | tr "\n" "\|" \
            | tr -d "\r") | tr "\|" "\n\r" | head -n 2 | tail -n 1 > teste.txt
        
        
        done

    else 
        echo "$NOME_FICHEIRO não existe"
    fi
}


# ---------- MAIN SCRIPT

# Determinar se o numero de argumentos é superior a 1 
# $0 -> caminho do programa a executar

# $# -> numero de argumentos inseridos na bash
if (($# > 0)); then
    # Foram inseridos parâmetros adicionais ao programa
    # Com o case verifica-se qual o parametro inserido
    while [[ -n $1 ]]; do
        case "$1" in 
            -h)
                # Mostrar texto de ajuda do comando
                ajuda
                exit
            ;;
            -i)
                # Descarregar a página web para o ficheiro fundos_CGD_DATA.html
                descarregarPagina
            ;;
            *)
                # Mostrar erro pois o parâmetro inserido é inválido
                echo "\"./fundos_CGD.sh $1\" Parâmetro inválido."
                exit
            ;;
        esac
    shift
    done
else 
    # Como nao existe parametros, o programa deve extrair dados do ficheiro "fundos_CGD_DATA.html"
    lerFicheiro
fi