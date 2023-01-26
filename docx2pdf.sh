#!/bin/bash

# This script converts all .docx files in the current directory to .pdf using the command line tool "libreoffice"

# loop through all .docx files in the current directory
for file in *.docx; do
    # convert the file to pdf
    libreoffice --headless --convert-to pdf "$file"
    # rename the file with .pdf extension
    mv "${file%.*}.pdf" "${file%.*}.pdf"
done

echo "All .docx files in the current directory have been converted to .pdf"
