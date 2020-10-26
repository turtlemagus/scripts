function getRegexForLiteral() { # <literal>
    echo "${1}" | sed -E \
        -e 's|\\|\\\\|g'                \
        -e 's|\.|\\.|g'                 \
        -e 's|\^|\\^|g'                 \
        -e 's|\$|\\$|g'                 \
        -e 's|\*|\\*|g'                 \
        -e 's|\+|\\+|g'                 \
        -e 's/\|/\\|/g'                 \
        -e 's|\(|\\(|g' -e 's|\)|\\)|g' \
        -e 's|\[|\\[|g' -e 's|\]|\\]|g' \
        -e 's|\{|\\{|g' -e 's|\}|\\}|g'
}

function getRepeatedString() { # <noOfRepetitions> <string>
    local noOfRepetitions=${1}
    local string="${2}"

    if (( noOfRepetitions > 0 ))
    then
        printf "%${noOfRepetitions}s" | sed -E "s| |${string}|g"
    else
       printf "%$((-noOfRepetitions))s" | sed -E "s| |$(rev <<< "${string}")|g"
    fi
}

function getMaskedString() { # <startIndex> <maskingString> <string> [noOfRepetitions]
    local startIndex=${1}
    local string="${3}"

    local noOfRepetitions=1
    (( ${#} >= 4 )) && noOfRepetitions=${4}

    local maskingString="$(getRepeatedString ${noOfRepetitions} "${2}")"

    local beforeString=''
    (( startIndex > 0 )) && beforeString="${string:0:startIndex}"

    local maskingStringLength=${#maskingString}
    local stringLength=${#string}
    local afterString=''
    (( startIndex < stringLength - 1)) \
        && afterString="${string:$((startIndex + maskingStringLength)):${stringLength}}"

    string="${beforeString}${maskingString}${afterString}"
    string="${string:0:${stringLength}}"
    echo "${string}"
}

function getLeftAlignedString() { # <targetWidth> <string>
    local targetWidth=${1}
    local string="${2}"

    if (( targetWidth > ${#string} ))
    then
        echo "${string}$(printf "%$((targetWidth - ${#string}))s")"
    else
        echo "${string:0:${targetWidth}}"
    fi
}

function getCentreAlignedString() { # <targetWidth> <string>
    local targetWidth=${1}
    local string="${2}"

    if (( targetWidth > ${#string} ))
    then
        local noOfSpaces=$((targetWidth - ${#string}))
        local leftWidth=$((noOfSpaces / 2))
        local rightWidth=$((noOfSpaces - leftWidth))
        echo "$(printf "%${leftWidth}s")${string}$(printf "%${rightWidth}s")"
    else
        local startCharNo=$(( (${#string} - targetWidth) / 2))
        echo "${string:${startCharNo}:${targetWidth}}"
    fi
}

function getRightAlignedString() { # <targetWidth> <string>
    local targetWidth=${1}
    local string="${2}"

    if (( targetWidth > ${#string} ))
    then
        echo "$(printf "%$((targetWidth - ${#string}))s")${string}"
    else
        echo "${string:$((${#string} - targetWidth)):${targetWidth}}"
    fi
}

# TODO:
# - getConcatenatedString <string1> [string2] [string3] ...
# - getRepeatedString


