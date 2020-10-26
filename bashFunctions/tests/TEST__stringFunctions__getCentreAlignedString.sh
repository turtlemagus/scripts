IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

targetWidthList=()
stringList=()
expectedStringList=()

targetWidthList[${#targetWidthList[@]}]=5
stringList[${#stringList[@]}]='ABC'
expectedStringList[${#expectedStringList[@]}]=' ABC '

targetWidthList[${#targetWidthList[@]}]=4
stringList[${#stringList[@]}]='ABC'
expectedStringList[${#expectedStringList[@]}]='ABC '

targetWidthList[${#targetWidthList[@]}]=5
stringList[${#stringList[@]}]='ABCDEFGHIJ'
expectedStringList[${#expectedStringList[@]}]='CDEFG'

if (( ${#targetWidthList[@]} != ${#stringList[@]} )) \
|| (( ${#targetWidthList[@]} != ${#expectedStringList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <targetWidthList>: ${#targetWidthList[@]} elements"
    >&2 echo "      <stringList>: ${#stringList[@]} elements"
    >&2 echo "      <expectedStringList>: ${#expectedStringList[@]} elements"
    >&2 echo

    exit 1
fi

source '../stringFunctions.sh'

testsPassed=0
listLength=${#targetWidthList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    targetWidth="${targetWidthList[${index}]}"
    string="${stringList[${index}]}"
    expectedString="${expectedStringList[${index}]}"

    echo "   targetWidth=${targetWidth}"
    echo "        string='${string}'"
    echo "expectedString='${expectedString}'"
    actualString="$(getCentreAlignedString ${targetWidth} "${string}")"
    if [[ "${actualString}" == "${expectedString}" ]]
    then
        echo "  actualString='${actualString}' (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualString='${actualString}' (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

