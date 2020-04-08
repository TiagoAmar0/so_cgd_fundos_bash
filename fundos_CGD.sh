#!/usr/bin/env bash

# ---------- CONSTANTES
CX_ACOES_EUROPA_SOC_RESP="EU"
CX_ACOES_EUA="EUA"
CX_ACOES_PORTUGAL_ESPANHA="PT"
CX_ACOES_ORI="ORI"
CX_ACOES_EMERGENTES="EMER"
CX_ACOES_LIDERES_GLOBAIS="GLOB"
CAIXA_REFORMA_ACTIVA="Reforma"


# ---------- FUNÇÕES
# Manual de Utilização do Comando
function ajuda(){
    echo "$TESTE"
}

# Descarrega a página 
function descarregarPagina(){
    # Data formatada em AnoMesDia
    data="$(date +"%Y%m%d")"
    nome_ficheiro="fundos_CGD_$data.html"
    
    # Descarregar ficheiro para o caminho desejado (fundos_CGD_DATA.html)
    $(wget https://www.cgd.pt/Particulares/Poupanca-Investimento/Fundos-de-Investimento/Pages/CotacoeseRendibilidades.aspx -O $nome_ficheiro)
    
}

function lerFicheiro(){
    echo "------- Ler ficheiro ------"
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
                ajuda
                exit
            ;;
            -i)
                descarregarPagina
            ;;
        esac
    shift
    done
else 
    # Como nao existe parametros, o programa deve extrair dados do ficheiro "fundos_CGD_DATA.html"
    lerFicheiro
fi