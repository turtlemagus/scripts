function createList() { # <varName_list> <element1> [element2] [element3] ...
    local varName_list="${1}"
    shift

    eval "${varName_list}=()"
    while (( ${#} > 0 ))
    do
        eval "${varName_list}[\${#${varName_list}[@]}]='${1}'"
        shift
    done
}

function getListsAreEqual() { # <varName_list1> <varName_list2>
    local varName_list1="${1}"
    local currentElement1=''
    local varName_list2="${2}"
    local currentElement2=''
    local listLength=0
    local index=0

    local listsAreEqual=1
    eval "(( \${#${varName_list1}[@]} == \${#${varName_list2}[@]} )) || listsAreEqual=0"
    if (( ${listsAreEqual} ))
    then
        eval "listLength=\${#${varName_list1}[@]}"
        for (( index = 0; index <= listLength - 1; index++ ))
        do
            eval "currentElement1=\"\${${varName_list1}[${index}]}\""
            eval "currentElement2=\"\${${varName_list2}[${index}]}\""

            if [[ "${currentElement1}" != "${currentElement2}" ]]
            then
                listsAreEqual=0
                break
            fi
        done
    fi

    echo ${listsAreEqual}
}

function splitStringByDelimiter() { # <string> <delimiter> <varName_list>
    local string="${1}"
    local delimiter="${2}"

    local varName_list="${3}"
    eval "${varName_list}=()"

    local charNo=0
    local outputString=''
    if (( ${#delimiter} > 0 ))
    then
        while (( ${charNo} <= ${#string} ))
        do
            if [[ "${delimiter}" == "${string:${charNo}:${#delimiter}}" ]]
            then
                eval "${varName_list}[\${#${varName_list}[@]}]='${outputString}'"
                string="${string:$(( ${charNo} + ${#delimiter} )):${#string}}"
                outputString=''
                charNo=0
            else
                outputString="${outputString}${string:${charNo}:1}"
                charNo=$((${charNo} + 1))
            fi
        done
    else
        outputString="${string}"
    fi
    eval "${varName_list}[\${#${varName_list}[@]}]='${outputString}'"
}

function getListJoinedByDelimiter() { # <delimiter> <varName_list>
    local delimiter="${1}"
    local varName_list="${2}"

    local listLength=0
    eval "listLength=\${#${varName_list}[@]}"

    local currentElement=''
    eval "currentElement=\${${varName_list}[0]}"
    local outputString="${currentElement}"

    local index=0
    for (( index = 1; index <= listLength - 1; index++))
    do
        eval "currentElement=\${${varName_list}[${index}]}"
        outputString="${outputString}${delimiter}${currentElement}"

    done

    echo "${outputString}"
}

function outputList() { # <varName_list>
    local varName_list="${1}"

    local outputString=''
    eval "outputString=\"{ '\${${varName_list}[0]}'\""

    local listLength=0
    eval "listLength=\${#${varName_list}[@]}"

    local element=''
    local index=1
    for (( index = 1; index <= listLength - 1; index++))
    do
        eval "outputString=\"${outputString}, '\${${varName_list}[${index}]}'\""
    done
    outputString="${outputString} }"
    echo "${outputString}"
}

function deleteElementFromList() { # <index> <varName_list>
    local index=${1}
    local varName_list="${2}"

    local listLength=0
    eval "listLength=\${#${varName_list}[@]}"

    if (( ${index} <= $((${listLength} - 1)) ))
    then
        local currentIndex=0
        for (( currentIndex = index; currentIndex <= listLength - 2; currentIndex++ ))
        do
            eval "${varName_list}[${currentIndex}]=\"\${${varName_list}[$((${currentIndex} + 1))]}\""
        done
        eval "unset ${varName_list}[$((${listLength} - 1))]"
    fi
}

function insertElementIntoList() { # <index> <value> <varName_list>
    local index=${1}
    local value="${2}"
    local varName_list="${3}"

    local listLength=0
    eval "listLength=\${#${varName_list}[@]}"

    local currentIndex=0
    if (( ${index} <= ${listLength} ))
    then
        for (( currentIndex = listLength; currentIndex >= index; currentIndex-- ))
        do
            eval "${varName_list}[${currentIndex}]=\"\${${varName_list}[$((${currentIndex} - 1))]}\""
        done
    else
        for (( currentIndex = listLength; currentIndex < index; currentIndex++ ))
        do
            eval "${varName_list}[${currentIndex}]=''"
        done
    fi
    eval "${varName_list}[${index}]=\"${value}\""
}

function getFirstIndexInList() { # <searchValue> <varName_list>
    local searchValue="${1}"

    local varName_list="${2}"
    local listLength=0
    eval "listLength=\${#${varName_list}[@]}"

    local firstIndex=-1
    local currentIndex=0
    local currentValue=''
    while (( currentIndex <= listLength - 1 )) && (( firstIndex == -1 ))
    do
        eval "currentValue=\"\${${varName_list}[${currentIndex}]}\""
        if [[ "${searchValue}" == "${currentValue}" ]]
        then
            firstIndex=${currentIndex}
        fi

        currentIndex=$((currentIndex + 1))
    done
    echo ${firstIndex}
}

function getIsInList() { # <searchValue> <varName_list>

    if (( $(getFirstIndexInList "${1}" "${2}") == -1 ))
    then
        echo '0'
    else
        echo '1'
    fi
}

function getGreatestElementInList() { # <fnName_comparison> <varName_list>
    local fnName_comparison="${1}"
    local varName_list="${2}"

    local listLength=0
    eval "listLength=\${#${varName_list}[@]}"

    local greatestValue=''
    eval "greatestValue=\"\${${varName_list}[0]}\""

    local comparisonOutput=0
    local currentValue=''
    local index=1
    for (( index = 1; index <= listLength - 1; index++ ))
    do
        eval "currentValue=\"\${${varName_list}[${index}]}\""
        eval "comparisonOutput=\"\$(${fnName_comparison} \"${currentValue}\" \"${greatestValue}\")\""

        if (( ${comparisonOutput} > 0 ))
        then
            greatestValue="${currentValue}"
        fi
    done
    echo "${greatestValue}"
}

function getLeastElementInList() { # <fnName_comparison> <varName_list>
    local fnName_comparison="${1}"
    local varName_list="${2}"

    local listLength=0
    eval "listLength=\${#${varName_list}[@]}"

    local leastValue=''
    eval "leastValue=\"\${${varName_list}[0]}\""

    local comparisonOutput=0
    local currentValue=''
    local index=1
    for (( index = 1; index <= listLength - 1; index++ ))
    do
        eval "currentValue=\"\${${varName_list}[${index}]}\""
        eval "comparisonOutput=\"\$(${fnName_comparison} \"${currentValue}\" \"${leastValue}\")\""

        if (( ${comparisonOutput} < 0 ))
        then
            leastValue="${currentValue}"
        fi
    done
    echo "${leastValue}"
}

function justifyElementsInList() { # <varName_list> [alignment]
    local thisFileDirPath="$(dirname "${BASH_SOURCE[0]}")"
    source "${thisFileDirPath}/comparisonFunctions.sh"
    source "${thisFileDirPath}/stringFunctions.sh"

    local varName_list="${1}"

    local alignment='LEFT'
    (( ${#} >= 2 )) && alignment="${2}"

    local longestElement=$(getGreatestElementInList 'compareStringLengths' "${varName_list}")

    local listLength=''
    eval "listLength=\${#${varName_list}[@]}"

    local index=0
    for (( index = 0; index <= listLength - 1; index++ ))
    do
        if [[ 'RIGHT' == ${alignment} ]]
        then
            eval "${varName_list}[${index}]=\"\$(getRightAlignedString ${#longestElement} \"\${${varName_list}[${index}]}\")\""

        elif [[ 'CENTRE' == ${alignment} ]] || [[ 'CENTER' == ${alignment} ]]
        then
            eval "${varName_list}[${index}]=\"\$(getCentreAlignedString ${#longestElement} \"\${${varName_list}[${index}]}\")\""

        else
            eval "${varName_list}[${index}]=\"\$(getLeftAlignedString ${#longestElement} \"\${${varName_list}[${index}]}\")\""
        fi
    done
}


