# Makefile for APQ-MySQL

#			Environment Variables
#The variable MYSQL_PATH should have the path to the mysql base directory. It
#is only needed on Windows.

#				Variables

#Compiler to be used for C compilation. Exported to sub makes.
export CC=gcc

#Options used to define how strict gcc should be with warnings.
export WARNING_OPTIONS=-Wall -Wextra

#Compiler options used both when compiling and when linking. Also exported.
export C_LIBRARY_BASIC_OPTIONS=-fPIC ${WARNING_OPTIONS}


#Directory containing the C helper library source.
export C_SOURCE_PATH=src-c

#Directory to contain the C helper library object files.
export C_OBJECT_PATH=obj-c

#Directory to contain the helper library generated from the c source.
export C_LIBRARY_PATH=lib


#Extras contain support scripts and programs used to generate apq-mysql.ads.
#Work is a subdirectory of it where we store auxiliary programs.
EXTRAS_DIR=extras
export WORK=work
EXTRAS_WORK_DIR=${EXTRAS_DIR}/${WORK}

export ADA_SOURCE=src

#PROJECT_FILES should contain the name of the gpr files that need to be compiled.
PROJECT_FILES=apq-mysql_c.gpr apq-mysql.gpr

# GPR_FILES should contain the name of the gpr files that need to be installed.
GPR_FILES=apq-mysql.gpr apq-mysql_c.gpr


INCLUDE_FILES=src*/*


include Makefile.include


pre_libs: c_libs setup

pos_libs:
	@echo The library has been compiled!


c_libs: c_objs ${DLL_MAKE}
	make -C ${C_OBJECT_PATH}

c_objs:
	make -C ${C_SOURCE_PATH} VERSION=$(VERSION)

setup: 
	make -C ${EXTRAS_DIR} 
	mv ${EXTRAS_WORK_DIR}/apq-mysql.ads src/


extra_clean:
	@make -C ${C_SOURCE_PATH} clean
	@make -C ${C_OBJECT_PATH} clean
	@make -C ${EXTRAS_DIR} clean
	-rm *~
	-rm ~*
	-rm \#*
	@echo "All clean"
