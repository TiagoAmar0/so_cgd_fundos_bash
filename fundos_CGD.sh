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

DATA_ATUAL_YMD="$(date +"%Y%m%d")"
DATA_ATUAL_Y_M_D="$(date +"%d-%m-%Y")"
NOME_FICHEIRO="fundos_CGD_$DATA_ATUAL_YMD.html"

CABECALHO_DATA=" data|$DATA_ATUAL_Y_M_D"
CABECALHO="Fundo|data|data-1|12meses|24meses"

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
    # Verifica se o ficheiro existe no diretório atual
    if test -f "$NOME_FICHEIRO"; then
        echo "$CABECALHO_DATA"
        echo "$CABECALHO"

        # Info Cx Ações Europa Soc Resp
        echo $(grep -A7 "$CX_ACOES_EUROPA_SOC_RESP" $NOME_FICHEIRO \
        | sed "s/\b$CX_ACOES_EUROPA_SOC_RESP\b/$CX_ACOES_EUROPA_SOC_RESP_ABREV/g" \
        | tr -d " " \
        | tr -d "\</td\>" \
        | tr -d "\</a\>" \
        | sed 's/\[.\]//g' \
        | tr -d "€" \
        | tr "," "." \
        | sed -r '/^\s*$/d' \
        | tr "\n" "\|" \
        | tr -d "\r")

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