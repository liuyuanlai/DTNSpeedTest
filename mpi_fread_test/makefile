<<<<<<< HEAD
EXECS=lustre_bao_mpi_fread_test
#EXECS=mira_sao_mpi_fread_test
=======
#EXECS=gpfs_sao_mpi_fread_test
EXECS=mira_bao_mpi_fread_test
>>>>>>> 51ac96f3008f2a0c32c732d48088683c6c648047
MPICC?=mpicc

all: ${EXECS}

${EXECS}: mpi_fread_test.c
	${MPICC} -o ${EXECS} mpi_fread_test.c

clean:
	rm -f ${EXECS}
