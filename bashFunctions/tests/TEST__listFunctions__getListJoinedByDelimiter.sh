IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

stringList=()
delimiterList=()
expectedStringList=()

listStringList[${#listStringList[@]}]="'one' 'two'"
delimiterList[${#delimiterList[@]}]=','
expectedStringList[${#expectedStringList[@]}]="one,two"

listStringList[${#listStringList[@]}]="'One' 'Two' 'Three' 'Four'"
delimiterList[${#delimiterList[@]}]=''
expectedStringList[${#expectedStringList[@]}]="OneTwoThreeFour"

listStringList[${#listStringList[@]}]="'one' 'two' 'three'"
delimiterList[${#delimiterList[@]}]='XYZ'
expectedStringList[${#expectedStringList[@]}]="oneXYZtwoXYZthree"

if (( ${#listStringList[@]} != ${#delimiterList[@]} )) \
|| (( ${#listStringList[@]} != ${#expectedStringList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "        <listStringList>: ${#listStringList[@]} elements"
    >&2 echo "         <delimiterList>: ${#delimiterList[@]} elements"
    >&2 echo "    <expectedStringList>: ${#expectedStringList[@]} elements"
    >&2 echo

    exit 1
fi

source '../listFunctions.sh'

testsPassed=0
listLength=${#listStringList[@]}
listName='list'
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    listString="${listStringList[${index}]}"
    eval "createList '${listName}' ${listString}"

    delimiter="${delimiterList[${index}]}"
    expectedString="${expectedStringList[${index}]}"

    echo "          list=${listString}"
    echo "     delimiter='${delimiter}'"
    echo "expectedString='${expectedString}'"

    actualString="$(getListJoinedByDelimiter "${delimiter}" "${listName}")"
    if [[ "${actualString}" == "${expectedString}" ]]
    then
        echo "  actualString='${actualString}' (PASS)"
        testsPassed=$((${testsPassed} + 1))
    else
        echo "  actualString='${actualString}' (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo


