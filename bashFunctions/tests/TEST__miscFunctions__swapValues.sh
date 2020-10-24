IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

value1List=()
value2List=()
expectedValue1AfterList=()
expectedValue2AfterList=()

value1List[${#value1List[@]}]='TWO'
value2List[${#value2List[@]}]='ONE'
expectedValue1AfterList[${#expectedValue1AfterList[@]}]='ONE'
expectedValue2AfterList[${#expectedValue2AfterList[@]}]='TWO'

value1List[${#value1List[@]}]=2
value2List[${#value2List[@]}]=1
expectedValue1AfterList[${#expectedValue1AfterList[@]}]=1
expectedValue2AfterList[${#expectedValue2AfterList[@]}]=2

value1List[${#value1List[@]}]='With Spaces 2'
value2List[${#value2List[@]}]='With Spaces 1'
expectedValue1AfterList[${#expectedValue1AfterList[@]}]='With Spaces 1'
expectedValue2AfterList[${#expectedValue2AfterList[@]}]='With Spaces 2'


if (( ${#value1List[@]} != ${#value2List[@]} )) \
|| (( ${#value1List[@]} != ${#expectedValue1AfterList[@]} )) \
|| (( ${#value1List[@]} != ${#expectedValue2AfterList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <value1List>: ${#value1List[@]} elements"
    >&2 echo "      <value2List>: ${#value2List[@]} elements"
    >&2 echo "      <expectedValue1AfterList>: ${#expectedValue1AfterList[@]} elements"
    >&2 echo "      <expectedValue2AfterList>: ${#expectedValue2AfterList[@]} elements"
    >&2 echo

    exit 1
fi

source '../miscFunctions.sh'

testsPassed=0
listLength=${#value1List[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    value1="${value1List[${index}]}"
    value2="${value2List[${index}]}"

    actualValue1After="${value1}"
    actualValue2After="${value2}"
    swapValues 'actualValue1After' 'actualValue2After'

    expectedValue1After="${expectedValue1AfterList[${index}]}"
    expectedValue2After="${expectedValue2AfterList[${index}]}"

    echo "             value1='${value1}'"
    echo "             value2='${value2}'"

    echo
    echo "expectedValue1After='${expectedValue1After}'"
    if [[ "${actualValue1After}" == "${expectedValue1After}" ]]
    then
        echo "  actualValue1After='${actualValue1After}' (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualValue1After='${actualValue1After}' (FAIL)"
    fi

    echo
    echo "expectedValue2After='${expectedValue2After}'"
    if [[ "${actualValue2After}" == "${expectedValue2After}" ]]
    then
        echo "  actualValue2After='${actualValue2After}' (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualValue2After='${actualValue2After}' (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / $((${listLength} * 2)) tests."
echo

