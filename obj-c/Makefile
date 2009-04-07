# Makefile for the linking of the c helper library.

#			Transfered Variables
#The variables CC and C_LIBRARY_BASIC_OPTIONS are imported from the calling
#makefile. They respectively define the compiler and the basic options used
#with it. The variable C_LIBRARY_PATH is also imported. It contains the name
#of the directory where the library should be stored.

#			Environment Variables
#The variable MYSQL_PATH should have the path to the mysql base directory. It
#is only needed on Windows.

#			Variables

#OUTPUT_PATH is the path were the library should be stored.
OUTPUT_PATH=../${C_LIBRARY_PATH}


#MYSQL_LIBRARY is the name of the static mysql library that needs to be
#recompiled into a dynamic one. INCLUDE_MYSQL_LIBRARY is the option passed to
#the compiler to include the generated dll. This is just needed on windows.
ifeq (${OS}, Windows_NT)
	MYSQL_LIBRARY_NAME=mysql
	MYSQL_LIBRARY=lib${MYSQL_LIBRARY_NAME}.lib
	MYSQL_LIBRARY_ADDRESS="${MYSQL_PATH}\lib\opt\${MYSQL_LIBRARY}"
	MYSQL_LIBRARY_DEFINITIONS=${MYSQL_LIBRARY_NAME}.def
else
	MYSQL_LIBRARY=
	MYSQL_LIBRARY_ADDRESS=
	MYSQL_LIBRARY_DEFINITIONS=
endif


#C_LIBRARY_TYPE defines what kind of library is created.
C_LIBRARY_TYPE=-shared

#OUTPUT_NAME is the name of the compiled library.
ifeq ($(OS), Windows_NT)
	OUTPUT_NAME=apq-mysqlhelp.dll
else
	OUTPUT_NAME=libapq-mysqlhelp.so
endif

#CC_OPTIONS contains most options passed to the CC. .
CC_OPTIONS=${C_LIBRARY_BASIC_OPTIONS} ${C_LIBRARY_TYPE} \
	${INCLUDE_MYSQL_LIBRARY} -o ${OUTPUT_PATH}/${OUTPUT_NAME}


#CREATE_DLL is a special target, that is ignored on all systems but windows.
ifeq ($(OS), Windows_NT)
	CREATE_DLL=create_dll
	MYSQL_DLL=${MYSQL_LIBRARY_NAME}_client
	MYSQL_DLL_NAME=lib${MYSQL_DLL}.dll
	INCLUDE_MYSQL_LIBRARY=-L${OUTPUT_PATH} -l${MYSQL_DLL}
else
	CREATE_DLL=
	MYSQL_DLL=
	MYSQL_DLL_NAME=
	INCLUDE_MYSQL_LIBRARY=
endif


#The main rule is to create the dynamic library.
all: ${OUTPUT_NAME}


#The the dynamic helper library is linked from the object files. If we are
#compiling for a windows system, we need to generated a dynamic mysql library.
${OUTPUT_NAME}: ${CREATE_DLL}
	${CC} ${CC_OPTIONS} c_mysql.o


create_dll: ${MYSQL_LIBRARY_DEFINITIONS} ${MYSQL_DLL}


${MYSQL_LIBRARY_DEFINITIONS}:
	-rm ${MYSQL_LIBRARY_DEFINITIONS}
	echo EXPORTS > ${MYSQL_LIBRARY_DEFINITIONS}
	nm ${MYSQL_LIBRARY_ADDRESS} | grep ' T _' | sed 's/.* T _//' >> \
	${MYSQL_LIBRARY_DEFINITIONS}

${MYSQL_DLL}:
	${CC} -shared ${MYSQL_LIBRARY_DEFINITIONS} ${MYSQL_LIBRARY_ADDRESS} \
	-o ${OUTPUT_PATH}/${MYSQL_DLL_NAME}




clean:
	-rm -f *~
	-rm -f ~*
	-rm -f \#*
	-rm -f ${OUTPUT_PATH}/*.dll
	-rm -f *.def




.PHONY: all clean create_dll
