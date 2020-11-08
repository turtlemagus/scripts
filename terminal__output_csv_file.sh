IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"

source "${thisScriptAbsoluteDirPath}/bashFunctions/fileFunctions.sh"

function getNoOfColumnsInCsvFile() { # <csvFilePath>
    head -1 "${1}" | tr ',' '\n' | grep -c '.*'
}

function getGreatestLengthFromStdin() { # (stdin)
    local greatestLength=0
    while read currentLine
    do
        (( ${#currentLine} > ${greatestLength} )) && greatestLength=${#currentLine}
    done
    echo ${greatestLength}
}

function leftAlignStdin() { # (stdin) <targetLength>
    sed -E -e "s|^(.*)\$|\1$(printf "%${1}s")|g" | cut -c 1-${1}
}

if (( ${#} < 1 ))
then
    >&2 echo
    >&2 echo "Usage: ${thisScriptFileName} <csvFilePath>"
    >&2 echo

    exit 1
fi

csvFilePath="${1}"
validateFilePath 'csvFilePath' || exit 1

greatestLength=$(cut -d ',' -f 1 "${csvFilePath}" | getGreatestLengthFromStdin)
output="$(                                  \
    cut -d ',' -f 1 "${csvFilePath}"        \
        | sed -E "s|$(printf "\r")||g"      \
		| sed '1{G;}'                       \
        | leftAlignStdin ${greatestLength}  \
        | sed -E 's|^(.*)$|\1 |g'           \
)"


noOfColumns=$(getNoOfColumnsInCsvFile "${csvFilePath}")
for (( columnNo=2; columnNo <= 9; columnNo++ ))
do
    greatestLength=$(cut -d ',' -f ${columnNo} "${csvFilePath}" | getGreatestLengthFromStdin)
    output="$(                   \
        paste                    \
            -d '|'               \
            <(echo "${output}")  \
            <(                                               \
                 cut -d ',' -f ${columnNo} "${csvFilePath}"  \
                     | sed -E "s|$(printf "\r")||g"          \
					 | sed '1{G;}'                           \
                     | leftAlignStdin ${greatestLength}      \
                     | sed -E 's|^(.*)$| \1 |g'              \
             )                                               \
    )"
done

echo
echo "${output}" | sed -E -e '2s| |-|g' -e '2s/\|/+/g'
echo



