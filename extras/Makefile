# Makefile for APQ-MySQL
#

#Workd dir, where we store temprary programs.
WORK=work

#Path to the Ada source dir.
ADA_SRC=../src

#Selected compiler.
CC=gcc

#Necessary gcc options.
COPTS=-Wall -O0 -I${WORK}

#SO Dependant configurations.
ifeq ($(TARGET), WIN32)
	#Path to the MySQL directory.
	MY_INCL:=-I "$(MYSQL_PATH)\include" -D__LCC__
	#The correct scripts to use with the SO.
	XCR:=mysql_xcr_win32
	XTY:=mysql_xty_win32
else
	#Path to the MySQL directory.
	MY_INCL=`mysql_config --cflags`
	#The correct scripts to use with the SO.
	XCR:=mysql_xcr
	XTY:=mysql_xty
endif



all: apq-mysql.ads
	@echo "Created MySQL build Environment!"


chmod: 
	chmod u+x mysql_xcr mysql_xcr2 mysql_xcr3 mysql_incl mysql_xty mysql_linker_options mysql_xcr_win32 mysql_xty_win32

err_msg:
	./${XCR} > ${WORK}/mysql_errmsg.h

type_codes:
	./${XTY} > ${WORK}/mysql_type_codes.h



mysql_opts:
	$(CC) $(COPTS) $(MY_INCL) mysqlopts.c -o ${WORK}/mysql_opts
mysql_generr: err_msg
	$(CC) $(COPTS) $(MY_INCL) mysql_generr.c -o ${WORK}/mysql_generr

mysql_gentyp: type_codes
	$(CC) $(COPTS) $(MY_INCL) mysql_gentyp.c -o ${WORK}/mysql_gentyp




opts: mysql_opts
	cd ${WORK} && ./mysql_opts >opts.tmp

err: mysql_generr
	cd ${WORK} && ./mysql_generr | sort -k1,1n | ../mysql_xcr2 > gen.tmp

typ: mysql_gentyp
	cd ${WORK} && ./mysql_gentyp | sort -k1,1n | ../mysql_xcr3


apq-mysql.ads-in:
	cp ${ADA_SRC}/apq-mysql.ads-in ${WORK}

apq-mysql.ads: apq-mysql.ads-in chmod opts err typ

clean:
	@rm -f ${WORK}/*
docs:


