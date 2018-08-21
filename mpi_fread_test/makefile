#EXECS=lustre_bao_mpi_fread_test
#EXECS=mira_sao_mpi_fread_test
#EXECS=gpfs_sao_mpi_fread_test
#EXECS=mira_bao_mpi_fread_test
EXECS=dynamic_mira_sao_mpi_fread_test
MPICC?=mpicc

all: ${EXECS}

${EXECS}: dynamic_mpi_fread_test.c
	${MPICC} -o ${EXECS} dynamic_mpi_fread_test.c

clean:
	rm -f ${EXECS}
