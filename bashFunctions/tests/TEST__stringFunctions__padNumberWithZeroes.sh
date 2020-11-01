IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

targetNoOfCharsList=()
numberList=()
expectedOutputList=()

targetNoOfCharsList[${#targetNoOfCharsList[@]}]=3
numberList[${#numberList[@]}]=1
expectedOutputList[${#expectedOutputList[@]}]='001'

targetNoOfCharsList[${#targetNoOfCharsList[@]}]=3
numberList[${#numberList[@]}]=20
expectedOutputList[${#expectedOutputList[@]}]='020'

targetNoOfCharsList[${#targetNoOfCharsList[@]}]=3
numberList[${#numberList[@]}]=300
expectedOutputList[${#expectedOutputList[@]}]='300'

targetNoOfCharsList[${#targetNoOfCharsList[@]}]=4
numberList[${#numberList[@]}]=400
expectedOutputList[${#expectedOutputList[@]}]='0400'



if (( ${#targetNoOfCharsList[@]} != ${#numberList[@]} )) \
|| (( ${#targetNoOfCharsList[@]} != ${#expectedOutputList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <targetNoOfCharsList>: ${#targetNoOfCharsList[@]} elements"
    >&2 echo "               <numberList>: ${#numberList[@]} elements"
    >&2 echo "       <expectedOutputList>: ${#expectedOutputList[@]} elements"
    >&2 echo

    exit 1
fi

source '../stringFunctions.sh'

testsPassed=0
listLength=${#targetNoOfCharsList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    targetNoOfChars="${targetNoOfCharsList[${index}]}"
    number="${numberList[${index}]}"
    expectedOutput="${expectedOutputList[${index}]}"
    actualOutput="$(padNumberWithZeroes ${targetNoOfChars} ${expectedOutput})"

    echo "targetNoOfChars=${targetNoOfChars}"
    echo "         number=${number}"
    echo
    echo " expectedOutput='${expectedOutput}'"
    if [[ "${actualOutput}" == "${expectedOutput}" ]]
    then
        echo "   actualOutput='${actualOutput}' (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "   actualOutput='${actualOutput}' (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

