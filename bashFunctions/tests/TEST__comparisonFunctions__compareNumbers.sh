IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

number1List=()
number2List=()
expectedOutputList=()

number1List[${#number1List[@]}]=5
number2List[${#number2List[@]}]=1
expectedOutputList[${#expectedOutputList[@]}]=1

number1List[${#number1List[@]}]=1
number2List[${#number2List[@]}]=5
expectedOutputList[${#expectedOutputList[@]}]=-1

number1List[${#number1List[@]}]=3
number2List[${#number2List[@]}]=3
expectedOutputList[${#expectedOutputList[@]}]=0

number1List[${#number1List[@]}]=5.1
number2List[${#number2List[@]}]=1.5
expectedOutputList[${#expectedOutputList[@]}]=1

number1List[${#number1List[@]}]=1.2
number2List[${#number2List[@]}]=5.3
expectedOutputList[${#expectedOutputList[@]}]=-1

number1List[${#number1List[@]}]=3.2
number2List[${#number2List[@]}]=3.2
expectedOutputList[${#expectedOutputList[@]}]=0

if (( ${#number1List[@]} != ${#number2List[@]} )) \
|| (( ${#number1List[@]} != ${#expectedOutputList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <number1List>: ${#number1List[@]} elements"
    >&2 echo "      <number2List>: ${#number2List[@]} elements"
    >&2 echo "      <expectedOutputList>: ${#expectedOutputList[@]} elements"
    >&2 echo

    exit 1
fi

source '../comparisonFunctions.sh'

testsPassed=0
listLength=${#number1List[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    number1="${number1List[${index}]}"
    number2="${number2List[${index}]}"
    expectedOutput="${expectedOutputList[${index}]}"
    actualOutput=$(compareNumbers "${number1}" "${number2}")

    echo "       number1=${number1}"
    echo "       number2=${number2}"
    echo "expectedOutput=${expectedOutput}"
    if (( ${actualOutput} == ${expectedOutput} ))
    then
        echo "  actualOutput=${actualOutput} (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualOutput=${actualOutput} (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

