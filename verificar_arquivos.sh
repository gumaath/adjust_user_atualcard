find . -type f -exec sh -c 'echo "File: {}"; cat {}; echo "--------------------------------------"' \; | less
