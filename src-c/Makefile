ifeq ($(TARGET), WIN32)
	MY_INCL:=-I "$(MYSQL_PATH)\include" -D_WINDOWS -D__LCC__
else
	MY_INCL=`mysql_config --cflags`
endif

all: c_mysql.o


clean:
	rm ../obj-c/*

.c.o:
	cd ../obj-c && gcc -fPIC $(MY_INCL) -I../src-c -c ../src-c/$< -o $*.o
