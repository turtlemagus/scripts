IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

searchValueList=()
listStringList=()
expectedIndexList=()

searchValueList[${#searchValueList[@]}]='TWO'
listStringList[${#listStringList[@]}]='ZERO, ONE, TWO, TWO'
expectedIndexList[${#expectedIndexList[@]}]=2

searchValueList[${#searchValueList[@]}]='SAME'
listStringList[${#listStringList[@]}]='SAME, SAME, SAME, SAME'
expectedIndexList[${#expectedIndexList[@]}]=0

searchValueList[${#searchValueList[@]}]='ELEMENT ONE'
listStringList[${#listStringList[@]}]='ELEMENT ZERO, ELEMENT ONE, ELEMENT TWO, ELEMENT THREE, ELEMENT FOUR'
expectedIndexList[${#expectedIndexList[@]}]=1

searchValueList[${#searchValueList[@]}]='NO EXISTE'
listStringList[${#listStringList[@]}]='ZERO, ONE, TWO, TWO'
expectedIndexList[${#expectedIndexList[@]}]=-1

if (( ${#searchValueList[@]} != ${#listStringList[@]} )) \
|| (( ${#searchValueList[@]} != ${#expectedIndexList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <searchValueList>: ${#searchValueList[@]} elements"
    >&2 echo "      <listStringList>: ${#listStringList[@]} elements"
    >&2 echo "      <expectedIndexList>: ${#expectedIndexList[@]} elements"
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
    expectedIndex="${expectedIndexList[${index}]}"

    echo "  searchValue='${searchValue}'"
    echo "         list={ ${listString} }"
    echo "expectedIndex=${expectedIndex}"

    splitStringByDelimiter "${listString}" ', ' 'list'
    actualIndex=$(getFirstIndexInList "${searchValue}" 'list')

    if (( ${actualIndex} == ${expectedIndex} ))
    then
        echo "  actualIndex=${actualIndex} (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualIndex=${actualIndex} (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

