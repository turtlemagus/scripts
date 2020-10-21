thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

literalList=()
positiveTestList=()
negativeTestList=()

literalList[${#literalList[@]}]='A.B'
positiveTestList[${#positiveTestList[@]}]='A.B'
negativeTestList[${#negativeTestList[@]}]='AXB'

literalList[${#literalList[@]}]='^A'
positiveTestList[${#positiveTestList[@]}]='xxxxx^A'
negativeTestList[${#negativeTestList[@]}]='A'

literalList[${#literalList[@]}]='A$'
positiveTestList[${#positiveTestList[@]}]='A$xxxxxxx'
negativeTestList[${#negativeTestList[@]}]='A'

literalList[${#literalList[@]}]='A*'
positiveTestList[${#positiveTestList[@]}]='A*'
negativeTestList[${#negativeTestList[@]}]=''

literalList[${#literalList[@]}]='A*'
positiveTestList[${#positiveTestList[@]}]='A*'
negativeTestList[${#negativeTestList[@]}]='AAA'

literalList[${#literalList[@]}]='A+'
positiveTestList[${#positiveTestList[@]}]='A+'
negativeTestList[${#negativeTestList[@]}]='AAA'

literalList[${#literalList[@]}]='ABC|DEF'
positiveTestList[${#positiveTestList[@]}]='ABC|DEF'
negativeTestList[${#negativeTestList[@]}]='ABC'

literalList[${#literalList[@]}]='(X)'
positiveTestList[${#positiveTestList[@]}]='(X)'
negativeTestList[${#negativeTestList[@]}]='X'

literalList[${#literalList[@]}]='(X)(X)'
positiveTestList[${#positiveTestList[@]}]='(X)(X)'
negativeTestList[${#negativeTestList[@]}]='XX'

literalList[${#literalList[@]}]='(X)(X)'
positiveTestList[${#positiveTestList[@]}]='(X)(X)'
negativeTestList[${#negativeTestList[@]}]='(X)X'

literalList[${#literalList[@]}]='[X]'
positiveTestList[${#positiveTestList[@]}]='[X]'
negativeTestList[${#negativeTestList[@]}]='X'

literalList[${#literalList[@]}]='X{5}'
positiveTestList[${#positiveTestList[@]}]='X{5}'
negativeTestList[${#negativeTestList[@]}]='XXXXX'

literalList[${#literalList[@]}]='\A'
positiveTestList[${#positiveTestList[@]}]='\A'
negativeTestList[${#negativeTestList[@]}]='A'

if (( ${#literalList[@]} != ${#positiveTestList[@]} )) \
|| (( ${#literalList[@]} != ${#negativeTestList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "         <literalList>: ${#literalList[@]} elements"
    >&2 echo "    <positiveTestList>: ${#positiveTestList[@]} elements"
    >&2 echo "    <negativeTestList>: ${#negativeTestList[@]} elements"
    >&2 echo

    exit 1
fi

source "../stringFunctions.sh"

testsPassed=0
listLength=${#literalList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    literal=${literalList[${index}]}
    regex="$(getRegexForLiteral ${literal})"
    positiveTest=${positiveTestList[${index}]}
    negativeTest=${negativeTestList[${index}]}

    echo "     literal=\"${literal}\""
    echo "       regex=\"${regex}\""

    positiveTestPassed=0
    if (( $(echo "${positiveTest}" | grep -E -c "${regex}") ))
    then
        echo "positiveTest=\"${positiveTest}\" (PASS)"
        positiveTestPassed=1
    else
        echo "positiveTest=\"${positiveTest}\" (FAIL)"
    fi

    negativeTestPassed=0
    if (( $(echo "${negativeTest}" | grep -E -c "${regex}") ))
    then
        echo "negativeTest=\"${negativeTest}\" (FAIL)"
    else
        echo "negativeTest=\"${negativeTest}\" (PASS)"
        negativeTestPassed=1
    fi

    echo '----------------------------------------------------------------'

    if (( ${positiveTestPassed} )) && (( ${negativeTestPassed} ))
    then
        testsPassed=$(( ${testsPassed} + 1 ))
    fi
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo


