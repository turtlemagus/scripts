IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

insertIndexList=()
insertValueList=()
listStringList=()
expectedListStringList=()

insertIndexList[${#insertIndexList[@]}]=3
insertValueList[${#insertValueList[@]}]='two-point-five'
listStringList[${#listStringList[@]}]='zero, one, two, three'
expectedListStringList[${#expectedListStringList[@]}]='zero, one, two, two-point-five, three'

insertIndexList[${#insertIndexList[@]}]=0
insertValueList[${#insertValueList[@]}]='negative-zero-point-five'
listStringList[${#listStringList[@]}]='zero, one, two'
expectedListStringList[${#expectedListStringList[@]}]='negative-zero-point-five, zero, one, two'

insertIndexList[${#insertIndexList[@]}]=4
insertValueList[${#insertValueList[@]}]='out-of-range'
listStringList[${#listStringList[@]}]='zero, one, two'
expectedListStringList[${#expectedListStringList[@]}]='zero, one, two'

insertIndexList[${#insertIndexList[@]}]=3
insertValueList[${#insertValueList[@]}]='just-in-range'
listStringList[${#listStringList[@]}]='zero, one, two'
expectedListStringList[${#expectedListStringList[@]}]='zero, one, two, just-in-range'

if (( ${#insertIndexList[@]} != ${#insertValueList[@]} )) \
|| (( ${#insertIndexList[@]} != ${#listStringList[@]} )) \
|| (( ${#insertIndexList[@]} != ${#expectedListStringList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <insertIndexList>: ${#insertIndexList[@]} elements"
    >&2 echo "      <insertValueList>: ${#insertValueList[@]} elements"
    >&2 echo "      <listStringList>: ${#listStringList[@]} elements"
    >&2 echo "      <expectedListStringList>: ${#expectedListStringList[@]} elements"
    >&2 echo

    exit 1
fi

source '../listFunctions.sh'

testsPassed=0
listLength=${#insertIndexList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    insertIndex="${insertIndexList[${index}]}"
    insertValue="${insertValueList[${index}]}"

    listString="${listStringList[${index}]}"
    splitStringByDelimiter "${listString}" ', ' 'list'

    expectedListString="${expectedListStringList[${index}]}"
    splitStringByDelimiter "${expectedListString}" ', ' 'expectedList'

    echo " insertIndex=${insertIndex}"
    echo " insertValue='${insertValue}'"
    echo "        list={ ${listString} }"
    echo "expectedList={ ${expectedListString} }"

    insertElementIntoList ${insertIndex} "${insertValue}" 'list'
    actualListString="$(getListJoinedByDelimiter ', ' list)"
    if (( $(getListsAreEqual 'list' 'expectedList' ) ))
    then
        echo "  actualList={ ${actualListString} } (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualList={ ${actualListString} } (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

