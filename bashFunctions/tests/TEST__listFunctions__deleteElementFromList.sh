IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

listStringList=()
indexList=()
expectedListStringList=()

listStringList[${#listStringList[@]}]='zero,one,two,three,four,five'
indexList[${#indexList[@]}]=3
expectedListStringList[${#expectedListStringList[@]}]='zero,one,two,four,five'

listStringList[${#listStringList[@]}]='zero,one,two,three,four,five'
indexList[${#indexList[@]}]=0
expectedListStringList[${#expectedListStringList[@]}]='one,two,three,four,five'

listStringList[${#listStringList[@]}]='zero,one,two,three,four,five'
indexList[${#indexList[@]}]=5
expectedListStringList[${#expectedListStringList[@]}]='zero,one,two,three,four'

listStringList[${#listStringList[@]}]='zero,one,two,three,four,five'
indexList[${#indexList[@]}]=6
expectedListStringList[${#expectedListStringList[@]}]='zero,one,two,three,four,five'

if (( ${#listStringList[@]} != ${#indexList[@]} )) \
|| (( ${#listStringList[@]} != ${#expectedListStringList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <listStringList>: ${#listStringList[@]} elements"
    >&2 echo "      <indexList>: ${#indexList[@]} elements"
    >&2 echo "      <expectedListStringList>: ${#expectedListStringList[@]} elements"
    >&2 echo

    exit 1
fi

source '../listFunctions.sh'

testsPassed=0
listLength=${#listStringList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    listString="${listStringList[${index}]}"
    deleteIndex="${indexList[${index}]}"
    expectedListString="${expectedListStringList[${index}]}"

    splitStringByDelimiter "${listString}" ',' 'list'
    splitStringByDelimiter "${expectedListString}" ',' 'expectedList'
    deleteElementFromList ${deleteIndex} 'list'

    echo "        startList=${listString}"
    echo "            index=${deleteIndex}"
    echo "expectedListAfter=${expectedListString}"

    if (( $(getListsAreEqual 'list' 'expectedList') ))
    then
        echo "  actualListAfter=$(getListJoinedByDelimiter ',' 'list') (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualListAfter=$(getListJoinedByDelimiter ',' 'list') (FAIL)"
    fi
    echo "      lengthAfter=${#list[@]}"

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

