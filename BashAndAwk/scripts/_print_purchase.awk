# Print the purchase summary report
BEGIN {
	FS = ","
	printf "%s\n\n", "Purchase Summary Report"
	printf "%s    %s   %s\n", "State","Gender","Purchase Amount"
}
{ # Body
	printf "%-9s%-9s%.2f\n",$1,$2,$3
}
