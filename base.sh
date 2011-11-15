#!/bin/bash
#: title	: base
#: date		: 2011-jul-09
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.2.6
#: Description: base scripts and functions for configuring,compiling and installing.
#: Description: You don't need run this script manually.
#: Description: For It use makefile targets. See INSTALL file.

if [ $# -eq 0 ]; then
	printf "not ok. I need minimum of 1 options\n"
	exit 1;
fi;

case ${1,,} in  
	"configure" ) my_commande='configuring' ;;
	"compile" ) my_commande='compilling' ;;
	"install" ) my_commande='installing' ;;
	"clean" ) my_commande='cleaning' ;;
	"distclean" ) my_commande='dist_cleaning' ;;
	* ) printf "not ok. I dont known this command :-\)\n" ;
		exit 1
		;;
esac;

shift 1 ;

global_ifs_bk="$IFS"

##################################
##### support functions ##########
##################################

#####################
### sanitization  ###
#####################

_choose_so(){
#: title	: _choose_so
#: date		: 2011-jul-15
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.0
#: Description: sanitize list of Systems Operations separated by ","
#: Options	:  "OSes"

local _oses=$1
_oses=${_oses:=linux}
_oses=${_oses,,}
local my_oses=
local a=
for a in linux mswindows darwin bsd other
do
	case $_oses in
		*all*) my_oses=linux,mswindows,darwin,bsd,other
			break
			;;
		*"$a"*) my_oses=${my_oses:+${my_oses},}$a
			;;
	esac
done
my_oses=${my_oses:=linux}
printf $my_oses

} # end 

_choose_libtype(){
#: title	: _choose_libtype
#: date		: 2011-jul-15
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.0
#: Description: sanitize list of lib types separated by ","
#: Options	: "libtype,libtype_n"

local _libtypes=$1
_libtypes=${_libtypes:=dynamic,static}
_libtypes=${_libtypes,,}
local my_libtypes=
local a=
for a in static dynamic relocatable
do
	case $_libtypes in
		*all*) my_libtypes=static,dynamic,relocatable
			break
			;;
		*"$a"*) my_libtypes=${my_libtypes:+${my_libtypes},}$a
			;;
	esac
done
my_libtypes=${my_libtypes:=dynamic,static}
printf $my_libtypes

} # end 

_choose_debug(){
#: title	: _choose_debug
#: date		: 2011-jul-15
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.0
#: Description: choose the type of lib, related about debug information.
#: Options	:  "with_debug_too"

local _with_debug_too=$1
_with_debug_too=${_with_debug_too:=no}
_with_debug_too=${_with_debug_too,,}
local my_with_debug_too=

case $_with_debug_too in
	*onlydebug* )	my_with_debug_too=debug
		;;
	*yes* )	  my_with_debug_too=normal,debug
		;;
	*no* )	  my_with_debug_too=normal
		;;
esac
my_with_debug_too=${my_with_debug_too:=normal}
printf $my_with_debug_too

} # end

_discover_acmd_path(){
#: title	: _discover_acmd_path
#: date		: 2011-jul-15
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.02
#: Description:  Discover automatically a _PATH_ for a command OR use a default.
#: Options	: "cmd" "add_these_path(s)" "or_default_path"
# need more sanitization
#
local cmdo="$1"
local these_paths="$2"
local default_path="$3"
local path_backup="$PATH"
case $cmdo in
	*[\)\({}$]* )  printf '/usr/bin/boo' ; exit 1
		;;
esac
local my_path="$(PATH="$these_paths:$path_backup"; which "$cmdo" || printf "$default_path/stub" )"
printf "$(dirname $my_path )"

} #end

_sanatize_enum(){
#: title	: _sanatize_enum
#: date		: 2011-nov-12
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.0
#: Description: sanitize list of enums separate ",\n" and add "label => value,"
#: dont worry ;-) _sanatize_enum is enough smart. :-)
#: Options	: "list"
#: returns 	: the list sanitizade
	if [ $# -ne 1 ]; then
		printf "not ok. I need 1 option\n"
		exit 1;
	fi;
	local my_enum_list="$1"
	local my_enum_list_nol=$( printf "$my_enum_list" | sed -n -e '$=' )
	# because "enum c" rules don't oblige all labels have a '=' ;
	# the rule states that after a '=' (before follow lines with '=' ) the 
	# next labels will getting '+1' in sequence 
	# until before newer '=' and so on :-)
	count0=1
	a=$(printf "$my_enum_list" |  sed -n -e "$count0"' p' | grep -o '=[ ]*[0-9]*' | grep -o '[0-9]*' )
	b="-1"
	if [ -n "$a" ]; then
		b="$a"
	fi	
	while [ ${count0:=1} -le ${my_enum_list_nol} ];
	do
		a=$(printf "$my_enum_list" |  sed -n -e "$count0"' p' | grep -o '=[ ]*[0-9]*' | grep -o '[0-9]*' )
		if [ -n "$a" ]; then
			b=$a			
		else
			b=$(( $b + 1 ))				
			my_enum_list=$( printf "$my_enum_list" | sed -e "$count0"' s/[ ,]*$/='"$b"',/ ' ) 
		fi
		count0=$(( $count0 + 1 ))	
	done
	my_enum_list=$( printf "$my_enum_list" | sed -e 's/[=]/ => / ' | sed -e '$ s/[ ,]*$//' )
	printf "$my_enum_list"
} #end

_sanatize_enum_remove_values(){
#: title	: _sanatize_enum_remove_values
#: date		: 2011-nov-12
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.0
#: Description: remove "=> number" from list processed by _sanatize_enum() :-)
#: Options	: "list"
#: returns 	: the list sanitizade
	if [ $# -ne 1 ]; then
		printf "not ok. I need 1 option\n"
		exit 1;
	fi;
	local my_enum_list="$1"
#	my_enum_list=$( printf "$my_enum_list" | sed -e 's/[=].*$/,/ ' | sed -e '$ s/[ ,]*$//' )
	my_enum_list=$( printf "$my_enum_list" | sed -e 's/[[:blank:][:space:]]*[=].*$/,/ ' | sed -e '$ s/[ ,]*$//' )

	printf "$my_enum_list"
} #end


##################################
##### target functions ##########
##################################

_configure(){
#: title	: configure
#: date		: 2011-oct-25
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.05
#: Description: made configuration for posterior compiling by gprbuild.
#: Description: You don't need run this script manually.
#: Options	:  "OSes" "libtypes,libtypes_n" "compiler_path1:compiler_pathn"  \
#:		"system_libs_path1:system_libs_pathn"  "ssl_include_paths" "mysql_config_path"  \
#:		"gprconfig_path"  "gprbuild_path"  "with_debug_too"

local my_atual_dir=$(pwd)

# Silent Reporting, because apq_mysql_error.log or  don't exist or don't is a regular file or is a link
if [ ! -f "$my_atual_dir/apq_mysql_error.log" ] || [ -L "$my_atual_dir/apq_mysql_error.log" ] || [ -L "$my_atual_dir/ok.log" ]; then
	exit 1
	echo "oi"
fi

if [ $# -ne 9 ]; then
	{	printf "\n"
		printf 'not ok. You dont need use it by hand. read INSTALL for more info and direction.'
		printf "\n"
		printf 'configura "OSes" "libtype,libtype_n" "compiler_path1:compiler_path_n" "system_libs_path1:system_libs_paths_n"  "ssl_include_path" "mysql_config_path"  "gprconfig_path"  "gprbuild_path"  "build_with_debug_too" '
		printf "\n"
	}>"$my_atual_dir/apq_mysql_error.log"

	printf 'false'>"$my_atual_dir/ok.log"
	exit 1
fi
# remove old content from apq_mysql_error.log
printf "" > "$my_atual_dir/apq_mysql_error.log"

local ifsbackup="$IFS"
local IFS="$ifsbackup"

local my_version=$(cat version)
local my_oses=$(_choose_so "$1" )
local my_libtypes=$(_choose_libtype "$2" )

local _base_name=
local my_compiler_paths=$3
local my_system_libs_paths=
local _system_libs_paths=$4
local my_ssl_include_path=
local _ssl_include_path=$5
local my_mysql_config_path=
local _mysql_config_path=$6
local my_gprconfig_path=
local _gprconfig_path=$7
local my_gprbuild_path=
local _gprbuild_path=$8
local my_with_debug_too=$(_choose_debug "$9" )


# fix me if necessary:
# need more sanitization
_mysql_config_path=${_mysql_config_path:=$(_discover_acmd_path "mysql_config" "$my_compiler_paths" "/usr/bin" )}
#_pg_config_path=${_pg_config_path//[''``]/""}
my_mysql_config_path="$_mysql_config_path"

_gprconfig_path=${_gprconfig_path:=$(_discover_acmd_path "gprconfig" "$my_compiler_paths" "/usr/bin" )}
my_gprconfig_path="$_gprconfig_path"

_gprbuild_path=${_gprbuild_path:=$(_discover_acmd_path "gprbuild" "$my_compiler_paths" "/usr/bin" )}
my_gprbuild_path="$_gprbuild_path"

_ssl_include_path=${_ssl_include_path:=/usr/lib/openssl}
my_ssl_include_path=${_ssl_include_path}

_system_libs_paths=${_system_libs_paths:=/usr/lib}

local at_count=
local max_count=11
# 10(ten) libs is a reasonable value for now.
# if you need more , feel free to contact us and suggest changes. :-)
IFS=";:$ifsbackup"

for alibdirsystem in $_system_libs_paths
do
	[ ${at_count:=1} -ge ${max_count:=11} ] && break;
	madeit=" lib_system$at_count=\"-L$alibdirsystem\"  "
	eval $madeit
	at_count=$(( $at_count + 1 ))
	my_system_libs_paths="${my_system_libs_paths:+${my_system_libs_paths}:}$alibdirsystem"

done
IFS=",$ifsbackup"

local made_dirs="$my_atual_dir/build"
local src_genesis="$my_atual_dir/src_genesis"
local my_my_config="$my_mysql_config_path"

while true;
do
	[ -d "$my_my_config" ] && break
	my_my_config=$(dirname "$my_my_config" )
done

local mysql_include_error=$( "$my_my_config"/mysql_config --include 2>&1 >/dev/null)
local mysql_include=$( "$my_my_config"/mysql_config --include | sed  -e  's/^[^/:\]*\(.[:].*\|[/\].*\)/\1/')

if [ -n  "$mysql_include_error" ] || [ ! -d "$mysql_include" ]; then
	{ printf "\n\nmysql_config\t:\t setup:\tnot ok\n Or $my_my_config/mysql_config  don't exist\n or mysql include dir '$mysql_include' don't is a directory.\n This can being caused by a invalid my_config_path,too.\n" 
	printf "\nthere is a chance an error occurred.\nsee the above messages and correct if necessary.\n\n not ok. \n\n" 
	}>>"$my_atual_dir/apq_mysql_error.log"

	printf 'false' > "$my_atual_dir/ok.log" ;
	exit 1
fi
	local my_enum_option_tmp=$( sed  -e 's:\(^.*\)/[*].*[*]/\(.*$\):\1\2:g' -e  's/\(^.*\)\/\*\(.*$\)/\1 \n\/\*\n \2/g' -e  's/\(^.*\)\*\/\(.*$\)/\1 \n\*\/\n \2/g' "$mysql_include"/mysql.h | sed -e '/\/\*.*$/,/\*\/.*$/d' |  sed -n   '/^[[:blank:]]*enum[[:blank:]]*[mM][yY][sS][qQ][lL]_[oO][pP][tT][iI][oO][nN]\([[:blank:][:space:]]*$\|[[:blank:][:space:]]*[{]\([[:blank:][:space:]]*$\|[[:blank:][:space:]]*\w*\)\)/,/[[:blank:][:space:]]*[}][[:blank:][:space:]]*[;]/ p'  | sed  -e 's/[;].*$/\;/g'   -e '/^$/d' -e 's/[[:blank:][:space:]]*//g'  -e 's/[{]\(..*$\)/\{\n\1/g' -e 's/\(^..*\)[}][;]/\1\n\}\;/g' -e 's/\,/\,\n/g'  |  sed -n -e '1,/[}][;]/ p' | sed -e '/^$/d' | sed  -e '/[{]/,/[}][;]/!d' | sed -e '/^.*[{}].*$/d' 2>>"$my_atual_dir/apq_mysql_error.log" )
	
	local my_field_types_tmp=$(sed  -e 's:\(^.*\)/[*].*[*]/\(.*$\):\1\2:g' -e  's/\(^.*\)\/\*\(.*$\)/\1 \n\/\*\n \2/g' -e  's/\(^.*\)\*\/\(.*$\)/\1 \n\*\/\n \2/g' "$mysql_include"/mysql_com.h | sed -e '/\/\*.*$/,/\*\/.*$/d' |  sed -n   '/^[[:blank:]]*enum[[:blank:]]*[eE][nN][uU][mM]_[fF][iI][eE][lL][dD]_[tT][yY][pP][eE][sS]\([[:blank:][:space:]]*$\|[[:blank:][:space:]]*[{]\([[:blank:][:space:]]*$\|[[:blank:][:space:]]*\w*\)\)/,/[[:blank:][:space:]]*[}][[:blank:][:space:]]*[;]/ p'  | sed  -e 's/[;].*$/\;/g'   -e '/^$/d' -e 's/[[:blank:][:space:]]*//g'  -e 's/[{]\(..*$\)/\{\n\1/g' -e 's/\(^..*\)[}][;]/\1\n\}\;/g' -e 's/\,/\,\n/g'  |  sed -n -e '1,/[}][;]/ p' | sed -e '/^$/d' | sed  -e '/[{]/,/[}][;]/!d' | sed -e '/^.*[{}].*$/d' 2>>"$my_atual_dir/apq_mysql_error.log" )

	local enum_option_value=$(_sanatize_enum "$my_enum_option_tmp" )
	local enum_option_label_only=$(_sanatize_enum_remove_values "$enum_option_value" )

	local my_field_types_value=$(_sanatize_enum "$my_field_types_tmp" )
	local my_field_types_label_only=$(_sanatize_enum_remove_values "$my_field_types_value" )

	local my_result_type_er_tmp=$(sed  -e 's:\(^.*\)/[*].*[*]/\(.*$\):\1\2:g' -e  's/\(^.*\)\/\*\(.*$\)/\1 \n\/\*\n \2/g' -e  's/\(^.*\)\*\/\(.*$\)/\1 \n\*\/\n \2/g' "$mysql_include"/mysqld_error.h | sed -e '/\/\*.*$/,/\*\/.*$/d' |  grep -v ERROR_LAST | grep -v ERROR_FIRST | grep '^#define[ ]*ER_.*' | grep -o 'ER_.*[0-9]*[[:blank:][:space:]]*$' | sed 's/[[:blank:][:space:]]*\([0-9]*\)[[:blank:][:space:]]*$/ => \1,/' )
	
	local my_result_type_cr_tmp=$(sed  -e 's:\(^.*\)/[*].*[*]/\(.*$\):\1\2:g' -e  's/\(^.*\)\/\*\(.*$\)/\1 \n\/\*\n \2/g' -e  's/\(^.*\)\*\/\(.*$\)/\1 \n\*\/\n \2/g' "$mysql_include"/errmsg.h | sed -e '/\/\*.*$/,/\*\/.*$/d' |  grep -v ERROR_LAST | grep -v ERROR_FIRST | grep -v MIN_ERROR | grep -v MAX_ERROR | grep '^#define[ ]*CR_.*' | grep -o 'CR_.*[0-9]*[[:blank:][:space:]]*$' | sed 's/[[:blank:][:space:]]*\([0-9]*\)[[:blank:][:space:]]*$/ => \1,/' | sed -e '$ s/,//' )

	local my_result_type_value="$my_result_type_er_tmp\n$my_result_type_cr_tmp"
	local a=$(printf "$my_result_type_value" | grep CR_NO_ERROR )
	[ ! -n "$a" ] && my_result_type_value="CR_NO_ERROR => 0 ,\n$my_result_type_value"
	local my_result_type_label_only=$( _sanatize_enum_remove_values "$my_result_type_value")
	my_result_type_er_tmp=
	my_result_type_cr_tmp=
	a=
	#############################################
	local my_field_types_value_esc=$(printf "$my_field_types_value" | sed -e 's/^/\t&/' | sed -e 's/$/\\&/')
	local my_field_types_label_only_esc=$(printf "$my_field_types_label_only" | sed -e 's/^/\t&/' | sed -e 's/$/\\&/')
	local my_result_type_value_esc=$(printf "$my_result_type_value" | sed -e 's/^/\t&/' | sed -e 's/$/\\&/')
	local my_result_type_label_only_esc=$(printf "$my_result_type_label_only" | sed -e 's/^/\t&/' | sed -e 's/$/\\&/')
	local enum_option_value_esc=$(printf "$enum_option_value" | sed -e 's/^/\t\t&/' | sed -e 's/$/\\&/')
	local enum_option_label_only_esc=$(printf "$enum_option_label_only" | sed -e 's/^/\t\t&/' | sed -e 's/$/\\&/')
	my_field_types_value=
	my_field_types_label_only=
	my_result_type_value=
	my_result_type_label_only=
	enum_option_value=
	enum_option_label_only=

	local mysql_config_libs=$("$my_my_config/mysql_config" --libs)
	local miname=$(uname -s)
	### if necessary, fix me ; in a cross-compiling environment, using "uname" is the correct thing to do ?
	local pragma_linker_options=

	local pragma_linker_oopt=$(	
		case "$miname" in
			( *CYGWIN* ) pragma_linker_options='   --! pragma Linker_Options("");'
					;;
			( * )	for miarg in $mysql_config_libs
					do
						echo "pragma Linker_Options(\"$miarg\");"
					done
					;;
		esac;
	)

## because quotes , _IS Mandatory_  a one or more(1+) espaces characters before the closing "/" or  "\n/" in each sed script :-)
## THANKS Jesus! et al ;-) Enjoy!
	local my_apq_mysql_ads_0=$(cat "$src_genesis/apq-mysql.ads-in" | 
sed -e "s/%ENUM_FIELD_TYPE%/$my_field_types_label_only_esc  \n/" |
sed -e "s/%USE_FIELD_TYPE%/$my_field_types_value_esc  \n/" | 
sed -e "s/%ENUM_RESULT_TYPE%/$my_result_type_label_only_esc  \n/" | 
sed -e "s/%USE_RESULT_TYPE%/$my_result_type_value_esc  \n/" | 
sed -e "s/%OPTION_ENUM_MY%/$enum_option_label_only_esc  \n/" | 
sed -e "s/%USE_OPTION_ENUM_MY%/$enum_option_value_esc  \n/"  |
sed -e 's/%MYSQL_ROW_NO%/64 /')

local my_apq_mysql_ads_1=$( echo "$my_apq_mysql_ads_0" | sed -n -e '1,/%mysql_linker_options%/ p' | sed -e '/%mysql_linker_options%/ d' )
local my_apq_mysql_ads_2=$( echo "$my_apq_mysql_ads_0" | sed -n -e '/%mysql_linker_options%/,$ p' | sed -e '/%mysql_linker_options%/ d' )

local my_apq_mysql_ads=$( echo "$my_apq_mysql_ads_1"; echo "$pragma_linker_oopt"; echo "$my_apq_mysql_ads_2" )

	my_field_types_value_esc=
	my_field_types_label_only_esc=
	my_result_type_value_esc=
	my_result_type_label_only_esc=
	enum_option_value_esc=
	enum_option_label_only_esc=
	my_apq_mysql_ads_0=
	my_apq_mysql_ads_1=
	my_apq_mysql_ads_2=
	pragma_linker_oopt=

	IFS="$ifsbackup"  # the min one blank line below here _is necessary_ , otherwise IFS will affect _only_ next command_ ;-)

	local kov_log=$(
		echo "$my_ssl_include_path"
		echo "$my_compiler_paths"
		echo "$my_gprconfig_path"
		echo "$my_gprbuild_path"
		echo "$my_my_config"
		echo "$my_system_libs_paths"
		printf "\n"
	)

	local madeit3=
	local at_count_tmp=
	local madeit2=
	local at_count_tmp="1"

	local kov_def1=$(
		echo "version:=\"$my_version\"  "
		echo "mysource:=\"$my_atual_dir/src/\"  "
		echo "basedir:=\"$my_atual_dir/build\"  "
	)
	while [ "$at_count_tmp" -lt ${at_count:=11} ];
	do
		madeit2="lib_system$at_count_tmp"
		madeit3="${madeit3:+${madeit3},} \$$madeit2 "
		local kov_def2=$(
			echo "${madeit2}:=\"${!madeit2}\""
		)
		at_count_tmp=$(( $at_count_tmp + 1 ))
	done

	local kov_def=$(
		echo "$kov_def1"
		echo "$kov_def2"
	)
	kov_def1=
	kov_def2=
	
	local apq_mysql_gpr_in=$(
		cat "$my_atual_dir/apq_mysql_part1.gpr.in.in"  2>>"$my_atual_dir/apq_mysql_error.log"
		printf  '   system_libs  := ( ) & (' 
		printf  "$madeit3 " 
		printf  '); ' 
		cat "$my_atual_dir/apq_mysql_part3.gpr.in.in"   2>>"$my_atual_dir/apq_mysql_error.log"
	)

IFS=",$ifsbackup"

for sist_oses in $my_oses
do
	for libbuildtype in $my_libtypes
	do
		for debuga in $my_with_debug_too
		do
			my_tmp="$made_dirs"/$sist_oses/$libbuildtype/$debuga
			mkdir -p "$my_tmp/logged"
			
			IFS="$ifsbackup"  # the min one blank line below here _is necessary_ , otherwise IFS will affect _only_ next command_ ;-)

			# because use of vars, I added a "\n" :-) in 
			printf "$kov_log\n" > "$my_tmp/logged/kov.log"  2>>"$my_atual_dir/apq_mysql_error.log"

			printf "$kov_def\n" > "$my_tmp/logged/kov.def" 2>>"$my_atual_dir/apq_mysql_error.log"

			echo "$apq_mysql_gpr_in" > "$my_tmp/apq_mysql.gpr.in"  2>>"$my_atual_dir/apq_mysql_error.log"

			gnatprep "$my_tmp/apq_mysql.gpr.in"  "$my_tmp/apq_mysql.gpr"  "$my_tmp/logged/kov.def"  2>>"$my_atual_dir/apq_mysql_error.log"
			
			IFS=",$ifsbackup"

			for support_dirs in obj lib ali obj_c lib_c ali_c src
			do
				mkdir -p "$my_tmp/$support_dirs"  2>>"$my_atual_dir/apq_mysql_error.log"
			done # support_dirs
			
			echo "$my_apq_mysql_ads" > "$my_tmp/src/apq-mysql.ads"  2>>"$my_atual_dir/apq_mysql_error.log"

		done # debuga
	done # libbuildtype
done # sist_oses

IFS="$ifsbackup"

	#not ok
	if [ -s  "$my_atual_dir/apq_mysql_error.log" ]; then
		printf "\nthere is a chance an error occurred.\nsee the above messages and correct if necessary.\n\n not ok. \n\n" >> "$my_atual_dir/apq_mysql_error.log"
		printf 'false' > "$my_atual_dir/ok.log" ;
		exit 1
	fi 
	#ok
	printf "\n ok. \n\n" >> "$my_atual_dir/apq_mysql_error.log" ;
	printf 'true' > "$my_atual_dir/ok.log" ;
	exit 0;   # end ;-)

} #end _configure

_compile(){
#: title	: compile
#: date		: 2011-jul-09
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.06
#: Description: If possible, compile will compile with gprbuild,
#: Description:   libs already configured's by configure.
#: Description: You don't need run this script manually.
#: Options	:  "OSes"

	local my_atual_dir=$(pwd)
	# Silent Reporting, because apq_error.log or don't exist or don't is a regular file or is a link
	if [ ! -f "$my_atual_dir/apq_mysql_error.log" ] || [ -L "$my_atual_dir/apq_mysql_error.log" ] || [ -L "$my_atual_dir/ok.log" ]; then
		exit 1
	fi
	# remove old content from apq_error.log
	printf "" > "$my_atual_dir/apq_mysql_error.log"

	if [ $# -ne 1 ]; then
		{	printf "\n"
			printf 'usage: compile "OSes" '
			printf "\n\n not ok. \n"
		}>"$my_atual_dir/apq_mysql_error.log"
		printf 'false' > "$my_atual_dir/ok.log"
		exit 1
	fi
	local ifsbackup="$IFS"
	local IFS="$ifsbackup"
	

	local my_path=$( echo $PATH )
	local my_oses=$(_choose_so "$1" )
	local my_libtypes=$(_choose_libtype "all" )
	local my_with_debug_too=$(_choose_debug "yes" )
	local made_dirs="$my_atual_dir/build"
	local my_count="1"

	if [ ! -d "$made_dirs" ]; then
		{	printf "\n"
			printf ' "build" dir '
			printf "don't exist or don't is a directory."
			printf "\n\n not ok. \n\n"
		}>> "$my_atual_dir/apq_mysql_error.log"
		printf 'false' > "$my_atual_dir/ok.log" ;
		exit 1
	fi
	
	local line1_my_tmp=
	local line2_debuga=
	local line3_libtype=
	local line4_os=
	local line5_compile_paths=
	local line6_gprconfig_path=
	local line7_gprbuild_path=
	local line8_my_config_path=	
	local my_tmp=
	local erro_msg_gprconfig_part=
	local erro_msg_gprbuild_part=
	local erro_msg_my_config_part=
	local madeit1=
	local madeit2=
	local madeit3=
	local madeit4=
	local madeit5=
	local madeit6=
	local madeit7=
	local madeit8=
	local madeit9=
	local madeit10=
	local aab=
	
	IFS=",$ifsbackup"

	local sist_oses=
	local libbuildtype=
	local debuga=

	for sist_oses in $my_oses
	do
		for libbuildtype in $my_libtypes
		do
			for debuga in $my_with_debug_too
			do
				my_tmp="$made_dirs"/$sist_oses/$libbuildtype/$debuga
				
				if [ -f "$my_tmp/logged/kov.log" ] && \
					[ $(sed -n -e '$=' "$my_tmp/logged/kov.log" ) -ge 6 ] && \
					[ -f "$my_tmp/apq_mysql.gpr" ];
				then
					line1_my_tmp="$my_tmp"
					line2_debuga="$debuga"
					line3_libtype="$libbuildtype"
					line4_os="$sist_oses"
				
					{	read line9_ssl_include_path
						read line5_compile_paths
						read line6_gprconfig_path
						read line7_gprbuild_path
						read line8_my_config_path
						read line10_my_system_libs_paths
					}<"$my_tmp/logged/kov.log"

					if	[ -n "$line2_debuga" ] &&  [ -n "$line3_libtype" ] &&  [ -n "$line4_os" ] && \
						[ -n "$line5_compile_paths" ] &&  [ -n "$line6_gprconfig_path" ] &&  [ -n "$line7_gprbuild_path" ] && \
						[ -n "$line8_my_config_path" ] && [ -n "$line9_ssl_include_path" ] && [ -n "$line10_my_system_libs_paths" ];
					then
						while true;
						do
							[ -d "$line6_gprconfig_path" ] && break
							line6_gprconfig_path=$(dirname "$line6_gprconfig_path" )
						done

						while true;
						do
							[ -d "$line7_gprbuild_path" ] && break
							line7_gprbuild_path=$(dirname "$line7_gprbuild_path" )
						done

						while true;
						do
							[ -d "$line8_my_config_path" ] && break
							line8_my_config_path=$(dirname "$line8_my_config_path" )
						done
						
						while true;
						do
							[ -d "$line9_ssl_include_path" ] && break
							line9_ssl_include_path=$(dirname "$line9_ssl_include_path" )
						done
	
						madeit1=" line1_$my_count=\"$my_tmp\" "
						madeit2=" line2_$my_count=\"$debuga\" "
						madeit3=" line3_$my_count=\"$libbuildtype\" "
						madeit4=" line4_$my_count=\"$sist_oses\" "
						madeit5=" line5_$my_count=\"$line5_compile_paths\" "
						madeit6=" line6_$my_count=\"$line6_gprconfig_path\" "
						madeit7=" line7_$my_count=\"$line7_gprbuild_path\" "
						madeit8=" line8_$my_count=\"$line8_my_config_path\" "
						madeit9=" line9_$my_count=\"$line9_ssl_include_path\" "
						madeit10=" line10_$my_count=\"$line10_my_system_libs_paths\" "

						eval "$madeit1"
						eval "$madeit2"
						eval "$madeit3"
						eval "$madeit4"
						eval "$madeit5"
						eval "$madeit6"
						eval "$madeit7"
						eval "$madeit8"
						eval "$madeit9"
						eval "$madeit10"

						my_count=$(( $my_count + 1 ))
					fi
				fi
			done # debuga
		done # libbuildtype
	done # sist_oses
	
	local my_count3="0"
	local my_hold_tmp1=
	local my_count2="1"

	if [ "$my_count" -gt 1 ]; then
		while [ "$my_count2" -lt "$my_count" ];
		do
			aab="line1_$my_count2"
			madeit1="${!aab}"
			aab="line2_$my_count2"
			madeit2="${!aab}"
			aab="line3_$my_count2"
			madeit3="${!aab}"
			aab="line4_$my_count2"
			madeit4="${!aab}"
			aab="line5_$my_count2"
			madeit5="${!aab}"
			aab="line6_$my_count2"
			madeit6="${!aab}"
			aab="line7_$my_count2"
			madeit7="${!aab}"
			aab="line8_$my_count2"
			madeit8="${!aab}"
			aab="line9_$my_count2"
			madeit9="${!aab}"
			aab="line10_$my_count2"
			madeit10="${!aab}"

			my_hold_tmp1="$madeit2"
			madeit2="yes"

			if [ "$madeit2" = "normal" ];
			then
				madeit2="no"
			fi

			local mysql_include_error2=$( "$madeit8"/mysql_config --include 2>&1 >/dev/null)
			local mysql_include2=$( "$madeit8"/mysql_config --include | sed  -e  '1 s/^[^/:\]*\(.[:].*\|[/\].*\)/\1/')

			if [ -n  "$mysql_include_error2" ] || [ ! -d "$mysql_include2" ]; then
				echo "$mysql_include_error2" > "$madeit1/logged/mysql_config_error.log"
				echo "$mysql_include2" >> "$madeit1/logged/mysql_config_error.log"
				erro_msg_my_config_part="$my_hold_tmp1"
				printf "mysql_config:\tnot ok\t:lib\t$madeit3\t$madeit4\t$erro_msg_my_config_part\t:Aborting matched's gprconfig & gprbuild... \n" >> "$my_atual_dir/apq_mysql_error.log"
				my_count2=$(( $my_count2 + 1 ))
				continue
			fi
			printf "mysql_config:\tOk\t:lib\t$madeit3\t$madeit4\t$my_hold_tmp1\t:Trying matched's gprconfig & gprbuild... \n" >> "$my_atual_dir/apq_mysql_error.log"
			my_include="$mysql_include2"

			# a explanation: with PATH="$my_path:$madeit5" I made preference for gcc and g++ for native compilers in system. this solve problems with multi-arch in Debian sid
			# using gnat and gprbuild from toolchain Act-San :-)
			# and with PATH="$madeit5:$my_path" ( now the default behavior) I made preference for your compiler, in your specified add_compiler_paths
			# 
			$( PATH="$madeit5:$my_path" && cd "$madeit1" && "$madeit6"/gprconfig --batch --config=ada --config=c --config=c++ -o ./kov.cgpr > ./logged/gprconfig.log 2> ./logged/gprconfig_error.log )
			if [ -s  "$madeit1/logged/gprconfig_error.log" ]; then
				erro_msg_gprconfig_part="$my_hold_tmp1"
				printf "gprconfig:\tnot ok\t:lib\t$madeit3\t$madeit4\t$erro_msg_gprconfig_part\t:Aborting matched gprbuild... \n" >> "$my_atual_dir/apq_mysql_error.log"
				my_count2=$(( $my_count2 + 1 ))
				continue
			fi
			printf "gprconfig:\tOk\t:lib\t$madeit3\t$madeit4\t$my_hold_tmp1\t:Trying matched gprbuild... \n" >> "$my_atual_dir/apq_mysql_error.log"

			$(PATH="$madeit5:$my_path" && cd "$madeit1" && "$madeit7"/gprbuild -d -f --config=./kov.cgpr -Xstatic_or_dynamic=$madeit3 -Xos=$madeit4 -Xdebug_information=$madeit2  -P./apq_mysql.gpr -cargs -I "$madeit10" -I "$my_include" -I $madeit9 >"./logged/gprbuild.log"  2>"./logged/gprbuild_error.log" )

			if [ -s  "$madeit1/logged/gprbuild_error.log" ]; then
				erro_msg_gprbuild_part="$my_hold_tmp1"
				printf " gprbuild:\tnot ok\t:lib\t$madeit3\t$madeit4\t$erro_msg_gprbuild_part\n" >> "$my_atual_dir/apq_mysql_error.log"
				my_count2=$(( $my_count2 + 1 ))
				continue
			fi
			printf " gprbuild:\tOk\t:lib\t$madeit3\t$madeit4\t$my_hold_tmp1\t:Ok\n" >> "$my_atual_dir/apq_mysql_error.log"
			
			my_count2=$(( $my_count2 + 1 ))
			my_count3=$(( $my_count3 + 1 ))

		done
		# ok
		if [ -z "$erro_msg_gprconfig_part" ] && [ -z "$erro_msg_gprbuild_part" ] && [ -z "$erro_msg_my_config_part" ]; then
			printf "\n ok. \n\n"  >> "$my_atual_dir/apq_mysql_error.log"
			printf 'true' > "$my_atual_dir/ok.log"
			exit 0
		fi
		# not ok
		if [ -n "$erro_msg_my_config_part" ]; then
			printf "\n\nmysql_config error log: verify matched mysql_config_error.log, in 'logged' subdir\n"  >> "$my_atual_dir/apq_mysql_error.log"
		fi
		if [ -n "$erro_msg_gprconfig_part" ]; then
			printf "\n\ngprconfig error log: verify matched's gprconfig_error.log and gprconfig.log, in 'logged' subdir\n"  >> "$my_atual_dir/apq_mysql_error.log"
		fi
		if [ -n "$erro_msg_gprbuild_part" ]; then
			printf "\n\ngprbuild error log: verify matched's gprbuild_error.log and gprbuild.log, in 'logged' subdir\n"  >> "$my_atual_dir/apq_mysql_error.log"
		fi
		if [ "$my_count3" -ge 1 ]; then
			printf "\n not ok. but one or more things worked\n\n"  >> "$my_atual_dir/apq_mysql_error.log"
		else 
			printf "\n not ok.\n\n"  >> "$my_atual_dir/apq_mysql_error.log"
		fi
		printf 'false' > "$my_atual_dir/ok.log"
		exit 1
		
	fi
		{	printf " Nothing to compile. \n"
			printf " Maybe 'oses' not yet (or erroneously) configured ? "
			printf "\n\n Not ok. \n\n"
		}>>"$my_atual_dir/apq_mysql_error.log"
		printf 'false' > "$my_atual_dir/ok.log"
		exit 1

} #end _compile


_installe(){
#: title	: installe
#: date		: 2011-jul-09
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.05
#: Description: If possible, install libs and includes from os(es) in prefix,
#: Description: You don't need run this script manually.
#: Options	:  "OSes" "prefix"

	local my_atual_dir=$(pwd)
	# Silent Reporting, because apq_error.log or don't exist or don't is a regular file or is a link
	if [ ! -f "$my_atual_dir/apq_mysql_error.log" ] || [ -L "$my_atual_dir/apq_mysql_error.log" ] || [ -L "$my_atual_dir/ok.log" ]; then
		exit 1
	fi
	# remove old content from apq_error.log
	printf "" > "$my_atual_dir/apq_mysql_error.log"

	if [ $# -ne 2 ]; then
		{	printf "\n"
			printf 'usage: installe "OSes" "prefix" '
			printf "\n\n not ok. \n"
		}>"$my_atual_dir/apq_mysql_error.log"
		printf 'false' > "$my_atual_dir/ok.log"
		exit 1
	fi
	local ifsbackup="$IFS"
	local IFS="$ifsbackup"

	local my_path=$( echo $PATH )
	local my_oses=$(_choose_so "$1" )
	local my_libtypes=$(_choose_libtype "all" )
	local my_with_debug_too=$(_choose_debug "yes" )
	local made_dirs="$my_atual_dir/build"

	local my_prefix=$2

	if [ ! -d "$made_dirs" ]; then
		{	printf "\n"
			printf ' "build" dir '
			printf "don't exist or don't is a directory."
			printf "\n\n not ok. \n\n"
		}>> "$my_atual_dir/apq_mysql_error.log"
		printf 'false' > "$my_atual_dir/ok.log"
		exit 1
	fi
	
	IFS=",$ifsbackup"

	local sist_oses=
	local libbuildtype=
	local debuga=
	local my_tmp=
	local my_tmp2=
	local my_tmp3=
	local my_tmp4=
	local my_tmp5=
	local my_tmp6=

	local my_count=1
	local my_made_install=
	local madeit1=
	local madeit2=

	for sist_oses in $my_oses
	do
		my_tmp2="$made_dirs"/$sist_oses

		[ ! -d "$my_tmp2" ] && continue
		
		for libbuildtype in $my_libtypes
		do
			my_tmp3="$made_dirs"/$sist_oses/$libbuildtype
			
			[ ! -d "$my_tmp3" ] && continue
			[ "$libbuildtype" = "relocatable" -o "$libbuildtype" = "dynamic"  ] && my_tmp6="shared" || my_tmp6="static"

			for debuga in $my_with_debug_too
			do
				my_tmp4="$made_dirs"/$sist_oses/$libbuildtype/$debuga
				
				[ ! -d "$my_tmp4" ] && continue
				[ "$debuga" = "normal" ] && my_tmp5="" || my_tmp5="$debuga"

				install -d "$my_prefix/lib/apq-mysql/$sist_oses/$my_tmp6/$my_tmp5/ali"  2>"$my_tmp4/logged/install_error.log"
				if [ -s  "$my_tmp4/logged/install_error.log" ]; then
					my_made_install="$debuga"
					printf "install:\tnot ok\t:$libbuildtype\t$sist_oses\t$my_made_install\t: ... \n" >> "$my_atual_dir/apq_mysql_error.log"
				else
					printf "install:\tOk\t:$libbuildtype\t$sist_oses\t$debuga\t:Created directory! \n" >> "$my_atual_dir/apq_mysql_error.log"
				fi

				install -m0555 "$my_tmp4"/ali/* -t "$my_prefix/lib/apq/$sist_oses/$my_tmp6/$my_tmp5/ali"  2>"$my_tmp4/logged/install_error.log"
				if [ -s  "$my_tmp4/logged/install_error.log" ]; then
					my_made_install="$debuga"
					printf "install ali:\tnot ok\t:$libbuildtype\t$sist_oses\t$my_made_install\t: ... \n" >> "$my_atual_dir/apq_mysql_error.log"
				else
					printf "install ali:\tOk\t:$libbuildtype\t$sist_oses\t$debuga\t:Installed .ali files! \n" >> "$my_atual_dir/apq_mysql_error.log"
				fi

				# using "cp -a" to getrid from transforming symlinks in normal links
				cp -a "$my_tmp4"/lib/* "$my_prefix/lib/apq-mysql/$sist_oses/$my_tmp6/$my_tmp5/"  2>"$my_tmp4/logged/install_error.log"
				if [ -s  "$my_tmp4/logged/install_error.log" ]; then
					my_made_install="$debuga"
					printf "install lib:\tnot ok\t:$libbuildtype\t$sist_oses\t$my_made_install\t: ... \n" >> "$my_atual_dir/apq_mysql_error.log"
				else
					printf "install lib:\tOk\t:$libbuildtype\t$sist_oses\t$debuga\t:Installed lib files! \n" >> "$my_atual_dir/apq_mysql_error.log"
				fi
				
				my_count=$(( $my_count + 1 ))

			done # debuga
		done # libbuildtype
	done # sist_oses

	# nothing was installed
	if [ $my_count -lt 2 ]; then
		{	printf "nothing was installed. \n"
			printf "maybe a wrong 'oses' ? or a not already compiled libs for install ? "
			printf "not ok.\n\n"
		}>>"$my_atual_dir/apq_mysql_error.log"
		printf 'false' > "$my_atual_dir/ok.log"
		exit 1
	fi

	install -d "$my_prefix/include/apq-mysql"  2>"$made_dirs/install_src_error.log"
	if [ -s  "$made_dirs/install_src_error.log" ]; then
		my_made_install="hi"
		printf "install includes:\tnot ok\t: ... \n" >> "$my_atual_dir/apq_mysql_error.log"
	else
		printf "install includes:\tOk\t:Created directory! \n" >> "$my_atual_dir/apq_mysql_error.log"
	fi

	IFS=",$ifsbackup"

	sist_oses=
	libbuildtype=
	debuga=
	my_tmp=
	my_tmp2=
	my_tmp3=
	my_tmp4=
	my_tmp5=
	my_tmp6=
	my_count="1"
	local my_count4=1
	
	for sist_oses in $my_oses
	do
		[ ! -d "$made_dirs/$sist_oses" ] && continue

		for libbuildtype in $my_libtypes
		do
			[ ! -d "$made_dirs/$sist_oses/$libbuildtype" ] && continue
			[ "$libbuildtype" = "relocatable" -o "$libbuildtype" = "dynamic"  ] && my_tmp="shared" || my_tmp="static"

			for debuga in $my_with_debug_too
			do
				my_tmp2="$made_dirs/$sist_oses/$libbuildtype/$debuga/src"
				[ ! -d "$my_tmp2" ] && continue
				[ ! -f "$my_tmp2/apq-mysql.ads" ] && continue
				[ ! -s "$my_tmp2/apq-mysql.ads" ] && continue

				[ "$debuga" = "normal" ] && my_tmp3="" || my_tmp3="$debuga"

				my_tmp4="$my_tmp2/apq-mysql.ads"
				madeit1=" from_$my_count=\"$my_tmp4\"  "

				my_tmp5="$my_prefix/include/apq-mysql/generated_source/$sist_oses/$my_tmp/$my_tmp3/src"
				madeit2=" to_$my_count=\"$my_tmp5\" "
				
				eval "$madeit1"
				eval "$madeit2"

				my_count=$(( $my_count + 1 ))

			done # debuga
		done # libbuildtype
	done # sist_oses
	# mysource:=( "" & prefix & "/include/apq-mysql" , "" & prefix & "/include/apq-mysql/generated_source/" & OS & "/" & NameDir_Static_Or_Shared & "/" & debug & "/src" ) ;

	my_tmp=
	my_tmp2=
	my_tmp3=
	my_tmp4=
	madeit=
	local  from0=
	local to0=

	install "$my_atual_dir"/src/* -t "$my_prefix/include/apq-mysql"  2>"$made_dirs/install_src_error.log"
	if [ "$my_count" -ge 2 ]; then
		while [ "$my_count4" -lt "$my_count" ];
		do
			madeit="from_$my_count4"
			from0="${!madeit}"
			madeit="to_$my_count4"
			to0="${!madeit}"

			install "$from0" -t "$to0"  2>>"$made_dirs/install_src_error.log"

			my_count4=$(( $my_count4 + 1 ))
		done
	fi
	if [ -s  "$made_dirs/install_src_error.log" ]; then
		my_made_install="hi"
		printf "install includes :\tnot ok\t: ... \n" >> "$my_atual_dir/apq_mysql_error.log"
	else
		printf "install includes :\tOk\t:Installed includes! \n" >> "$my_atual_dir/apq_mysql_error.log"
	fi
	

	install -d "$my_prefix/lib/gnat"  2>"$made_dirs/install_gpr_error.log"
	if [ -s  "$made_dirs/install_gpr_error.log" ]; then
		my_made_install="hi"
		printf "install gpr(s):\tnot ok\t: ... \n" >> "$my_atual_dir/apq_mysql_error.log"
	else
		printf "install gpr(s):\tOk\t:Created directory! \n" >> "$my_atual_dir/apq_mysql_error.log"
	fi
	gnatprep "-Dprefix=\"$my_prefix\"" "$my_atual_dir/gpr/apq-mysql.gpr.in" "$my_prefix/lib/gnat/apq-mysql.gpr"  2>"$made_dirs/install_gpr_error.log"
	if [ -s  "$made_dirs/install_gpr_error.log" ]; then
		my_made_install="hi"
		printf "install gpr(s):\tnot ok\t: ... \n" >> "$my_atual_dir/apq_mysql_error.log"
	else
		printf "install gpr(s):\tOk\t:Installed GPR(s)! \n" >> "$my_atual_dir/apq_mysql_error.log"
	fi
	#ok
	if [ -z "$my_made_install" ]; then
		{	printf "\n\n Install libs now success finished. \n"
			printf " Read the inline text in file $my_prefix/lib/gnat/apq-mysql.gpr \n"
			printf " for hints and example usage :-)\n"
			printf "\n ok. \n\n"
		}>>"$my_atual_dir/apq_mysql_error.log"
		printf 'true' > "$my_atual_dir/ok.log"
		exit 0
	fi
	#mostly ok
	{	printf "\n\n there were some errors during this install process \n"
		printf " read the install_*error.logs \n"
		printf " for hints to fixes these errors :-)\n"
		printf "\n not ok. \n\n"
	}>>"$my_atual_dir/apq_mysql_error.log"
	printf 'false' > "$my_atual_dir/ok.log"
	exit 1
	
} #end _installe

_clean(){
#: title	: clean
#: date		: 2011-jul-09
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.04
#: Description: If possible, clean temporary files.
#: Description: You don't need run this script manually.
#: Options	:  none

	local my_atual_dir=$(pwd)
	# Silent Reporting, because apq_error.log or don't exist or don't is a regular file or is a link
	if [ ! -f "$my_atual_dir"/apq_mysql_error.log ] || [ -L "$my_atual_dir"/apq_mysql_error.log ] || [ -L "$my_atual_dir"/ok.log ]; then
		exit 1
	fi
	# remove old content from apq_error.log
	printf "" > "$my_atual_dir/apq_mysql_error.log"

	local ifsbackup="$IFS"
	local IFS="$ifsbackup"

	local made_dirs="$my_atual_dir/build"
	local my_count=1
	if [ ! -d "$made_dirs" ]; then
		{	printf "\n"
			printf ' "build" dir '
			printf "don't exist or don't is a directory."
			printf "\n\n not ok. \n\n"
		}>> "$my_atual_dir/apq_mysql_error.log"
		printf 'false' > "$my_atual_dir/ok.log"
		exit 1
	fi
	local my_path=$( echo $PATH )
	local my_oses=$(_choose_so "all" )
	local my_libtypes=$(_choose_libtype "all" )
	local my_with_debug_too=$(_choose_debug "yes" )
	local sist_oses=
	local libbuildtype=
	local debuga=
	local my_tmp=
	local my_tmp2=
	local my_tmp3=
	local my_tmp4=
	local my_tmp5=
	local my_tmp6=
	
	IFS=",$ifsbackup"


	for sist_oses in $my_oses
	do
		my_tmp2="$made_dirs"/$sist_oses

		[ ! -d "$my_tmp2" ] && continue
		
		for libbuildtype in $my_libtypes
		do
			my_tmp3="$made_dirs"/$sist_oses/$libbuildtype
			
			[ ! -d "$my_tmp3" ] && continue
		
			for debuga in $my_with_debug_too
			do
				my_tmp4="$made_dirs"/$sist_oses/$libbuildtype/$debuga
				
				[ ! -d "$my_tmp4" ] && continue
			
				rm	$my_tmp4/ali/*	2>/dev/null
				rm $my_tmp4/lib/*	2>/dev/null
				rm $my_tmp4/lib_c/*	2>/dev/null
				rm $my_tmp4/obj_c/*	2>/dev/null
				rm $my_tmp4/obj/*	2>/dev/null
				# dont clean $my_tmp4/src/* because it need rerun configure target :-)
				# rm $my_tmp4/src/*	2>/dev/null
				
			done # debuga
		done # libbuildtype
	done # sist_oses

	printf "\n\n ok. \n\n" >> "$my_atual_dir/apq_mysql_error.log"
	printf 'true' > "$my_atual_dir/ok.log"
	exit 0

} #end _clean

_distclean(){
#: title	: distclean
#: date		: 2011-jul-09
#: Authors	: "Daniel Norte de Moraes" <danielcheagle@gmail.com>
#: Authors	: "Marcelo Coraça de Freitas" <marcelo.batera@gmail.com>
#: version	: 1.05
#: Description: Deleta all temporary and cached organization and configuration files;
#: Description:   for that, just delete temporary dir "build"
#: Description: You don't need run this script manually.
#: Options	:  none

	local my_atual_dir=$(pwd)
	# Silent Reporting, because apq_error.log or don't exist or don't is a regular file or is a link
	if [ ! -f "$my_atual_dir"/apq_mysql_error.log ] || [ -L "$my_atual_dir"/apq_mysql_error.log ] || [ -L "$my_atual_dir"/ok.log ]; then
		exit 1
	fi
	# remove old content from apq_error.log
	printf "" > "$my_atual_dir/apq_mysql_error.log"
	
	local made_dirs="$my_atual_dir/build"
	if [ ! -d "$made_dirs" ]; then
		{	printf "\n"
			printf ' "build" dir '
			printf "don't exist or don't is a directory."
			printf "\n\n not ok. \n\n"
		}>> "$my_atual_dir/apq_mysql_error.log"
		printf 'false' > "$my_atual_dir/ok.log"
		exit 1
	fi
	[ -d "$made_dirs" ] && [ ! -L "$made_dirs" ] && rm $made_dirs -rf && printf "\n\n ok \n\n" >> "$my_atual_dir/apq_mysql_error.log"; printf 'true' > "$my_atual_dir/ok.log"; exit 0 || printf "\n\n not ok \n\n">> "$my_atual_dir/apq_mysql_error.log"; printf 'false' > "$my_atual_dir/ok.log" ; exit 1

} #end _distclean


####################################
######   operative part   ##########
####################################

case $my_commande in
	'configuring' )  [ $# -eq 9 ] && _configure "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || printf "configure need nine\(9\) options\n" ; exit 1
		;;
	'compilling' )  [ $# -eq 1 ] && _compile "$1" || printf "compile need one\(1\) option\n" ; exit 1
		;;
	'installing' )  [ $# -eq 2 ] && _installe "$1" "$2" || printf "install need two\(2\) options\n" ; exit 1
		;; 
	'cleaning' )   [ true ] && _clean
		;;
	'dist_cleaning' ) [ true ] && _distclean
		;;
	*  ) printf "I dont known this command :-\)\n" ;
		printf "_${my_commande}_\n"
		exit 1
		;;
esac
