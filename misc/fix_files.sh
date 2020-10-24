IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

function fix_files__findFiles() { # <rootDirPath>
    local regex_containsDotDir='/\.[^/]+/'
    find "${1}" -type f | egrep -v "${regex_containsDotDir}"
}


function addEmptyLinesToEndOfFiles() { # <rootDirPath>
    local regex_emptyLine='^$'
    fix_files__findFiles "${1}" | {
        while read currentFilePath
        do
            if [[ ! "$(tail -1 "${currentFilePath}")" =~ ${regex_emptyLine} ]]
            then
                echo "Adding empty line to the end of '${currentFilePath}'"
                echo >> "${currentFilePath}"
            fi
        done
    }
}

function removeTrailingSpacesFromFiles() { # <rootDirPath>
    local regex_trailingSpaces='[[:space:]]+$'
    fix_files__findFiles "${1}" | xargs egrep -l "${regex_trailingSpaces}" | {
        while read currentFilePath
        do
            echo "Removing trailing spaces from '${currentFilePath}'"
            sed -E -i "s|${regex_trailingSpaces}||g" "${currentFilePath}"
        done
    }
}


echo
addEmptyLinesToEndOfFiles '..'
removeTrailingSpacesFromFiles '..'
echo


