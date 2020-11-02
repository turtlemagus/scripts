function validateFilePath() { # <varName_filePath>
    local varName_filePath="${1}"

    local callerScriptFileName="$(basename ${BASH_SOURCE[1]})"

    local originalFilePath=''
    eval "originalFilePath=\"\${${varName_filePath}}\""
    local parsedFilePath="$(echo "${originalFilePath}" | sed -E "s|~|${HOME}|g")"
    if [[ ! -e "${parsedFilePath}" ]]
    then
        >&2 echo
        >&2 echo "ERROR: ${callerScriptFileName}: <${varName_filePath}> '${originalFilePath}' not found."
        >&2 echo

        false

    elif [[ ! -f "${parsedFilePath}" ]]
    then
        >&2 echo
        >&2 echo "ERROR: ${callerScriptFileName}: <${varName_filePath}> '${originalFilePath}' is not a file."
        >&2 echo

        false
    else
        eval "${varName_filePath}=\"${parsedFilePath}\""
    fi
}

function getTempFilePath() { # [annotation]
    local thisFileDirPath="$(dirname "${BASH_SOURCE[0]}")"
    local callerScriptFileName="$(basename ${BASH_SOURCE[1]})"

    local unindexedTempFilePath="${thisFileDirPath}/../tempFiles/TEMP__${callerScriptFileName}"
    (( ${#} >= 1 )) && unindexedTempFilePath="${unindexedTempFilePath}__${1}"

    local uniqueIndex=0
    local tempFilePath="${unindexedTempFilePath}"
    while [[ -e "${tempFilePath}.txt" ]]
    do
        uniqueIndex=$((uniqueIndex + 1))
        tempFilePath="${unindexedTempFilePath}__${uniqueIndex}"
    done

    tempFilePath="${tempFilePath}.txt"
    echo "${tempFilePath}"
}