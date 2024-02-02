all: main


SOURCES = $(wildcard *.c)
INCLUDES = $(wildcard *.h)

main : $(SOURCES) $(INCLUDES)
        gcc -o "$@" $(SOURCES) -g -Wno-everything -pthread -lm 

clean:
        rm -f main

