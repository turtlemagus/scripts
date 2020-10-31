IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

comparisonFunctionList=()
listStringList=()
expectedListStringList=()

comparisonFunctionList[${#comparisonFunctionList[@]}]='compareNumbers'
listStringList[${#listStringList[@]}]='10, 1, 9, 8, 7'
expectedOutputList[${#expectedOutputList[@]}]='1'

comparisonFunctionList[${#comparisonFunctionList[@]}]='compareStrings'
listStringList[${#listStringList[@]}]='ABC, DEF, XYZ, GHI'
expectedOutputList[${#expectedOutputList[@]}]='ABC'

comparisonFunctionList[${#comparisonFunctionList[@]}]='compareStrings'
listStringList[${#listStringList[@]}]='xyz, uvw, rst, opq, lmn, ijk'
expectedOutputList[${#expectedOutputList[@]}]='ijk'

comparisonFunctionList[${#comparisonFunctionList[@]}]='compareStringLengths'
listStringList[${#listStringList[@]}]='longest, longer, long'
expectedOutputList[${#expectedOutputList[@]}]='long'

if (( ${#comparisonFunctionList[@]} != ${#listStringList[@]} )) \
|| (( ${#comparisonFunctionList[@]} != ${#expectedOutputList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <comparisonFunctionList>: ${#comparisonFunctionList[@]} elements"
    >&2 echo "              <listStringList>: ${#listStringList[@]} elements"
    >&2 echo "          <expectedOutputList>: ${#expectedOutputList[@]} elements"
    >&2 echo

    exit 1
fi

source '../listFunctions.sh'
source '../comparisonFunctions.sh'

testsPassed=0
listLength=${#comparisonFunctionList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    comparisonFunction="${comparisonFunctionList[${index}]}"
    listString="${listStringList[${index}]}"
    expectedOutput="${expectedOutputList[${index}]}"

    splitStringByDelimiter "${listString}" ', ' 'list'
    actualOutput="$(getLeastElementInList '${comparisonFunction}' 'list')"

    echo "comparisonFunction='${comparisonFunction}'"
    echo "        listString='${listString}'"
    echo
    echo "    expectedOutput='${expectedOutput}'"
    if [[ "${actualOutput}" == "${expectedOutput}" ]]
    then
        echo "      actualOutput='${actualOutput}' (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "      actualOutput='${actualOutput}' (FAIL)"
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

