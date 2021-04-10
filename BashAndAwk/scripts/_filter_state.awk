# Filter out all records that do not have a state or contain NA
# in the state field and save them to exceptions.csv

BEGIN {
	FS = ","
	OFS = ","
}
{ # Body
	if ($12 ~ /^$/ || $12 ~ /NA/ || $12 ~ /na/) {print > "exceptions.csv"}
	else {print > "04_filtered.tmp"}
} # End Body
