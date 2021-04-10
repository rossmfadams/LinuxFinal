# Generate a report showing the number of transactions by state abbreviation
BEGIN {
	FS = ","
	OFS = ","
}
{ # Body
	arr_count[toupper($12)]+=1
}
END {
	# Create unsorted CSV of the array
	for (id in arr_count) {
		printf "%s,%s\n", id, arr_count[id]
	}
}


