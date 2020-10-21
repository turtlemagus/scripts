thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
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

sed -i -E "s|$(printf "\r")||g" "${filePath}"
echo
echo "Removed Windows style newline characters from file '${filePath}'."
echo

