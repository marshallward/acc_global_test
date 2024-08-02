FC=gfortran
FCFLAGS=-fopenacc
LDFLAGS=-fopenacc

all: global

global: main.o loop.o grid.o
	$(FC) $(LDFLAGS) -o $@ $^

main.o: grid.o loop.o
loop.o: grid.o

%.o: %.f90
	$(FC) $(FCFLAGS) -c $<

clean:
	rm -f global *.o *.mod
