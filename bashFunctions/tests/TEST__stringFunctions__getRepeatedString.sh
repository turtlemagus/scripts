IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

noOfRepetitionsList=()
stringList=()
expectedOutputList=()

noOfRepetitionsList[${#noOfRepetitionsList[@]}]=3
stringList[${#stringList[@]}]='X'
expectedOutputList[${#expectedOutputList[@]}]='XXX'

noOfRepetitionsList[${#noOfRepetitionsList[@]}]=1
stringList[${#stringList[@]}]='X'
expectedOutputList[${#expectedOutputList[@]}]='X'

noOfRepetitionsList[${#noOfRepetitionsList[@]}]=0
stringList[${#stringList[@]}]='X'
expectedOutputList[${#expectedOutputList[@]}]=''

noOfRepetitionsList[${#noOfRepetitionsList[@]}]=2
stringList[${#stringList[@]}]='ABC '
expectedOutputList[${#expectedOutputList[@]}]='ABC ABC '

noOfRepetitionsList[${#noOfRepetitionsList[@]}]=-1
stringList[${#stringList[@]}]='DEF'
expectedOutputList[${#expectedOutputList[@]}]='FED'

noOfRepetitionsList[${#noOfRepetitionsList[@]}]=-4
stringList[${#stringList[@]}]='123'
expectedOutputList[${#expectedOutputList[@]}]='321321321321'

if (( ${#noOfRepetitionsList[@]} != ${#stringList[@]} )) \
|| (( ${#noOfRepetitionsList[@]} != ${#expectedOutputList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <noOfRepetitionsList>: ${#noOfRepetitionsList[@]} elements"
    >&2 echo "      <stringList>: ${#stringList[@]} elements"
    >&2 echo "      <expectedOutputList>: ${#expectedOutputList[@]} elements"
    >&2 echo

    exit 1
fi

source '../stringFunctions.sh'

testsPassed=0
listLength=${#noOfRepetitionsList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    noOfRepetitions="${noOfRepetitionsList[${index}]}"
    string="${stringList[${index}]}"
    expectedOutput="${expectedOutputList[${index}]}"
    actualOutput="$(getRepeatedString ${noOfRepetitions} "${string}")"

    echo "noOfRepetitions=${noOfRepetitions}"
    echo "         string='${string}'"
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

