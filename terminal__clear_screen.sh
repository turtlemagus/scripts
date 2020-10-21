noOfEmptyLines=$(tput lines)
(( ${#} > 0 )) && noOfEmptyLines=${1}

printf "%${noOfEmptyLines}s" | tr ' ' '\n'
