# Makefile for APQ-MySQL
#


WORK=work
ADA_SRC=../src

CC=gcc
COPTS=-Wall -O0 -I${WORK}


MY_INCL=`mysql_config --cflags`




all: apq-mysql.ads
	@echo "Created MySQL build Environment!"


chmod: 
	chmod u+x mysql_xcr mysql_xcr2 mysql_xcr3 mysql_incl mysql_xty mysql_linker_options

err_msg:
	./mysql_xcr > ${WORK}/mysql_errmsg.h

type_codes:
	./mysql_xty > ${WORK}/mysql_type_codes.h



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


