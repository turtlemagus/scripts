IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

numberList=()
expectedSignList=()

numberList[${#numberList[@]}]=1
expectedSignList[${#expectedSignList[@]}]=1

numberList[${#numberList[@]}]=0
expectedSignList[${#expectedSignList[@]}]=0

numberList[${#numberList[@]}]=-1
expectedSignList[${#expectedSignList[@]}]=-1


numberList[${#numberList[@]}]=10
expectedSignList[${#expectedSignList[@]}]=1

numberList[${#numberList[@]}]=-10
expectedSignList[${#expectedSignList[@]}]=-1

numberList[${#numberList[@]}]=1.5
expectedSignList[${#expectedSignList[@]}]=1

numberList[${#numberList[@]}]=-1.5
expectedSignList[${#expectedSignList[@]}]=-1

numberList[${#numberList[@]}]=1
expectedSignList[${#expectedSignList[@]}]=1

if (( ${#numberList[@]} != ${#expectedSignList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <numberList>: ${#numberList[@]} elements"
    >&2 echo "      <expectedSignList>: ${#expectedSignList[@]} elements"
    >&2 echo

    exit 1
fi

source '../mathFunctions.sh'

testsPassed=0
listLength=${#numberList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    number="${numberList[${index}]}"
    expectedSign="${expectedSignList[${index}]}"

    echo "      number=${number}"
    echo "expectedSign=${expectedSign}"

    actualSign=$(getSign ${number})
    if (( ${actualSign} == ${expectedSign} ))
    then
        echo "  actualSign=${actualSign} (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualSign=${actualSign} (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

