thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

list1StringList=()
list2StringList=()
expectedOutputList=()

list1StringList[${#list1StringList[@]}]="'one'"
list2StringList[${#list2StringList[@]}]="'one' 'more'"
expectedOutputList[${#expectedOutputList[@]}]=0

list1StringList[${#list1StringList[@]}]="'the' 'same'"
list2StringList[${#list2StringList[@]}]="'the' 'same'"
expectedOutputList[${#expectedOutputList[@]}]=1

list1StringList[${#list1StringList[@]}]="'same' 'length'"
list2StringList[${#list2StringList[@]}]="'different' 'values'"
expectedOutputList[${#expectedOutputList[@]}]=0

if (( ${#list1StringList[@]} != ${#list2StringList[@]} )) \
|| (( ${#list1StringList[@]} != ${#expectedOutputList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "       <list1StringList>: ${#list1StringList[@]} elements"
    >&2 echo "       <list2StringList>: ${#list2StringList[@]} elements"
    >&2 echo "    <expectedOutputList>: ${#expectedOutputList[@]} elements"
    >&2 echo

    exit 1
fi

source "../listFunctions.sh"

testsPassed=0
listLength=${#list1StringList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    list1String=${list1StringList[${index}]}
    list2String=${list2StringList[${index}]}
    expectedOutput=${expectedOutputList[${index}]}

    eval "createList 'list1' ${list1String}"
    eval "createList 'list2' ${list2String}"

    echo "         list1=${list1String}"
    echo "         list2=${list2String}"
    echo "expectedOutput=${expectedOutput}"


    actualOutput=$(getListsAreEqual 'list1' 'list2')
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


