IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

stringList=()
delimiterList=()
expectedListStringList=()

delimitedStringList[${#delimitedStringList[@]}]='one,two'
delimiterList[${#delimiterList[@]}]=','
expectedListStringList[${#expectedListStringList[@]}]="'one' 'two'"

delimitedStringList[${#delimitedStringList[@]}]='one__two__three'
delimiterList[${#delimiterList[@]}]='__'
expectedListStringList[${#expectedListStringList[@]}]="'one' 'two' 'three'"

delimitedStringList[${#delimitedStringList[@]}]='oneXYZtwoXYZthreeXYZfour'
delimiterList[${#delimiterList[@]}]='XYZ'
expectedListStringList[${#expectedListStringList[@]}]="'one' 'two' 'three' 'four'"

delimitedStringList[${#delimitedStringList[@]}]='delimiter not found.'
delimiterList[${#delimiterList[@]}]=','
expectedListStringList[${#expectedListStringList[@]}]="'delimiter not found.'"

delimitedStringList[${#delimitedStringList[@]}]='There,is,no,delimiter'
delimiterList[${#delimiterList[@]}]=''
expectedListStringList[${#expectedListStringList[@]}]="'There,is,no,delimiter'"

delimitedStringList[${#delimitedStringList[@]}]=''
delimiterList[${#delimiterList[@]}]=','
expectedListStringList[${#expectedListStringList[@]}]="''"

delimitedStringList[${#delimitedStringList[@]}]=''
delimiterList[${#delimiterList[@]}]=''
expectedListStringList[${#expectedListStringList[@]}]="''"

if (( ${#delimitedStringList[@]} != ${#delimiterList[@]} )) \
|| (( ${#delimitedStringList[@]} != ${#expectedListStringList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "      <delimitedStringList>: ${#delimitedStringList[@]} elements"
    >&2 echo "            <delimiterList>: ${#delimiterList[@]} elements"
    >&2 echo "   <expectedListStringList>: ${#expectedListStringList[@]} elements"
    >&2 echo

    exit 1
fi

source '../listFunctions.sh'

testsPassed=0
listLength=${#delimitedStringList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    delimitedString="${delimitedStringList[${index}]}"
    delimiter="${delimiterList[${index}]}"

    expectedListString=${expectedListStringList[${index}]}
    eval "createList 'expectedList' ${expectedListString}"


    echo "delimitedString='${delimitedString}'"
    echo "      delimiter='${delimiter}'"
    echo "   expectedList=${expectedListString}"

    splitStringByDelimiter "${delimitedString}" "${delimiter}" 'actualList'
    actualListString=''
    for actualListElement in "${actualList[@]}"
    do
        actualListString="${actualListString}'${actualListElement}' "
    done

    if (( $(getListsAreEqual 'actualList' 'expectedList') ))
    then
        echo "     actualList=${actualListString} (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "     actualList=${actualListString} (FAIL)"
        echo
        echo 'Expected list:'
        for element in "${expectedList[@]}"
        do
            echo "  - ${element}"
        done
        echo 'Actual list:'
        for element in "${actualList[@]}"
        do
            echo "  - ${element}"
        done
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo


