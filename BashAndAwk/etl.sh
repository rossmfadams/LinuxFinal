#!/bin/bash
# Ross Adams
# 12/8/20
# Project: Final Project
# ./etl.sh remote_server remote_userid remote_file

# Check that parameters were given
if (($# != 3)); then
	echo "Usage: remote_server_name remote_server_userid remote_filename"; exit 1
fi
# Check that last parameter was a file
#if [[ ! -f "$3" ]]; then
#	echo "Third parameter must be a normal file ($3)"; exit 1
#fi

# Declare variables
remote_srv="$1"
remote_userid="$2"
remote_file="$3"
src_file="$(basename $remote_file)"
echo "src_file"

# This function prompts the user to delete temporary files
function rm_temp() {
	read -p "Delete Temorary Files? (y/n): "
	if [[ $REPLY = [Yy] ]]; then
		rm *.tmp
		rm MOCK*
		echo "Temporary Files Deleted"
	fi
}

# Import files
scp "$remote_userid@$remote_srv:$remote_file" .
printf "1) Importing testfile: $src_file -- complete\n"

# Extract components of the file into the project directory
bunzip2 $src_file
main_file="${src_file%.*}"
printf "2) Unzip file $main_file -- complete\n"

# Remove the header
tail -n +2 "$main_file" > "01_rm_header.tmp"
printf "3) Removed header from file -- complete\n"

# Convert all text to lower case
tr '[:upper:]' '[:lower:]' < "01_rm_header.tmp" > "02_conv_lower.tmp"
printf "4) Converted all upper to lower -- complete\n"

# Convert gender to f/m/u - External Script
awk -F "," -f "scripts/_conv_gender.awk" "02_conv_lower.tmp" > "03_conv_gender.tmp"
printf "5) Converted gender to f/m/u -- complete\n"

# Filter out all records with blank or NA in the state field and save
# them to esceptions.csv
awk -f "scripts/_filter_state.awk" "03_conv_gender.tmp"
printf "6) Filtered out records without state or NA -- complete\n"

# Remove the $ sign from the purchase_amt field
tr -d '$' < "04_filtered.tmp" > "05_rm_dollar.tmp"
printf "7) Removed the dollar sign from purchase amount -- complete\n"

# Sort by customer_id
sort -d -t',' -k 1,1 05_rm_dollar.tmp > transaction.csv
printf "8) Sorted by customer_id -- complete\n"

# Accumulate total purchase for each customer
awk -F "," -f "scripts/_sum_purchase.awk" "transaction.csv" > "06_sum_purchase.tmp"
printf "9) Accumulated total purchase for each customer -- complete\n"

# Sort based on state > zip(decending) > lastname > firstname
sort -d -t',' -k 1,1 -k 2,2r -k 3,3 -k 4,4 06_sum_purchase.tmp > summary.csv
printf "10) Sorted the purchase file -- complete\n"

# Generate Transaction Count Report
awk -f "scripts/_gen_transaction.awk" "transaction.csv" > "unsorted.tmp"
sort -t',' -k 2,2nr -k 1,1 unsorted.tmp > sorted.tmp
awk -f "scripts/_print_transaction.awk" "sorted.tmp" > "transaction-rpt"
printf "11) Generated transaction report -- complete\n"

# Generate Purchase report
awk -f "scripts/_gen_purchase.awk" "transaction.csv" > "p_unsorted.tmp"
sort -t',' -k 3,3nr -k 1,1 -k 2,2 p_unsorted.tmp > p_sorted.tmp
awk -f "scripts/_print_purchase.awk" "p_sorted.tmp" > "purchase-rpt"
printf "12) Generated purchase report -- complete\n"

rm_temp # call function to remove temp files
