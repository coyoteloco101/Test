#!/bin/bash

# AUTHOR Paul Espin --> CoyoteLoco101

#BANNER
#echo -e "${turcoColour} $(printerbanner -w 40 101) ${endColour}"

#COLORES 
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turcoColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
  
trap ctrl_c INT

#FUNCION DE SALIDA AL PRESIONAR CTRL_C
function ctrl_c(){
	echo -e "\n${redColour}[!] Saliendo..... \n${endColour}"
	#exit 0
	tput cnorm exit 1
}

#sleep 10

function helpPanel(){
	echo -e "\n${redColour}[!] Uso de Script ./${endColour}"
	for i in $(seq 1 80); do echo -ne "${redColour}-"; done; echo -e "${endColour}"
	echo -e "\n\n${grayColour}\t[-a]${endColour}${yellowColour} Buscar por Nombre de App ${endColour}"

	tput cnorm; exit 1
}

########################### TABLA
function printTable(){

    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"
    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]
    then
        local -r numberOfLines="$(wc -l <<< "${data}")"
        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1
            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${data}")"
                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"
                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
                table="${table}\n"
                local j=1
                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done
                table="${table}#|\n"
                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done
            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
            fi
        fi
    fi
}

function removeEmptyLines(){
    local -r content="${1}"
    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString(){
    local -r string="${1}"
    local -r numberToRepeat="${2}"
    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString(){
    local -r string="${1}"
    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi
    echo 'false' && return 1
}

function trimString(){
    local -r string="${1}"
    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}

########################### FIN TABLA

function findApp(){
	number_output=$1
	echo ''> fa.tmp
	#echo -e "hola"
	while ["$(cat) fa.tmp | wc -l |" == "1"]; do
		#cat /var/log/syslog | grep "youtube" 
		grep "youtube" /var/log/syslog | awk '{print $1}' > fa.tmp
	done 

	echo "Mes" > fa.table
}


parameter_counter=0

while getopts "a:h:" arg; do
	case $arg in 
		a) findApp=$OPTARG; let parameter_counter+=1;;
		h) helpPanel=$OPTARG; let parameter_counter+=1;;

	esac
done

#number_output = 100

if [$parameter_counter -eq 0]
 then
	helpPanel
fi
#else
#    echo -e "else"
#	findApp $number_output
#fi



#contador=0

#while read line ; do
	#echo "Linea $contador : $line" | awk '{print $2}'
#	echo "Linea $contador : $line"
#	let contador+=1
#done  < /etc/passwd
