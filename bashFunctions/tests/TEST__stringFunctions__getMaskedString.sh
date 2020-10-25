IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

startIndexList=()
maskingStringList=()
stringList=()
noOfRepetitionsList=()
expectedStringList=()

startIndexList[${#startIndexList[@]}]=1
maskingStringList[${#maskingStringList[@]}]='ABC'
stringList[${#stringList[@]}]='0123456789'
noOfRepetitionsList[${#noOfRepetitionsList[@]}]=1
expectedStringList[${#expectedStringList[@]}]='0ABC456789'

startIndexList[${#startIndexList[@]}]=0
maskingStringList[${#maskingStringList[@]}]='ZABC'
stringList[${#stringList[@]}]='0123456789'
noOfRepetitionsList[${#noOfRepetitionsList[@]}]=1
expectedStringList[${#expectedStringList[@]}]='ZABC456789'

startIndexList[${#startIndexList[@]}]=5
maskingStringList[${#maskingStringList[@]}]='X'
stringList[${#stringList[@]}]='0123456789'
noOfRepetitionsList[${#noOfRepetitionsList[@]}]=10
expectedStringList[${#expectedStringList[@]}]='01234XXXXX'

if (( ${#startIndexList[@]} != ${#maskingStringList[@]} )) \
|| (( ${#startIndexList[@]} != ${#stringList[@]} )) \
|| (( ${#startIndexList[@]} != ${#noOfRepetitionsList[@]} )) \
|| (( ${#startIndexList[@]} != ${#expectedStringList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "           <startIndexList>: ${#startIndexList[@]} elements"
    >&2 echo "        <maskingStringList>: ${#maskingStringList[@]} elements"
    >&2 echo "               <stringList>: ${#stringList[@]} elements"
    >&2 echo "      <noOfRepetitionsList>: ${#noOfRepetitionsList[@]} elements"
    >&2 echo "       <expectedStringList>: ${#expectedStringList[@]} elements"
    >&2 echo

    exit 1
fi

source '../stringFunctions.sh'

testsPassed=0
listLength=${#startIndexList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    startIndex="${startIndexList[${index}]}"
    maskingString="${maskingStringList[${index}]}"
    string="${stringList[${index}]}"
    noOfRepetitions="${noOfRepetitionsList[${index}]}"
    expectedString="${expectedStringList[${index}]}"

    echo "     startIndex=${startIndex}"
    echo "  maskingString='${maskingString}'"
    echo "         string='${string}'"
    echo "noOfRepetitions=${noOfRepetitions}"
    echo " expectedString='${expectedString}'"

    actualString="$(getMaskedString ${startIndex} "${maskingString}" "${string}" ${noOfRepetitions})"
    if [[ "${actualString}" == "${expectedString}" ]]
    then
        echo "   actualString='${actualString}' (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "   actualString='${actualString}' (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

