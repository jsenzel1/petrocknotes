#!/bin/bash

create_html() {
    local dir="$1"

    # Navigate into the directory
    pushd "$dir" > /dev/null

    # Use tree to create an index.html for the current directory
    tree -H '.' --noreport --charset utf-8 --filelimit 100 -P "*.txt" > index.html

    # Wrap the tree output with HTML boilerplate for macOS
    sed -i '' '1i\
<!DOCTYPE html>\
<html>\
<head>\
<title>Directory Structure<\/title>\
<\/head>\
<body>\
' index.html

    # Remove tree's default copyright info
    sed -i '' '/<hr>/,$d' index.html
    echo -e "</body>\n</html>" >> index.html

    # Recursively process subdirectories
    for subdir in */ ; do
        if [ -d "$subdir" ]; then
            create_html "$subdir"
        fi
    done

    # Return to the original directory
    popd > /dev/null
}

# Starting from the current directory
create_html "."

