# Makefile for APQ-MySQL
#

projectFile="apq-mysql.gpr"

EXTRAS_DIR=extras
EXTRAS_WORK_DIR=extras/work

#SO Dependant configurations.
ifeq ($(TARGET), WIN32)
	#Name of the output dynamic library.
	OUTPUT_LIB=libapq-mysqlhelp.dll
	#Options to compile the dynamic library.
	DYNA_OPTS=-fPIC -shared ../obj-c/c_mysql.o "$(MYSQL_PATH)\lib\opt\libmysql.lib"
else
	#Name of the output dynamic library.
	OUTPUT_LIB=libapq-mysqlhelp.so
	#Options to compile the dynamic library.
	DYNA_OPTS=-shared ../obj-c/c_mysql.o
endif
libs: setup c_libs
	gnatmake -P ${projectFile} -f"*.c" -v 

all: libs

setup: 
	make -C ${EXTRAS_DIR} 
	mv ${EXTRAS_WORK_DIR}/apq-mysql.ads src/
#	gnatmake -c $(AOPTS) comp_mysql

clean:
	cd ${EXTRAS_DIR} && make clean
	gnatclean -P ${projectFile}
	@rm -f lib/*
	@rm -f src/apq-mysql.ads
	@make -C src-c clean
	@make -C ${EXTRAS_DIR} clean
	@echo "All clean"

docs:
	@-./gendoc.sh
	@echo "The documentation is generated by a bash script. Then it might fail in other platforms"



c_libs: c_objs
	cd lib && gcc $(DYNA_OPTS) -o $(OUTPUT_LIB)

c_objs:
	make -C src-c
