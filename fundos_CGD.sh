#!/usr/bin/env bash

# ---------- CONSTANTS
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

STUDENT_1_NAME="Ricardo José Ramalhete Ribeiro"
STUDENT_2_NAME="Tiago Amaro Reis Jorge"
STUDENT_1_NUMBER="2191261"
STUDENT_2_NUMBER="2191236"

CURRENT_DATE_YMD="$(date +"%Y%m%d")"
ACTUAL_DATE_D_M_Y="$(date +"%d-%m-%Y")"

HTML_FILENAME="fundos_CGD_$CURRENT_DATE_YMD.html"

TABLE_DATE_HEADER=" data|$ACTUAL_DATE_D_M_Y"
TABLE_HEADER="Fundo|data|data-1|12meses|24meses"

ARCHIVE_DIRECTORY_PATHNAME="ARQUIVO"

# Simulation of a bidimensional array with 7 rows and 2 columns
# This array contains the funds titles and the correspondings abreviations in order to make the script dynamic at the extraction of the .html file
# Info taken from the book "The Linux Command Line, William E. Shotts, Jr. (creative common license - http://linuxcommand.org/tlcl.php), 2019"
ABREVIATIONS_ARRAY=(
    ["11"]=$CX_ACOES_EUROPA_SOC_RESP ["12"]=$CX_ACOES_EUROPA_SOC_RESP_ABREV 
    ["21"]=$CX_ACOES_EUA ["22"]=$CX_ACOES_EUA_ABREV 
    ["31"]=$CX_ACOES_PORTUGAL_ESPANHA ["32"]=$CX_ACOES_PORTUGAL_ESPANHA_ABREV 
    ["41"]=$CX_ACOES_ORI ["42"]=$CX_ACOES_ORI_ABREV 
    ["51"]=$CX_ACOES_EMERGENTES ["52"]=$CX_ACOES_EMERGENTES_ABREV 
    ["61"]=$CX_ACOES_LIDERES_GLOBAIS ["62"]=$CX_ACOES_LIDERES_GLOBAIS_ABREV 
    ["71"]=$CAIXA_REFORMA_ACTIVA ["72"]=$CAIXA_REFORMA_ACTIVA_ABREV)

# Total number of entries of the array. We divide by two to get the number of "rows"
# Info taken from the book "The Linux Command Line, William E. Shotts, Jr. (creative common license - http://linuxcommand.org/tlcl.php), 2019"
NUMBER_OF_ROWS=${#ABREVIATIONS_ARRAY[@]}/2

# ---------- FUNCTIONS
# Function that writes the information about the command
# Executed when the user types the [-h] parameter 
function commandHelp(){
    echo "NAME"
    echo -e " - fundos_CGD.sh - Extrai informação acerca das cotações da página da CGD" 
    echo -e "\nSYNOPSIS"
    echo -e " - ./fundos_CGD.sh [OPTION]"
    echo -e "\nDESCRIPTION"
    echo -e "- Interpreta o ficheiro 'fundos_CGD_<DATA>.html' e mostra a informação das cotações tal como guarda a cotação diária em ficheiros .dat."
    echo -e "\nOpção -i"
    echo -e " - Descarrega a página web para um ficheiro .html. O ficheiro é descarregado para o diretório do script e tem o nome de 'fundos_CGD_<DATA>.html'. A data está no formato YYYYMMDD"
    echo -e "\nOpção -h"
    echo -e " - Mostra o manual de ajuda do script"
    echo -e "\nAUTHOR"
    echo -e " - Desenvolvido por Tiago Amaro Reis Jorge e Ricardo José Ramalhete Ribeiro."

}

# Function that downloads the content of the page to an html file
# Executed when the user types the [-i] parameter 
# The HTML file follows this specified format "fundos_CGD_<CURRENT_DATE>.html" where current date is in YYYYMMDD format
function downloadHTMLFile(){
    $(wget https://www.cgd.pt/Particulares/Poupanca-Investimento/Fundos-de-Investimento/Pages/CotacoeseRendibilidades.aspx -O $HTML_FILENAME)   
}

# Function that checks if the HTML file exists at the current directory
# If HTML exists, displays funds informations on the screen and extracts the daily cotation to .dat file in "ARQUIVO" directory
# Executed when the user types the command without parameters
function extractFileInformations(){
    i=0
    # Verifies if the HTML file exists. If not, send error to the screen
    if test -f "$HTML_FILENAME"; then

        # Writes the table header
        echo "$TABLE_DATE_HEADER"
        echo "$TABLE_HEADER"

        # Checks if "ARQUIVO" directory is created. If not, creates the directory
        if test ! -d "$ARCHIVE_DIRECTORY_PATHNAME"; then
            mkdir "$ARCHIVE_DIRECTORY_PATHNAME"
        fi

        # "Loops" the abbreviations array and extracts dynamically the information of each fund 
        for ((i=1; i<=$NUMBER_OF_ROWS; i++)); do

            # Generates the name of each fund .dat file
            dat_filename="$ARCHIVE_DIRECTORY_PATHNAME/${ABREVIATIONS_ARRAY["${i}2"]}.dat"
            
            # Verifies if the .dat file exists
            # If not, creates the file and write the information about the authors and the timestamp of the creation
            if test ! -f "$dat_filename"; then
                actual_datetime="$(date +"%d.%m.%Y_%Hh:%M:%S")"
                echo "# Dados para o fundo ${ABREVIATIONS_ARRAY["${i}2"]}" > $dat_filename
                echo "# $STUDENT_1_NAME/$STUDENT_1_NUMBER" >> $dat_filename
                echo "# $STUDENT_2_NAME/$STUDENT_2_NUMBER" >> $dat_filename
                echo "# Criado: $actual_datetime" >> $dat_filename
            fi
   
            # Extracts the information of the current fund to a variable
            # We opted to extract to a variable instead of printing right away because we need to extract the daily cotation to enter in the file
            text=$(grep -A7 "${ABREVIATIONS_ARRAY["${i}1"]}" $HTML_FILENAME | sed "s/\b${ABREVIATIONS_ARRAY["${i}1"]}\b/${ABREVIATIONS_ARRAY["${i}2"]}/g" | tr -d " " | sed "s/<[^>]\+>//g" | sed 's/\[.\]//g' | tr -d "€" | tr "," "." | sed -r '/^\s*$/d' | tr "\n" "\|" | tr -d "\r")

            # Print table row
            echo $text

            # Reads the fund .dat file and searches for current date entries. returns the number of lines
            fond_rows=$(grep -o "$ACTUAL_DATE_D_M_Y" $dat_filename | wc -l)
            
            # Only appends to .dat file if there are no entries with the current date
            if (($fond_rows == 0)); then
                # Append daily cotation to the .dat file
                echo "$ACTUAL_DATE_D_M_Y:$(echo $text | tr "|" "\n\r" | head -n 2 | tail -n 1)" >> $dat_filename   
            fi

        done

    else 
        # Show error
        echo "[ERRO]: ficheiro ‘$HTML_FILENAME’ não encontrado no diretório local."
    fi
}


# ---------- MAIN SCRIPT

# Verify if user inserted any argument alongside the command 
# $0 -> path of the executed command
# $# -> number of arguments inserted on the shell

if (($# > 0)); then
    # There are parameters inserted 
    # We use a switch case to find out what parameter(s) was(were) inserted
    while [[ -n $1 ]]; do
        case "$1" in 
            -h)
                # Call to a function to show command help
                commandHelp
                exit
            ;;
            -i)
                # Call to a function to download the HTML file
                downloadHTMLFile
            ;;
            *)
                # Shows error because it was inserted a invalid parameter
                echo "[ERRO]: \"./fundos_CGD.sh $1\". Parâmetro inválido."
                exit
            ;;
        esac
    shift
    done
else 
    # Call to a function to extract data from the HTML file
    extractFileInformations
fi