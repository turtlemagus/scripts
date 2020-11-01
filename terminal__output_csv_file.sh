IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

source './bashFunctions/listFunctions.sh'
source './bashFunctions/fileFunctions.sh'

function copyColumnNamesToList() { # <csvFilePath> <varName_list>
    local csvFilePath="${1}"

    local varName_list="${2}"
    eval "${varName_list}=()"

    local headerRow="$(head -1 "${csvFilePath}" | sed -E "s|$(printf "\r")||g")"
    local noOfFields=$(tr ',' '\n' <<< "${headerRow}" | egrep -c '.*')

    local fieldNo=1
    for (( fieldNo = 1; fieldNo <= noOfFields; fieldNo++ ))
    do
        eval "${varName_list}[\${#${varName_list}[@]}]=\"$(cut -d ',' -f ${fieldNo} <<< "${headerRow}")\""
    done
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

copyColumnNamesToList "${csvFilePath}" 'columnNames'
for (( index = 0; index <= ${#columnNames[@]} - 1; index++ ))
do
    eval "column${index}=()"
    eval "column${index}[0]=\"${columnNames[${index}]}\""
done

isHeaderRow=1
while read -r currentRow
do
    if (( ${isHeaderRow} ))
    then
        isHeaderRow=0
        continue
    fi
    currentRow="$(sed -E "s|$(printf "\r")||g" <<< "${currentRow}")"

    for (( columnIndex = 0; columnIndex <= ${#columnNames[@]} - 1; columnIndex++ ))
    do
        columnName="column${columnIndex}"
        eval "${columnName}[\${#${columnName}[@]}]=\"$(cut -d ',' -f $((columnIndex + 1)) <<< "${currentRow}")\""
    done

done < "${csvFilePath}"

for (( columnIndex = 0; columnIndex <= ${#columnNames[@]} - 1; columnIndex++ ))
do
    eval "justifyElementsInList 'column${columnIndex}'"
done

echo
noOfRows=${#column0[@]}
for (( rowIndex=0; rowIndex <= noOfRows - 1; rowIndex++ ))
do
    rowOutput=''
    for (( columnIndex = 0; columnIndex <= ${#columnNames[@]} - 1; columnIndex++ ))
    do
        eval "rowOutput=\"\${rowOutput}\${column${columnIndex}[${rowIndex}]} | \""
    done
    echo "$(sed -E 's|\| $||g' <<< "${rowOutput}")"
done
echo











