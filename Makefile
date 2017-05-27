.PHONY: default install clean

CFLAGS = -g -Wall -ansi -pedantic -fPIC -Ips -I.

SPORTH_LIBS = -lsporth -lsoundpipe -lsndfile -lm

LDFLAGS = -ldl -L/usr/local/lib

OBJ = runt.o basic.o irunt.o

default: irunt librunt.a 

ifdef ALIGNED_MALLOC
CFLAGS += -DALIGNED_MALLOC
endif

playground: playground.c $(OBJ) plugin.so
	$(CC) $(LDFLAGS) $(CFLAGS) playground.c $(OBJ) -o $@

irunt: main.c $(OBJ)
	$(CC) $(LDFLAGS) $(CFLAGS) main.c $(OBJ) -o $@

librunt.a: $(OBJ)
	ar rcs $@ $(OBJ)

plugin.so: plugin.c 
	$(CC) plugin.c -shared -fPIC -o $@ librunt.a

%.o: %.c
	$(CC) $(CFLAGS) -c $^ -o $@ 

install: default
	mkdir -p $(HOME)/.runt/lib
	mkdir -p $(HOME)/.runt/bin
	mkdir -p $(HOME)/.runt/include
	install irunt $(HOME)/.runt/bin
	install librunt.a $(HOME)/.runt/lib
	install runt.h $(HOME)/.runt/include

clean:
	rm -rf playground runt.o plugin.so irunt librunt.a 
	rm -rf $(OBJ)
