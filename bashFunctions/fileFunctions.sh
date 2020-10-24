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
