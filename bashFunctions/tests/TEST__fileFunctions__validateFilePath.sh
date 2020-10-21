IFS=''
thisScriptRelativemyFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativemyFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativemyFilePath})"
thisScriptAbsolutemyFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

myFilePathList=()
expectToPassList=()

myFilePathList[${#myFilePathList[@]}]="${thisScriptAbsoluteDirPath}/sampleFiles/fileFunctions/FILE_THAT_EXISTS.txt"
expectToPassList[${#expectToPassList[@]}]='TRUE'

myFilePathList[${#myFilePathList[@]}]="${thisScriptRelativeDirPath}/sampleFiles/fileFunctions/FILE_THAT_EXISTS.txt"
expectToPassList[${#expectToPassList[@]}]='TRUE'

myFilePathList[${#myFilePathList[@]}]="${thisScriptAbsoluteDirPath}/sampleFiles/fileFunctions/FILE_THAT_DOES_NOT_EXIST.txt"
expectToPassList[${#expectToPassList[@]}]='FALSE'

myFilePathList[${#myFilePathList[@]}]="${thisScriptRelativeDirPath}/sampleFiles/fileFunctions/FILE_THAT_DOES_NOT_EXIST.txt"
expectToPassList[${#expectToPassList[@]}]='FALSE'

myFilePathList[${#myFilePathList[@]}]="${thisScriptAbsoluteDirPath}/sampleFiles/fileFunctions/DIRECTORY"
expectToPassList[${#expectToPassList[@]}]='FALSE'

myFilePathList[${#myFilePathList[@]}]="${thisScriptRelativeDirPath}/sampleFiles/fileFunctions/DIRECTORY"
expectToPassList[${#expectToPassList[@]}]='FALSE'

if (( ${#myFilePathList[@]} != ${#expectToPassList[@]} ))
then
    >&2 echo
    >&2 echo "INTERAL ERROR: ${thisScriptFileName}: Lists are not the same length:"
    >&2 echo
    >&2 echo "          <myFilePathList>: ${#myFilePathList[@]} elements"
    >&2 echo "      <expectToPassList>: ${#expectToPassList[@]} elements"
    >&2 echo

    exit 1
fi

source '../fileFunctions.sh'

set +e
testsPassed=0
listLength=${#myFilePathList[@]}
echo
echo '----------------------------------------------------------------'
for (( index=0; index <= listLength - 1; index++ ))
do
    myFilePath="${myFilePathList[${index}]}"
    expectToPass="${expectToPassList[${index}]}"

    echo "  myFilePath='${myFilePath}'"
    echo "expectToPass='${expectToPass}'"

    passed='TRUE'
    errorMessage="$(validateFilePath 'myFilePath' 2>&1)" || passed='FALSE'
    if [[ "${passed}" == "${expectToPass}" ]]
    then
        echo "      passed='${passed}' (PASS)"
        testsPassed=$(( ${testsPassed} + 1 ))
    else
        echo "      passed='${passed}' (FAIL)"
    fi

    if [[ 'FALSE' == "${passed}" ]]
    then
        echo
        echo 'Error message:'
        echo "${errorMessage}"
        echo
    fi

    echo '----------------------------------------------------------------'
done

echo
echo "Passed ${testsPassed} / ${listLength} tests."
echo

