#!/bin/zsh

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --usecolor)
            USE_COLOR=1
            shift
            ;;
        --paged)
            USE_PAGING=1
            shift
            ;;
        -*)
            echo "Error: Unknown option '$1'. Valid options are --usecolor and --paged." >&2
            echo "Syntax: ls-dataless folder_name [--paged] [--usecolor]"
            exit 1
            ;;
        *)
            if [[ -z "$directory" ]]; then
                directory="$1"
            else
                echo "Error: Only one directory argument is allowed." >&2
                echo "Syntax: ls-dataless folder_name [--paged] [--usecolor]"
                exit 1
            fi
            shift
            ;;
    esac
done

if [[ -z $directory ]] ; then
    echo "Must Specify a folder." >&2
    echo "Syntax: ls-dataless folder_name [--paged] [--usecolor]"
    exit 1
fi

# Check if output is a terminal
if [ -t 1 ]; then
  USE_COLOR=1
  #cPINK="\033[38;5;218m"
  #cGREEN="\033[38;5;151m"
  #cYELLOW="\033[38;5;229m"
  #cPEACH="\033[38;5;217m"
fi

# Check if directory exists
if [[ ! -d "$directory" ]]; then
    echo "Error: Directory '$directory' not found"
    exit 1
fi

# Get Full Path if $file_path
real_path=$(realpath $directory)
icloud_dir="${HOME}/Library/Mobile Documents/com~apple~CloudDocs"

# If inside $basedir then target is relative to current folder
if [[ ! "$real_path" == "$icloud_dir"/* ]]; then
    echo "Folder specified must be inside iCloud Folder."
    exit 3
fi

# Store AWK code in a variable
awk_program='
BEGIN {
    # Define pastel blue and reset escape sequences
    blue   = (use_color == 1) ? "\033[38;5;153m" : ""
    purple = (use_color == 1) ? "\033[38;5;183m" : ""
    reset  = (use_color == 1) ?  "\033[0m" : ""
	printf "%s\n\n", purple "List of files that can be evicted..." reset
	printf "%s\n", blue dir ":" reset
}
{
    # Skip evicted files (records where the first field ends with %)
    if ($1 ~ /%$/ || $1 ~ /total/) {
        next
    }

    # If first char of $1 is "-", print perms + filename
    if (substr($1,1,1) == "-") {
        #if(LastRecord ~ "^" dir) {
        if (index(LastRecord, dir) == 1 && LastRecord ~ /:$/) {
            printf "\n%s\n", blue LastRecord reset
        }
        # Print fields from $8 to $NF with spaces
        printf "   "
        for (i = 8; i <= NF; i++) {
            printf "%s", $i
            if (i < NF) printf " "  # Add space between fields, but not after the last one
        }
        printf "\n"
    } 
    LastRecord=$0
}
'

# List files that can be evicted
if [[ $USE_PAGING -eq 1 ]]; then
    ls -oaXR% $directory | grep -v "^d" | \
    awk -v dir="$directory" -v use_color="$USE_COLOR" \
    "$awk_program" | less -R
else
   ls -oaXR% $directory | grep -v "^d" | \
   awk -v dir="$directory" -v use_color="$USE_COLOR" \
   "$awk_program" 
fi

echo
