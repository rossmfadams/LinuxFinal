# Convert gender to m/f/u
BEGIN {
	OFS = ","
}
{ # Body
	if ($5 ~ /1/ || $5 ~ /female/) {$5 = "f"; print}
	else if ($5 ~ /0/ || $5 ~ /male/) {$5 = "m"; print}
	else if ($5 ~ /f/ || $5 ~ /m/) {print}
	else {$5 = "u"; print}
} # Body End	
