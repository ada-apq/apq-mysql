# Makefile for APQ-MySQL
#


OPTZ=-O0

CC=gcc

ZOPTS=$(DBG) $(OPTZ)
COPTS=-Wall $(ZOPTS)
SCRIPTS_DIR=scripts
MY_INCL=`mysql_config --cflags`


all: setup mysql

setup: mysql_xcr mysql_xcr2 mysql_xcr3 mysql_incl
	chmod u+x mysql_xcr mysql_xcr2 mysql_xcr3 mysql_incl mysql_xty mysql_linker_options

mysql: apq-mysql.ads c_mysql.o
#	gnatmake -c $(AOPTS) comp_mysql

c_mysql.o: c_mysql.c
	$(CC) -c $(COPTS) $(ZOPTS) $(MY_INCL) c_mysql.c -o c_mysql.o

apq-mysql.ads: apq-mysql.ads-in mysql_generr.c mysql_xcr2 mysql_xcr3
	rm -f mysql_errmsg.h mysql_generr
	./mysql_xcr >mysql_errmsg.h
	./mysql_xty >mysql_type_codes.h
	$(CC) $(COPTS) $(MY_INCL) mysql_generr.c -o mysql_generr
	$(CC) $(COPTS) $(MY_INCL) mysql_gentyp.c -o mysql_gentyp
	$(CC) $(COPTS) $(MY_INCL) mysqlopts.c -o mysql_opts
	./mysql_opts >opts.tmp
	./mysql_generr | sort -k1,1n | ./mysql_xcr2 >gen.tmp
	./mysql_gentyp | sort -k1,1n | ./mysql_xcr3
	rm -f mysql_generr mysql_errmsg.h mysql_gentyp mysql_type_codes.h gen.tmp opts.tmp mysql_opts gen.tmp

clean:

docs:


