#!/bin/bash

__usage="
Usage: ./countlines [OPTIONS]

Options:
  -o <name>                    Search txt files by owner name
  -m <month>                   Search txt files by month
  -h, --help                   View help
"

find_txt_by_owner() {
    owner="$1"
    count=0
    echo "Looking for files owned by $owner"
    for file in *.txt; do
        file_owner=$(stat -c %U "$file")
        file_lines=$(wc -l < "$file")
        echo "File: $file Lines: $file_lines"
        if [ $file_owner = $owner ]; then
            lines=$(wc -l < "$file")
            count=$((count + lines))
        fi
    done
    echo "Total lines in text files owned by $owner: $count"
}

find_txt_by_month() {
    month="$1"
    count=0
    echo "Looking for files from the month of $month"
    for file in *.txt; do
        file_date=$(stat -c %y "$file" | awk '{print $1}')
        file_month=$(date --date="$file_date" +"%B")
        file_lines=$(wc -l < "$file")
        echo "File: $file, Lines: $file_lines"
        if [ "$file_month" = "$month" ]; then
            lines=$file_lines
            count=$((count + lines))
        fi
    done

    echo "Total lines in text files created in month $month: $count"
}

while getopts ":o:m:h" option; do
    case $option in
        o)
            owner="$OPTARG"
            find_txt_by_owner "$owner"
            ;;
        m)
            month="$OPTARG"
            find_txt_by_month "$month"
            ;;
        h)
            printf '%s\n' "$__usage"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            printf '%s\n' "$__usage"
            ;;
        :)
            echo "Option -$OPTARG requires an argument."
            printf '%s\n' "$__usage"
            ;;
    esac
done
