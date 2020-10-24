regex_emptyLine='^$'
find . -type f | {
while read currentFilePath
do
    if [[ ! "$(tail -1 "${currentFilePath}")" =~ ${regex_emptyLine} ]]
    then
        echo "Adding empty line to the end of '${currentFilePath}'"
        echo >> "${currentFilePath}"
    fi
done
}

