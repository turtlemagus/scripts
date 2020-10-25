IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

searchValueList=()
listStringList=()
expectedValueList=()

searchValueList[${#searchValueList[@]}]='TWO'
listStringList[${#listStringList[@]}]='ZERO, ONE, TWO, TWO'
expectedValueList[${#expectedValueList[@]}]=1

searchValueList[${#searchValueList[@]}]='SAME'
listStringList[${#listStringList[@]}]='SAME, SAME, SAME, SAME'
expectedValueList[${#expectedValueList[@]}]=1

searchValueList[${#searchValueList[@]}]='ELEMENT ONE'
listStringList[${#listStringList[@]}]='ELEMENT ZERO, ELEMENT ONE, ELEMENT TWO, ELEMENT THREE, ELEMENT FOUR'
expectedValueList[${#expectedValueList[@]}]=1

searchValueList[${#searchValueList[@]}]='NO EXISTE'
listStringList[${#listStringList[@]}]='ZERO, ONE, TWO, TWO'
expectedValueList[${#expectedValueList[@]}]=0

if (( ${#searchValueList[@]} != ${#listStringList[@]} )) \
|| (( ${#searchValueList[@]} != ${#expectedValueList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <searchValueList>: ${#searchValueList[@]} elements"
    >&2 echo "      <listStringList>: ${#listStringList[@]} elements"
    >&2 echo "      <expectedValueList>: ${#expectedValueList[@]} elements"
    >&2 echo

    exit 1
fi

source '../listFunctions.sh'

testsPassed=0
listLength=${#searchValueList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    searchValue="${searchValueList[${index}]}"
    listString="${listStringList[${index}]}"
    expectedValue="${expectedValueList[${index}]}"

    echo "  searchValue='${searchValue}'"
    echo "         list={ ${listString} }"
    echo "expectedValue=${expectedValue}"

    splitStringByDelimiter "${listString}" ', ' 'list'
    actualValue=$(getIsInList "${searchValue}" 'list')

    if (( ${actualValue} == ${expectedValue} ))
    then
        echo "  actualValue=${actualValue} (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualValue=${actualValue} (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

