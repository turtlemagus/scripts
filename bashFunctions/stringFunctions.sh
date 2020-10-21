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

# TODO:
# - getConcatenatedString <string1> [string2] [string3] ...
# - getRepeatedString


