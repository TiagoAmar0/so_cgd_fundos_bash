#!/usr/bin/env bash

# ---------- CONSTANTES


# ---------- FUNÇÕES
# Manual de Utilização do Comando
function ajuda(){
    echo "----- MANUAL DE UTILIZACAO ------"
}

# Descarrega a página 
function descarregarPagina(){
    echo "------ DESCARREGAR PAGINA -------"
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