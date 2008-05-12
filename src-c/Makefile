# Makefile for the compilation (not linking) of the c helper library.

#			Transfered Variables
#The variables CC and C_LIBRARY_BASIC_OPTIONS are imported from the calling
#makefile. They respectively define the compiler and the basic options used
#with it. The variable C_OBJECT_PATH is also imported. It contains the name
#of the directory where object files are to be stored.

#			Environment Variables
#The variable TARGET is expected to be an existing environment variable. It
#should be set to WIN32 for windows systems and UNIX for unix ones.
#NOTE: We may yet change the accepted values and their meanings.
#The variable MYSQL_PATH should have the path to the mysql base directory. It
#is only needed on Windows.

#			Variables

#MYSQL_INCLUDE_PATH contains a -I to the correct MY_SQL include directory.
ifeq ($(TARGET), WIN32)
	MYSQL_INCLUDE_PATH=-I "$(MYSQL_PATH)\include" -I./
else
	MYSQL_INCLUDE_PATH=`mysql_config --cflags` -I./
endif

#SYSTEM_DEFINES contain any definitions necessary for some systems.
ifeq ($(TARGET), WIN32)
	SYSTEM_DEFINES=-D_WINDOWS -D__LCC__
else
	SYSTEM_DEFINES=
endif


#OUTPUT_PATH is the path were the .o files are to be put.
OUTPUT_PATH=../${C_OBJECT_PATH}
#Change to object path

#CC_OPTIONS is the summing of all options to be passed to the compiler.
CC_OPTIONS=${C_LIBRARY_BASIC_OPTIONS} ${MYSQL_INCLUDE_PATH} ${SYSTEM_DEFINES}
#Change cflags



#The main rule is to compile c_mysql.o
all: c_mysql.o

#This rule is a generic compilation rule to generate .o from .c.
.c.o:
	${CC} -c ${CC_OPTIONS} $< -o ${OUTPUT_PATH}/$*.o




#Clean rule must remove any backups and the .o file.
clean:
	-rm -f ~*
	-rm -f *~
	-rm -f \#*
	-rm -f ${OUTPUT_PATH}/*.o




#All and clean are phony targets.
.PHONY: all clean
