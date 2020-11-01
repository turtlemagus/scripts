IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

charList=()
expectedAsciiCodeList=()

charList[${#charList[@]}]='A'
expectedAsciiCodeList[${#expectedAsciiCodeList[@]}]=65

charList[${#charList[@]}]='Z'
expectedAsciiCodeList[${#expectedAsciiCodeList[@]}]=90

charList[${#charList[@]}]='a'
expectedAsciiCodeList[${#expectedAsciiCodeList[@]}]=97

charList[${#charList[@]}]='z'
expectedAsciiCodeList[${#expectedAsciiCodeList[@]}]=122

charList[${#charList[@]}]='"'
expectedAsciiCodeList[${#expectedAsciiCodeList[@]}]=34

charList[${#charList[@]}]='~'
expectedAsciiCodeList[${#expectedAsciiCodeList[@]}]=126


if (( ${#charList[@]} != ${#expectedAsciiCodeList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "                   <charList>: ${#charList[@]} elements"
    >&2 echo "      <expectedAsciiCodeList>: ${#expectedAsciiCodeList[@]} elements"
    >&2 echo

    exit 1
fi

source '../stringFunctions.sh'

testsPassed=0
listLength=${#charList[@]}
echo
echo "BEFORE: LC_CTYPE='${LC_CTYPE}'"
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    char="${charList[${index}]}"
    expectedAsciiCode="${expectedAsciiCodeList[${index}]}"
    actualAsciiCode=$(getAsciiCode "${char}")

    echo "             char='${char}'"
    echo "expectedAsciiCode=${expectedAsciiCode}"

    if (( ${actualAsciiCode} == ${expectedAsciiCode} ))
    then
        echo "  actualAsciiCode=${actualAsciiCode} (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualAsciiCode=${actualAsciiCode} (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "AFTER: LC_CTYPE='${LC_CTYPE}'"
echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

