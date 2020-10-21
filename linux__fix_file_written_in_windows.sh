thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
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

sed -i -E "s|$(printf "\r")||g" "${filePath}"
echo
echo "Removed Windows style newline characters from file '${filePath}'."
echo

