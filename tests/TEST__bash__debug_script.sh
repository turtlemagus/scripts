thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

inputFileList=()
expectedOutputFileList=()

inputFileList[${#inputFileList[@]}]='INPUT__unmatchedDoubleQuotes.txt'
expectedOutputFileList[${#expectedOutputFileList[@]}]='OUTPUT__unmatchedDoubleQuotes.txt'

if (( ${#inputFileList[@]} != ${#expectedOutputFileList[@]} ))
then
    >&2 echo
    >&2 echo "INTERNAL ERROR: ${thisScriptFileName}: lists are not the same length:"
    >&2 echo
    >&2 echo "             <inputFileList>: ${#inputFileList[@]} elements"
    >&2 echo "    <expectedOutputFileList>: ${#expectedOutputFileList[@]} elements"
    >&2 echo

    exit 1
fi

headerLine="$(printf "%$(tput cols)s" | sed 's| |-|g')"
subHeaderLine="$(printf "%$(($(tput cols) - 2))s" | sed 's| |:|g')"
echo
echo "${headerLine}"
testsPassed=0
listLength=${#inputFileList[@]}
for (( index = 0; index <= listLength - 1; index++ ))
do
    inputFile="bash__debug_script/${inputFileList[${index}]}"
    expectedOutputFile="bash__debug_script/${expectedOutputFileList[${index}]}"

    echo "         inputFile: ${inputFile}"


    actualOutput="$(../bash__debug_script.sh "${inputFile}")"
    if (( $(diff "${expectedOutputFile}" <(echo "${actualOutput}"; echo) | grep -c '.*') ))
    then
        echo "expectedOutputFile: ${expectedOutputFile} (FAIL)"
        echo
        echo 'Difference:'
        echo "${subHeaderLine}"
        diff "${expectedOutputFile}" <(echo "${actualOutput}")
        echo "${subHeaderLine}"
    else
        echo "expectedOutputFile: ${expectedOutputFile} (PASS)"
        testsPassed=$((${testsPassed} + 1))
    fi
    echo "${headerLine}"
done

echo
echo "Passed ${testsPassed} / ${listLength} tests"
echo
