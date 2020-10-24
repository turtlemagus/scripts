thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

function centreText() { # <string> <targetWidthInChars>
    local string="${1}"
    local targetWidthInChars=${2}

    local totalNoOfSpaces=$((${targetWidthInChars} - ${#string}))
    if (( ${totalNoOfSpaces} <= 0 ))
    then
        echo "${string}"
    else
        local noOfSpacesToLeft=$((${totalNoOfSpaces} / 2))
        local noOfSpacesToRight=$((${totalNoOfSpaces} - ${noOfSpacesToLeft}))
        echo "$(printf "%${noOfSpacesToLeft}s")${string}$(printf "%${noOfSpacesToRight}s")"
    fi
}

terminalWidthInChars=$(tput cols)
headerLine="$(printf "%${terminalWidthInChars}s" | sed 's| |#|g')"
subHeaderLine="$(printf "%$((${terminalWidthInChars} - 2))s" | sed 's| |=|g')"

echo
echo "${headerLine}"
centreText "${thisScriptFileName}" ${terminalWidthInChars}
echo "${headerLine}"
echo

echo 'Library Files:'
echo "${subHeaderLine}"
find .. -maxdepth 1 -type f -name '*.sh' | sed -E -e 's|^.*/([^/]+)$|\1|g' -e 's|\.sh$||g'
echo "${subHeaderLine}"
echo
read -p 'Enter library file name: _ ' libraryFileBaseName
echo
echo

regex_emptyLine='^[[:space:]]*$'
[[ "${libraryFileBaseName}" =~ ${regex_emptyLine} ]] && exit 0

libraryFileBaseName="$(echo "${libraryFileBaseName}" | sed -E -e 's|\.sh$||g' -e 's|^ *||g' -e 's| *$||g')"
libraryFilePath="../${libraryFileBaseName}.sh"

if [[ -e "${libraryFilePath}" ]]
then
    echo 'Functions:'
    echo "${subHeaderLine}"
    egrep "^function" "${libraryFilePath}" | sed -E 's|^function +([^(]+) *\(.*$|\1|g'
    echo "${subHeaderLine}"
    echo
fi

read -p 'Enter function name: _ ' functionName
functionName="$(echo "${functionName}" | sed -E -e 's|^ *||g' -e 's| *$||g')"
echo
echo
[[ "${functionName}" =~ ${regex_emptyLine} ]] && exit 0

testFilePath="TEST__${libraryFileBaseName}__${functionName}.sh"
if [[ -e "${testFilePath}" ]]
then
    >&2 echo
    >&2 echo "ERROR: test file '${testFilePath}' already exists.  Aborting."
    >&2 echo

    exit 1
fi

read -p 'Enter number of test variables in test file (usually 3 or 4 including expectedOutput): _ ' noOfLists
noOfLists="$(echo "${noOfLists}" | sed -E -e 's|^ *||g' -e 's| *$||g')"
echo
echo

regex_number='^[0-9]+$'
[[ ! "${noOfLists}" =~ ${regex_number} ]] && exit 0
if (( ${noOfLists} < 2 ))
then
    >&2 echo
    >&2 echo "There must be at least two test variables."
    >&2 echo

    exit 1
fi

listNameList=()
for (( listNo = 1; listNo <= noOfLists; listNo++ ))
do
    read -p "Enter name for test variable ${listNo}: _ " listName
    [[ "${listName}" =~ ${regex_emptyLine} ]] && exit 0
    listNameList[${#listNameList[@]}]="${listName}"
done

echo "IFS=''"                                                                                    >> "${testFilePath}"
echo "thisScriptRelativeFilePath=\"\${BASH_SOURCE[0]}\""                                         >> "${testFilePath}"
echo "thisScriptRelativeDirPath=\"\$(dirname \"\${thisScriptRelativeFilePath}\")\""              >> "${testFilePath}"
echo                                                                                             >> "${testFilePath}"
echo "thisScriptAbsoluteDirPath=\"\$(cd \"\${thisScriptRelativeDirPath}\" >/dev/null && pwd)\""  >> "${testFilePath}"
echo "thisScriptFileName=\"\$(basename \${thisScriptRelativeFilePath})\""                        >> "${testFilePath}"
echo "thisScriptAbsoluteFilePath=\"\${thisScriptAbsoluteDirPath}/\${thisScriptFileName}\""       >> "${testFilePath}"
echo "cd \"\${thisScriptAbsoluteDirPath}\""                                                      >> "${testFilePath}"
echo                                                                                             >> "${testFilePath}"
for listName in "${listNameList[@]}"
do
    echo "${listName}List=()"                                                                        >> "${testFilePath}"
done
echo                                                                                             >> "${testFilePath}"
for listName in "${listNameList[@]}"
do
    echo "${listName}List[\${#${listName}List[@]}]=''"                                               >> "${testFilePath}"
done
echo                                                                                             >> "${testFilePath}"
echo                                                                                             >> "${testFilePath}"
if (( ${#listNameList[@]} == 2 ))
then
    echo "if (( \${#${listNameList[0]}List[@]} != \${#${listNameList[1]}List[@]} ))"                 >> "${testFilePath}"
else
    echo "if (( \${#${listNameList[0]}List[@]} != \${#${listNameList[1]}List[@]} )) \\"              >> "${testFilePath}"
    for (( index = 2; index <= ${#listNameList[@]} - 1; index++ ))
    do
        if (( ${index} == $((${#listNameList[@]} - 1)) ))
        then
            echo "|| (( \${#${listNameList[0]}List[@]} != \${#${listNameList[${index}]}List[@]} ))"          >> "${testFilePath}"
        else
            echo "|| (( \${#${listNameList[0]}List[@]} != \${#${listNameList[${index}]}List[@]} )) \\"       >> "${testFilePath}"
        fi
    done
fi
echo "then"                                                                                      >> "${testFilePath}"
echo "    >&2 echo"                                                                              >> "${testFilePath}"
echo "    >&2 echo \"INTERAL ERROR: \${thisScriptFileName}: Lists are not the same length:\""    >> "${testFilePath}"
echo "    >&2 echo"                                                                              >> "${testFilePath}"
for listName in "${listNameList[@]}"
do
    echo "    >&2 echo \"      <${listName}List>: \${#${listName}List[@]} elements\""                >> "${testFilePath}"
done
echo "    >&2 echo"                                                                              >> "${testFilePath}"
echo                                                                                             >> "${testFilePath}"
echo "    exit 1"                                                                                >> "${testFilePath}"
echo "fi"                                                                                        >> "${testFilePath}"
echo                                                                                             >> "${testFilePath}"
echo "source '${libraryFilePath}'"                                                               >> "${testFilePath}"
echo                                                                                             >> "${testFilePath}"
echo "testsPassed=0"                                                                             >> "${testFilePath}"
echo "listLength=\${#${listNameList[0]}List[@]}"                                                 >> "${testFilePath}"
echo "echo"                                                                                      >> "${testFilePath}"
echo "echo '----------------------------------------------------------------'"                   >> "${testFilePath}"
echo "for (( index=0; index <= listLength - 1; index++ ))"                                       >> "${testFilePath}"
echo "do"                                                                                        >> "${testFilePath}"
for listName in "${listNameList[@]}"
do
    echo "    ${listName}=\"\${${listName}List[\${index}]}\""                                        >> "${testFilePath}"
done
echo "    # TODO: run test function ${functionName}"                                             >> "${testFilePath}"
echo                                                                                             >> "${testFilePath}"
for listName in "${listNameList[@]}"
do
    echo "    echo \"${listName}='\${${listName}}'\""                                                >> "${testFilePath}"
done
echo "    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"                        >> "${testFilePath}"
echo "    # TODO: Replace below placeholder code...!"                                            >> "${testFilePath}"
echo "    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"                        >> "${testFilePath}"
echo "    if (( 1 == 1 ))"                                                                       >> "${testFilePath}"
echo "    then"                                                                                  >> "${testFilePath}"
echo "        echo \"     actualList='TODO' (PASS)\""                                            >> "${testFilePath}"
echo "        testsPassed=\$(( \${testsPassed} + 1 ))"                                           >> "${testFilePath}"
echo "    else"                                                                                  >> "${testFilePath}"
echo "        echo \"     actualList='TODO' (FAIL)\""                                            >> "${testFilePath}"
echo "    fi"                                                                                    >> "${testFilePath}"
echo "    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"                        >> "${testFilePath}"
echo "    # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"                        >> "${testFilePath}"
echo                                                                                             >> "${testFilePath}"
echo "    echo '----------------------------------------------------------------'"               >> "${testFilePath}"
echo "done"                                                                                      >> "${testFilePath}"
echo                                                                                             >> "${testFilePath}"
echo "echo"                                                                                      >> "${testFilePath}"
echo "echo \"Passed \${testsPassed} / \${listLength} tests.\""                                   >> "${testFilePath}"
echo "echo"                                                                                      >> "${testFilePath}"
echo                                                                                             >> "${testFilePath}"

echo
echo "Output written to ${testFilePath}"
echo
echo "${headerLine}"
echo "${headerLine}"
centreText "${thisScriptFileName} done." ${terminalWidthInChars}
echo

