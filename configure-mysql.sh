#!/usr/bin/env bash
# Setup the apq-mysql.ads file from the MySQL's Sources.





###########
# Testing #
###########


# Test if the input is empty
# Prints [ok] and [fail] and set the exit code accordingly
test_is_set(){
	if [[ "$1" = "" ]]
	then
		echo "[fail]";
		exit -1;
	else
		echo "[ok]";
	fi;
}




###################
# Data retrieving #
###################


# Field Types #

generate_field_type_c_chunk(){
	HDRFILE="${MYSQL_INCLUDE_PATH}/mysql_com.h"
	sed <"$HDRFILE" -n '/enum_field_types/,/};/p' | sed 's|enum||;s|enum_field_types||;s|[{};]||g;s|,|\
|g;s|[ 	]*||g' | sed '/^$/d;s|=[0-9]*||g' \
        | while read NAME ; do
                echo "  { \"$NAME\", $NAME },"
        done
        echo "  { 0, 0 }"
}


# Print into the standart output the list of MySQL codes for data types
get_field_type_codes(){
	generate_field_type_c_chunk > "$TMP_PATH/mysql_type_codes.h"
	cp src-in/mysql_gentyp.c "$TMP_PATH/"
	$CC "${TMP_PATH}/mysql_gentyp.c" -o "${TMP_PATH}/mysql_gentyp" $MYSQL_CFLAGS $MYSQL_LIBS -I"${TMP_PATH}" && ./"$TMP_PATH/mysql_gentyp"
}



# Error Codes #



generate_error_code_c_chunk(){
	HDR1="${MYSQL_INCLUDE_PATH}/errmsg.h"
	HDR2="${MYSQL_INCLUDE_PATH}/mysqld_error.h"

	cat "$HDR1" "$HDR2" \
		| grep -v ERROR_LAST \
		| grep -v ERROR_FIRST \
		| sed -n '/^# *define *CR_[A-Za-z0-9_]* */p;/^# *define *ER_[A-Za-z0-9_]* */p' \
		| sed 's|/\*.*\*/||g;s| *$||' \
		| sed 's|# *define *||' \
		| while read NAME VALUE ; do
			echo "	{ \"$NAME\", $NAME },"
		done
		echo "#ifndef CR_NO_ERROR"
		echo "	{ \"CR_NO_ERROR\", 0 },"
		echo "#endif"
		echo "	{ 0, 0 }"
}

# Print into the standart output the list of MySQL codes for errors
get_error_codes(){
	generate_error_code_c_chunk > "$TMP_PATH/mysql_errmsg.h"
	cp src-in/mysql_generr.c "$TMP_PATH/"
	$CC "${TMP_PATH}/mysql_generr.c" -o "${TMP_PATH}/mysql_generr" $MYSQL_CFLAGS $MYSQL_LIBS -I"${TMP_PATH}" && ./"$TMP_PATH/mysql_generr"
}


