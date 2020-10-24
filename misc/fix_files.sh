IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

function addEmptyLinesToEndOfFiles() { # <rootDirPath>

    local rootDirPath="${1}"

    local regex_emptyLine='^$'
    local currentDirPath=''
    local regex_containsDotDir='/\.[^/]+/'
    find "${rootDirPath}" -type f | {
        while read currentFilePath
        do
            if [[ "${currentFilePath}" =~ ${regex_containsDotDir} ]]
            then
                continue
            fi

            if [[ ! "$(tail -1 "${currentFilePath}")" =~ ${regex_emptyLine} ]]
            then
                echo "Adding empty line to the end of '${currentFilePath}'"
                echo >> "${currentFilePath}"
            fi
        done
        }
}

echo
addEmptyLinesToEndOfFiles '..'
echo


