IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"

source "${thisScriptAbsoluteDirPath}/bashFunctions/stringFunctions.sh"

if (( ${#} < 1 ))
then
    >&2 echo
    >&2 echo "Usage: ${thisScriptFileName} <string>"
    >&2 echo

    exit 1
fi
string="${1}"

charOutputString=''
asciiOutputString=''

hasCarriageReturnCharacters=0
for (( charNo=0; charNo <= ${#string} - 1; charNo++ ))
do
    currentChar="${string:${charNo}:1}"
    asciiCode="$( padNumberWithZeroes 3 $(getAsciiCode "${currentChar}") )"

    if [[ '009' == ${asciiCode} ]]
    then
	    currentChar='\t'
		
    elif [[ '013' == ${asciiCode} ]]
    then
        currentChar='\r'
        hasCarriageReturnCharacters=1
		
    elif [[ '032' == ${asciiCode} ]]
    then
        currentChar='SPC'
    fi

    outputString="${outputString}$(getLeftAlignedString 4 ${currentChar})"
    asciiOutputString="${asciiOutputString}${asciiCode} "

done

outputWidth=$(( $(tput cols) / 4 * 4 ))
while (( ${#outputString} > 0 ))
do
    echo
    echo "${outputString:0:${outputWidth}}"
    echo "${asciiOutputString:0:${outputWidth}}"

    outputString="${outputString:${outputWidth}:${#outputString}}"
    asciiOutputString="${asciiOutputString:${outputWidth}:${#asciiOutputString}}"
done
echo

if (( ${hasCarriageReturnCharacters} ))
then
    echo
    echo '\r = Carriage Return; Note that these characters can be problematic in many Linux applications.'
    echo '                      They can be removed using the command `sed -i -E "s|$(printf "\r")||g" <filePath>`'
    echo
fi
