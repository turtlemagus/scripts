IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

string1List=()
string2List=()
expectedOutputList=()

string1List[${#string1List[@]}]='DEF'
string2List[${#string2List[@]}]='ABC'
expectedOutputList[${#expectedOutputList[@]}]=1

string1List[${#string1List[@]}]='ABC'
string2List[${#string2List[@]}]='DEF'
expectedOutputList[${#expectedOutputList[@]}]=-1

string1List[${#string1List[@]}]='ABC'
string2List[${#string2List[@]}]='ABC'
expectedOutputList[${#expectedOutputList[@]}]=0

if (( ${#string1List[@]} != ${#string2List[@]} )) \
|| (( ${#string1List[@]} != ${#expectedOutputList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <string1List>: ${#string1List[@]} elements"
    >&2 echo "      <string2List>: ${#string2List[@]} elements"
    >&2 echo "      <expectedOutputList>: ${#expectedOutputList[@]} elements"
    >&2 echo

    exit 1
fi

source '../comparisonFunctions.sh'

testsPassed=0
listLength=${#string1List[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    string1="${string1List[${index}]}"
    string2="${string2List[${index}]}"
    expectedOutput="${expectedOutputList[${index}]}"
    actualOutput="$(compareStrings "${string1}" "${string2}")"

    echo "       string1='${string1}'"
    echo "       string2='${string2}'"
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

