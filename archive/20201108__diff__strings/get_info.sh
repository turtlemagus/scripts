IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"

terminalWidthInChars=$(tput cols)
headerLine="$(printf "%${terminalWidthInChars}s" | sed 's| |#|g')"
subHeaderLine="$(printf "%$((${terminalWidthInChars} - 2))s" | sed 's| |=|g')"


string1='BCDEF>GHI<<>J'
string2='ABC4FG<H>I<>J'

echo
echo "string1='${string1}'"
echo "string2='${string2}'"
echo

echo "${headerLine}"
commandStr="diff -y <(grep -o '.' <<< '${string1}') <(grep -o '.' <<< '${string2}')"
echo "${commandStr}"
echo "${headerLine}"
eval "${commandStr}"
echo "${headerLine}"
echo "${headerLine}"
echo "[${commandStr}]"
echo
echo

echo 'ASCII Info'
echo '##########'
echo
echo

#for (( charNo = 1; charNo <= ${#string2}; charNo++ ))
#do
#    ascii__list_codes_for_string.sh                 \
#	    "$(                                         \
#		    diff -y                                 \
#		        <(echo "${string1}" | grep -o '.')  \
#			    <(echo "${string2}" | grep -o '.')  \
#		    | sed -n "${charNo}p"                   \
#		)"
#done

diff -y <(echo "${string1}" | grep -o '.') <(echo "${string2}" | grep -o '.') | {
while read currentDiff
do
    echo
	echo "${currentDiff}"
    ascii__list_codes_for_string.sh "${currentDiff}" | sed -n '2,$p'
done
}

echo
echo "string1='${string1}'"
echo "string2='${string2}'"
echo
