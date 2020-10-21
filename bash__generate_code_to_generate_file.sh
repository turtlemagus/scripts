thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"

if (( ${#} < 1 ))
then
    >&2 echo
    >&2 echo "Usage: ${thisScriptFileName} <filePath>"
    >&2 echo

    exit 1
fi

filePath="$(echo "${1}" | sed -E "s|~|${HOME}|g")"
if [[ ! -e "${filePath}" ]]
then
    >&2 echo
    >&2 echo "Error: ${thisScriptFileName}: <filePath> '${1}' not found."
    >&2 echo

    exit 1

elif [[ ! -f "${filePath}" ]]
then
    >&2 echo
    >&2 echo "Error: ${thisScriptFileName}: <filePath> '${1}' is not a file."
    >&2 echo

    exit 1
fi

sed -E                        \
    -e 's|\\|\\\\|g'          \
    -e 's|\$|\\$|g'           \
    -e 's|"|\\"|g'            \
    -e 's|^(.*)$|echo "\1"|g' \
    "${filePath}"

