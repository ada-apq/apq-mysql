all: c_mysql.o


clean:
	rm ../obj-c/*

.c.o:
	cd ../obj-c && gcc -fPIC `mysql_config --include` -I../src-c -c ../src-c/$< -o $*.o

