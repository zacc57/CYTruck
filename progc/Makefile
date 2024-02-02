all: main


SRCS = $(wildcard *.c)
HEADERS = $(wildcard *.h)

main : $(SRCS) $(HEADERS)
        gcc -o "$@" $(SRCS) -g -Wno-everything -pthread -lm 

clean:
        rm -f main

