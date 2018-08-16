<<<<<<< HEAD
EXECS=gpfs_sao_mpi_fread_test
=======
EXECS=mira_sao_mpi_fread_test
>>>>>>> d112d256502757b87f1f0ee49dd75647a996e2ca
MPICC?=mpicc

all: ${EXECS}

${EXECS}: mpi_fread_test.c
	${MPICC} -o ${EXECS} mpi_fread_test.c

clean:
	rm -f ${EXECS}
