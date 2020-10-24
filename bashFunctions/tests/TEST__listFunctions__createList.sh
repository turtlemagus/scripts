thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

source "../listFunctions.sh"

createList 'myList' 'element0' 'element_1' 'element_two' 'element THREE'

for element in "${myList[@]}"
do
    echo "element='${element}'"
done

