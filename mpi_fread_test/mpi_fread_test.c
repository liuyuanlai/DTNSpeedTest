// Author: Wes Kendall
// Copyright 2011 www.mpitutorial.com
// This code is provided freely with the tutorials on mpitutorial.com. Feel
// free to modify it for your own use. Any distribution of the code must
// either provide a link to www.mpitutorial.com or keep this header intact.
//
// An intro MPI hello world program that uses MPI_Init, MPI_Comm_size,
// MPI_Comm_rank, MPI_Finalize, and MPI_Get_processor_name.
//
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include<string.h>

int main(int argc, char** argv) {
  // Initialize the MPI environment. The two arguments to MPI Init are not
  // currently used by MPI implementations, but are there in case future
  // implementations might need the arguments.
  MPI_Init(NULL, NULL);

  // Get the number of processes
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);

  // Get the rank of the process
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

  // Get the name of the processor
  char processor_name[MPI_MAX_PROCESSOR_NAME];
  int name_len;
  MPI_Get_processor_name(processor_name, &name_len);

  // Print off a hello world message

  char file_name[72] = "/global/cscratch1/sd/yuanlai/gf_test/new_test_files_limit_ost/file";
  int read_size = 224000;
  int file_id = world_rank;
  char* id_arr[5];
  sprintf(id_arr, "%ld", file_id);
  strcat(file_name, id_arr);
  FILE* file;
  file = fopen(file_name, "rb");
  if (!file) {fputs ("File open error!", stderr); exit(1);}
  char* buffer;
  buffer = (char*) malloc (sizeof(char) * read_size);
  if (buffer == NULL) {fputs ("Memory error", stderr); exit (2);}
  int result = read_size;

  while (result == read_size) {
    result = fread(buffer, 1, read_size, file);
    printf("Read %d bytes from processor %s, rank %d out of %d processors\n",
         result, processor_name, world_rank, world_size);
  }

  // Finalize the MPI environment. No more MPI calls can be made after this
  MPI_Finalize();
}
