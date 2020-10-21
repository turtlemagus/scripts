thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"

source "${thisScriptRelativeDirPath}/bashFunctions/fileFunctions.sh"

if (( ${#} < 1 ))
then
    >&2 echo
    >&2 echo "Usage: ${thisScriptFileName} <filePath>"
    >&2 echo

    exit 1
fi

filePath="$(echo "${1}" | sed -E "s|~|${HOME}|g")"
validateFilePath 'filePath' || exit 1

sed -E                        \
    -e 's|\\|\\\\|g'          \
    -e 's|\$|\\$|g'           \
    -e 's|"|\\"|g'            \
    -e 's|^(.*)$|echo "\1"|g' \
    "${filePath}"

