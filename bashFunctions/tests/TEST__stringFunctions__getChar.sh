IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

asciiCodeList=()
expectedCharList=()

asciiCodeList[${#asciiCodeList[@]}]=65
expectedCharList[${#expectedCharList[@]}]='A'

asciiCodeList[${#asciiCodeList[@]}]=90
expectedCharList[${#expectedCharList[@]}]='Z'

asciiCodeList[${#asciiCodeList[@]}]=97
expectedCharList[${#expectedCharList[@]}]='a'

asciiCodeList[${#asciiCodeList[@]}]=122
expectedCharList[${#expectedCharList[@]}]='z'

asciiCodeList[${#asciiCodeList[@]}]=34
expectedCharList[${#expectedCharList[@]}]='"'

asciiCodeList[${#asciiCodeList[@]}]=126
expectedCharList[${#expectedCharList[@]}]='~'

if (( ${#asciiCodeList[@]} != ${#expectedCharList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "         <asciiCodeList>: ${#asciiCodeList[@]} elements"
    >&2 echo "      <expectedCharList>: ${#expectedCharList[@]} elements"
    >&2 echo

    exit 1
fi

source '../stringFunctions.sh'

testsPassed=0
listLength=${#asciiCodeList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    asciiCode="${asciiCodeList[${index}]}"
    expectedChar="${expectedCharList[${index}]}"
    actualChar="$(getChar ${asciiCode})"

    echo "   asciiCode=${asciiCode}"
    echo "expectedChar='${expectedChar}'"
    if [[ "${actualChar}" == "${expectedChar}" ]]
    then
        echo "  actualChar='${actualChar}' (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualChar='${actualChar}' (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

