# Print the sorted transaction report

BEGIN {
	FS = ","
	printf "%s\n\n", "Transaction Count Report"
	printf "%s    %s\n", "State", "Transaction Count"
}
{ # Body
	printf "%-9s%s\n", $1, $2
} 
