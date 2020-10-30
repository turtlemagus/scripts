function compareNumbers() { # <number1> <number2>
    local thisFileDirPath="$(dirname "${BASH_SOURCE[0]}")"
    source "${thisFileDirPath}/mathFunctions.sh"

    getSign $(echo "${1} - ${2}" | bc --mathlib)
}

function compareStrings() { # <string1> <string2>
    local string1="${1}"
    local string2="${2}"

    if [[ "${string1}" < "${string2}" ]]
    then
        echo '-1'
    elif [[ "${string1}" > "${string2}" ]]
    then
        echo '1'
    else
        echo '0'
    fi
}

function compareStringLengths() { # <string1> <string2>
    local string1="${1}"
    local string2="${2}"

    compareNumbers "${#string1}" "${#string2}"
}

