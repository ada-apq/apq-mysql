# Makefile for APQ-MySQL
#


ADA_PROJECT_PATH=.:../apq:../awlib

projectFile="apq-mysql.gpr"

SCRIPTS_DIR=scripts


libs: setup c_libs
	ADA_PROJECT_PATH=${ADA_PROJECT_PATH} gnatmake -P ${projectFile}

all: libs

setup: 
	cd ${SCRIPTS_DIR} && make
	cp ${SCRIPTS_DIR}/apq-mysql.ads src/
#	gnatmake -c $(AOPTS) comp_mysql

clean:
	cd ${SCRIPTS_DIR} && make clean
	@ADA_PROJECT_PATH=${ADA_PROJECT_PATH} gnatclean -P ${projectFile}
	@echo "All clean"

docs:
	@-./gendoc.sh
	@echo "The documentation is generated by a bash script. Then it might fail in other platforms"



c_libs: c_objs
	cd lib && gcc -shared ../obj-c/c_mysql.o -o libapq-mysqlhelp.so

c_objs:
	make -C src-c

