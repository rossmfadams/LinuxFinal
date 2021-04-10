# Accumulate total purchase amount for each customerID and create a new csv
# with the fields: customerID,state,zip,lastname,firstname,totalpurchaseamount

{ # Body
	arr_purchase[$1]+=$6
	arr_state[$1]=$12
	arr_zip[$1]=$13
	arr_lname[$1]=$3
	arr_fname[$1]=$2
}
END {
	for (id in arr_purchase)
	{
		printf "%s,%s,%s,%s,%s,%d.2\n",id,arr_state[id],arr_zip[id],arr_lname[id],arr_fname[id],arr_purchase[id]
	}
}
