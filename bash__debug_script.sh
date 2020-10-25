thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"

source "${thisScriptRelativeDirPath}/bashFunctions/fileFunctions.sh"

if (( ${#} < 1 ))
then
    >&2 echo
    >&2 echo "Usage: ${thisScriptFileName} <filePath>"
    >&2 echo

    exit 1
fi
filePath="$(echo "${1}" | sed -E "s|~|${HOME}|g")"
validateFilePath 'filePath' || exit 1

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
