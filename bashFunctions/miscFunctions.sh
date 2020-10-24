function swapValues() { # <varName_value1> <varName_value2>
    local varName_value1="${1}"
    local varName_value2="${2}"
    local buffer=''

    eval "buffer=\"\${${varName_value1}}\""
    eval "${varName_value1}=\"\${${varName_value2}}\""
    eval "${varName_value2}=\"${buffer}\""
}