# Generate Purchase Summary Report

BEGIN {
	FS = ","
	OFS = ","
}
{ # Body
	arr_amount[toupper($12),toupper($5)]+=$6
}
END {
	for (comb in arr_amount) {
		split(comb,sep,SUBSEP);
		printf "%s,%s,%.2f\n", sep[1], sep[2], arr_amount[sep[1],sep[2]]
	}
}
