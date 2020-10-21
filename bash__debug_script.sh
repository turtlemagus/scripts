thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"

if (( ${#} < 1 ))
then
    >&2 echo
    >&2 echo "Usage: ${thisScriptFileName} <filePath>"
    >&2 echo

    exit 1
fi

filePath="$(echo "${1}" | sed -E "s|~|${HOME}|g")"
if [[ ! -e "${filePath}" ]]
then
    >&2 echo
    >&2 echo "Error: ${thisScriptFileName}: <filePath> '${1}' not found."
    >&2 echo

    exit 1

elif [[ ! -f "${filePath}" ]]
then
    >&2 echo
    >&2 echo "Error: ${thisScriptFileName}: <filePath> '${1}' is not a file."
    >&2 echo

    exit 1
fi

regex_oddNoOfDoubleQuotes='^(([^"]*"){2})*[^"]*"[^"]*$'

echo
noOfLinesInFile=$(grep -c '.*' "${filePath}")
for (( lineNo = 1; lineNo <= noOfLinesInFile; lineNo++ ))
do
    currentLine="$(sed -n "${lineNo}p" "${filePath}")"

    if [[ "${currentLine}" =~ ${regex_oddNoOfDoubleQuotes} ]]
    then
        echo "Line ${lineNo}: Odd number of double quotes:"
        echo "${currentLine}"
        echo
    fi
done


