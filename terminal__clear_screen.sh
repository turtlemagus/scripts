IFS=''
thisScriptRelativeFilePath="${BASH_SOURCE[0]}"
thisScriptRelativeDirPath="$(dirname "${thisScriptRelativeFilePath}")"

thisScriptAbsoluteDirPath="$(cd "${thisScriptRelativeDirPath}" >/dev/null && pwd)"
thisScriptFileName="$(basename ${thisScriptRelativeFilePath})"
thisScriptAbsoluteFilePath="${thisScriptAbsoluteDirPath}/${thisScriptFileName}"
cd "${thisScriptAbsoluteDirPath}"

imageList=()
imageList[${#imageList[@]}]='PLUS'

function terminal__clear_screen__printUsage() { # (No input args)
    echo
    echo "Usage: ${thisScriptFileName} [noOfEmptyLines] [(-i|--image) <IMAGE>]"
    echo
    echo '    --image options include:'
    local currentImageName=''
    for currentImageName in "${imageList[@]}"
    do
        echo "        - ${currentImageName}"
    done
    echo
}


source './bashFunctions/listFunctions.sh'
source './bashFunctions/stringFunctions.sh'

regex_number='^[0-9]+$'
noOfEmptyLines=$(tput lines)
imageName=''
while (( ${#} > 0 ))
do
    currentArg="${1}"
    if [[ '-' == "${currentArg:0:1}" ]]
    then
        case "${currentArg}" in
            '-i'|'--image')
                shift
                currentArg="${1}"
                if (( $(getIsInList "${currentArg}" 'imageList') ))
                then
                    imageName="${currentArg}"
                else
                    terminal__clear_screen__printUsage
                    exit 1
                fi
            ;;
            *)
                terminal__clear_screen__printUsage
                exit 1
            ;;
        esac
    else
        if [[ "${currentArg}" =~ ${regex_number} ]]
        then
            noOfEmptyLines=${currentArg}
        else
            terminal__clear_screen__printUsage
            exit 1
        fi
    fi
    shift
done

terminalWidthInChars=$(tput cols)
horizontalRow="$(getRepeatedString ${terminalWidthInChars} '#')"
if [[ '' == "${imageName}" ]]
then
    echo
    echo "${horizontalRow}"
    printf "%$((noOfEmptyLines - 4))s" | tr ' ' '\n'
    echo "${horizontalRow}"
    echo
else
    remainingNoOfEmptyLines=$((noOfEmptyLines - 6))

    echo
    echo "${horizontalRow}"
    echo

    case "${imageName}" in
        'PLUS')
            #verticalLineRow=$(getCentreAlignedString ${terminalWidthInChars} '|')
            #for (( lineNo = 1; lineNo <= remainingNoOfEmptyLines; lineNo++))
            #do
            #    if (( lineNo == $((remainingNoOfEmptyLines / 2)) ))
            #    then
            #        getCentreAlignedString ${terminalWidthInChars} '+' | sed -E \
            #            -e 's|^.|#|g' -e 's| $|#|g' \
            #            -e 's| |-|g' \
            #            -e 's|#| |g'
            #    else
            #        echo "${verticalLineRow}"
            #    fi
            #done
            verticalLineRow=$(getCentreAlignedString ${terminalWidthInChars} '||')
            #verticalLineRow=$(getCentreAlignedString ${terminalWidthInChars} '##')
            for (( lineNo = 1; lineNo <= remainingNoOfEmptyLines; lineNo++))
            do
                if (( lineNo == $((remainingNoOfEmptyLines / 2)) )) \
                || (( lineNo == $((remainingNoOfEmptyLines / 2 - 1)) ))
                then
                    getCentreAlignedString ${terminalWidthInChars} '++' | sed -E \
                        -e 's|^.|%|g' -e 's| $|%|g' \
                        -e 's| |-|g' \
                        -e 's|%| |g'
                    #getCentreAlignedString ${terminalWidthInChars} '##' | sed -E \
                    #    -e 's|^.|%|g' -e 's| $|%|g' \
                    #    -e 's| |#|g' \
                    #    -e 's|%| |g'
                else
                    echo "${verticalLineRow}"
                fi
            done
        ;;
    esac

    echo
    echo "${horizontalRow}"
    echo
fi




