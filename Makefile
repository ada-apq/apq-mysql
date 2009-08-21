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

#PROJECT_FILE should contain the name of the gpr file.
projectFile="apq-mysql.gpr"


VERSION=3.0


ifndef ($(PREFIX))
	PREFIX=/usr/local
endif
INCLUDE_PREFIX=$(PREFIX)/include/apq-mysql
LIB_PREFIX=$(PREFIX)/lib
GPR_PREFIX=$(LIB_PREFIX)/gnat




all: libs

libs: c_libs ada_libs
	gnatmake -P ${projectFile}




c_libs: c_objs ${DLL_MAKE}
	make -C ${C_OBJECT_PATH}

c_objs:
	make -C ${C_SOURCE_PATH} VERSION=$(VERSION)




ada_libs: setup
	gnatmake -P ${projectFile}

setup: 
	make -C ${EXTRAS_DIR} 
	mv ${EXTRAS_WORK_DIR}/apq-mysql.ads src/




clean:
	gnatclean -P ${projectFile}
	@make -C ${C_SOURCE_PATH} clean
	@make -C ${C_OBJECT_PATH} clean
	@make -C ${EXTRAS_DIR} clean
	-rm *~
	-rm ~*
	-rm \#*
	@echo "All clean"

gprfile:
	@echo "Preparing GPR file.."
	@echo version:=\"$(VERSION)\" > gpr/apq.def
	@echo prefix:=\"$(PREFIX)\" >> gpr/apq.def
	@gnatprep gpr/apq-mysql.gpr.in gpr/apq-mysql.gpr gpr/apq.def
	@gnatprep gpr/apq-mysql_c.gpr.in gpr/apq-mysql_c.gpr gpr/apq.def

gprclean:
	@rm -f gpr/*.gpr 
	@rm -f gpr/*.def

install: gprfile
	@echo "Installing files"
	install -d $(INCLUDE_PREFIX)
	install -d $(LIB_PREFIX)
	install -d $(GPR_PREFIX)
	install src*/* -t $(INCLUDE_PREFIX)
	install lib/* -t $(LIB_PREFIX)
	install gpr/*.gpr -t $(GPR_PREFIX)
	make gprclean

