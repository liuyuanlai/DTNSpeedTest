EXECS=mpi_fread_test
MPICC?=mpicc

all: ${EXECS}

mpi_fread_test: mpi_fread_test.c
	${MPICC} -o mpi_fread_test mpi_fread_test.c

clean:
	rm -f ${EXECS}
