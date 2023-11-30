selected=$(grep --line-buffered --color=never -H -r "" -- * | fzf --height=40%)

file_with_name=$(echo "$selected" | awk -F# '{print $1}')
file=$(echo "$file_with_name" | awk -F: '{print $1}')
# Last awk command trims leading and trailing whitespace
name=$(echo "$file_with_name" | awk -F: '{print $2}' | awk '{$1=$1};1')
details=$(echo "$selected" | awk -F# '{print $2}')

grey="\e[37m"
italic="\e[3m"
clear="\e[0m"

# shellcheck disable=SC3037
echo -e "${grey}${file}:$clear"
# shellcheck disable=SC3037
echo -e "  $name  $italic#${details}$clear"
