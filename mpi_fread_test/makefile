EXECS=mira_sao_mpi_fread_test
MPICC?=mpicc

all: ${EXECS}

${EXECS}: mpi_fread_test.c
	${MPICC} -o ${EXECS} mpi_fread_test.c

clean:
	rm -f ${EXECS}
