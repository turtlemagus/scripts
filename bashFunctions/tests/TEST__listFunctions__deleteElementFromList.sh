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

listStringList[${#listStringList[@]}]=''
indexList[${#indexList[@]}]=''
expectedListStringList[${#expectedListStringList[@]}]=''


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
    index="${indexList[${index}]}"
    expectedListString="${expectedListStringList[${index}]}"
    # TODO: run test function deleteElementFromList

    echo "listString='${listString}'"
    echo "index='${index}'"
    echo "expectedListString='${expectedListString}'"
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # TODO: Replace below placeholder code...!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if (( 1 == 1 ))
    then
        echo "     actualList='TODO' (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "     actualList='TODO' (FAIL)"
    fi
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

