IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

listStringList=()
alignmentList=()
expectedListStringList=()

listStringList[${#listStringList[@]}]='zero, one, two, three'
alignmentList[${#alignmentList[@]}]='LEFT'
expectedListStringList[${#expectedListStringList[@]}]='zero , one  , two  , three'

listStringList[${#listStringList[@]}]='zero, one, two, three'
alignmentList[${#alignmentList[@]}]=''
expectedListStringList[${#expectedListStringList[@]}]='zero , one  , two  , three'

listStringList[${#listStringList[@]}]='zero, one, two, three'
alignmentList[${#alignmentList[@]}]='CENTRE'
expectedListStringList[${#expectedListStringList[@]}]='zero ,  one ,  two , three'

listStringList[${#listStringList[@]}]='zero, one, two, three'
alignmentList[${#alignmentList[@]}]='RIGHT'
expectedListStringList[${#expectedListStringList[@]}]=' zero,   one,   two, three'

if (( ${#listStringList[@]} != ${#alignmentList[@]} )) \
|| (( ${#listStringList[@]} != ${#expectedListStringList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "              <listStringList>: ${#listStringList[@]} elements"
    >&2 echo "               <alignmentList>: ${#alignmentList[@]} elements"
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
    alignment="${alignmentList[${index}]}"
    expectedListString="${expectedListStringList[${index}]}"

    splitStringByDelimiter "${listString}" ', ' 'list'
    splitStringByDelimiter "${expectedListString}" ', ' 'expectedList'

    echo "        list=$(outputList 'list')"
    echo "   alignment='${alignment}'"
    echo
    echo "expectedList=$(outputList 'expectedList')"

    justifyElementsInList 'list' "${alignment}"
    if (( $(getListsAreEqual 'list' 'expectedList') ))
    then
        echo "  actualList=$(outputList 'list') (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualList=$(outputList 'list') (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

