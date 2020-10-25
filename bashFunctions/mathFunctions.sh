function getSign() { # <number>
    local number=${1}

    if (( $(echo "${number} < 0" | bc --mathlib) ))
    then
        echo '-1'

    elif (( $(echo "${number} == 0" | bc --mathlib) ))
    then
        echo '0'
    else
        echo '1'
    fi
}