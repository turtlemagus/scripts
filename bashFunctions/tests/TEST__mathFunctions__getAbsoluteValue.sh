IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

numberList=()
expectedNumberList=()

numberList[${#numberList[@]}]=-1
expectedNumberList[${#expectedNumberList[@]}]=1

numberList[${#numberList[@]}]=2
expectedNumberList[${#expectedNumberList[@]}]=2

numberList[${#numberList[@]}]=0
expectedNumberList[${#expectedNumberList[@]}]=0

numberList[${#numberList[@]}]=-4.2
expectedNumberList[${#expectedNumberList[@]}]=4.2

numberList[${#numberList[@]}]=4.8
expectedNumberList[${#expectedNumberList[@]}]=4.8

if (( ${#numberList[@]} != ${#expectedNumberList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <numberList>: ${#numberList[@]} elements"
    >&2 echo "      <expectedNumberList>: ${#expectedNumberList[@]} elements"
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
    myNumber=${numberList[${index}]}
    expectedNumber=${expectedNumberList[${index}]}

    echo "        number=${myNumber}"
    echo "expectedNumber=${expectedNumber}"

    actualNumber=$(getAbsoluteValue ${myNumber})
    if (( $(echo "${actualNumber} == ${expectedNumber}" | bc --mathlib) ))
    then
        echo "  actualNumber=${actualNumber} (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "  actualNumber=${actualNumber} (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

