IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"

if (( ${#} < 2 ))
then
    >&2 echo
    >&2 echo "Usage: ${thisScriptFileName} <string1> <string2>"
    >&2 echo

    exit 1
fi
string1="${1}"
string2="${2}"

screenWidthInChars=$(tput cols)
regex_diffLine='^(.)[[:space:]]*(.)[[:space:]](.)$'
echo
diff -y <(grep -o '.' <<< "${string1}") <(grep -o '.' <<< "${string2}") | {
string1Output=''
string2Output=''
diffOutput=''
while read currentCharDiff
do
    string1Char="$(sed -E "s|${regex_diffLine}|\1|g" <<< "${currentCharDiff}")"
	diffChar="$(sed -E "s|${regex_diffLine}|\2|g" <<< "${currentCharDiff}")"
	string2Char="$(sed -E "s|${regex_diffLine}|\3|g" <<< "${currentCharDiff}")"
	
	[[ '>' == "${diffChar}" ]] && string1Char='·'
	#[[ '<' == "${diffChar}" ]] && string2Char='·'
	if [[ '<' == "${string2Char}" ]]
    then
	    string2Char='·'
		diffChar='^'
	fi
	
	if [[ "${diffChar}" =~ [[:space:]] ]]
	then
	    diffChar=' '
	else
	    diffChar='^'
	fi
	
	string1Output="${string1Output}${string1Char}"
	string2Output="${string2Output}${string2Char}"
	diffOutput="${diffOutput}${diffChar}"
done

while (( ${#string1Output} > ${screenWidthInChars} ))
do
    echo "${string1Output:0:${screenWidthInChars}}"
    echo "${string2Output:0:${screenWidthInChars}}"
    echo "${diffOutput:0:${screenWidthInChars}}"
    echo
	
	string1Output="${string1Output:${screenWidthInChars}:${#string1Output}}"
	string2Output="${string2Output:${screenWidthInChars}:${#string2Output}}"
	diffOutput="${diffOutput:${screenWidthInChars}:${#diffOutput}}"
done
if (( ${#string1Output} > 0 ))
then
    echo "${string1Output:0:${screenWidthInChars}}"
    echo "${string2Output:0:${screenWidthInChars}}"
    echo "${diffOutput:0:${screenWidthInChars}}"
    echo
fi
}
