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
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>

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
  if (world_rank == 0) 
  	printf("Application start timestamp: %ld\n", time(NULL));

  // Get the name of the processor
  char processor_name[MPI_MAX_PROCESSOR_NAME];
  int name_len;
  MPI_Get_processor_name(processor_name, &name_len);

  // Print off a hello world message

  //char file_name[70] = "/global/cscratch1/sd/yuanlai/gf_test/new_test_files_all_ost/file";
  //char file_name[80] = "/global/cscratch1/sd/yuanlai/gf_test/new_test_files_limit_ost_smaller/file";
  //char file_name[63] = "/global/cscratch1/sd/yuanlai/gf_test/read_test_files/file";
  
  char file_name[79] = "/global/project/projectdirs/m2930/lyl/gf_test/new_test_files_all_ost/file";
  //char file_name[71] = "/global/project/projectdirs/m2930/lyl/gf_test/l2g_test_files/file";
  int read_size = 262144;
  int file_id = world_rank;
  char id_arr[5];
  FILE* file;
  char* buffer;
  buffer = (char*) malloc (sizeof(char) * read_size);
  int result;
  if (buffer == NULL) {fputs ("Memory error", stderr); exit (2);}

  //clock_t start, end;
  struct timeval start, end;
  long long int fopen_time = 0, fread_time = 0, fclose_time = 0, sleep_time = 0;
  long long int total_read = 0;
  //clock_t p_start = 0, p_end = 0;
  struct timeval p_start, p_end;
  //p_start = clock();
  gettimeofday(&p_start, NULL);
  int sleep_count = 0, file_count = 0;
  while (file_id < 59581) {
  //while (file_id < 4000) {
    //strncpy(file_name, file_name_pre, 72);
    //file_name[64] = '\0';
    //file_name[74] = '\0';
    //file_name[57] = '\0';

    file_name[73] = '\0';
    //file_name[65] = '\0';
    sprintf(id_arr, "%ld", file_id);
    strcat(file_name, id_arr);
    //start = clock();
    file_count++;
    //printf("reading file: %s on node: %s\n", file_name, processor_name);
    gettimeofday(&start, NULL);
    file = fopen(file_name, "rb");
    //end = clock();
    gettimeofday(&end ,NULL);
    //fopen_time += ((double) (end - start)) / CLOCKS_PER_SEC;
    fopen_time += ((end.tv_sec - start.tv_sec) * 1000000) + (end.tv_usec - start.tv_usec);
    if (!file) {printf("file open error: %s", file_name); exit(1);}
    
 
    result = read_size;
    while (result == read_size) {
      //start = clock();
      gettimeofday(&start, NULL);
      result = fread(buffer, 1, read_size, file);
      //end = clock();
      gettimeofday(&end ,NULL);
      //fread_time += ((double) (end - start)) / CLOCKS_PER_SEC;
      fread_time += ((end.tv_sec - start.tv_sec) * 1000000) + (end.tv_usec - start.tv_usec);
      total_read += result;
      gettimeofday(&start, NULL);
      usleep(1500);
      gettimeofday(&end ,NULL);
      sleep_time += ((end.tv_sec - start.tv_sec) * 1000000) + (end.tv_usec - start.tv_usec);
      sleep_count++;
    }
    gettimeofday(&start, NULL);
    fclose(file);
    gettimeofday(&end ,NULL);
    fclose_time += ((end.tv_sec - start.tv_sec) * 1000000) + (end.tv_usec - start.tv_usec);
    file_id += 10;
  }
  //p_end = clock();
  gettimeofday(&p_end ,NULL);
  //double total_time = ((double) (p_end - p_start)) / CLOCKS_PER_SEC;
  long long int total_time = ((p_end.tv_sec - p_start.tv_sec) * 1000000) + (p_end.tv_usec - p_start.tv_usec);
  printf("processor on node %s, rank %d out of %d processors:\n",
            processor_name, world_rank, world_size);
  long long int missing_time = total_time - fopen_time - fread_time - fclose_time - sleep_time;
  printf("Total open file time: %lldus\nTotal read file time: %lldus\nTotal close file time: %lldus\nSleep time: %lldus\nTotal elapsed time: %lldus\nMissing time:%lldus\nTotal bytes readed: %lld\nTotal files readed: %d\nTotal sleep counts: %d\n", 
            fopen_time, fread_time, fclose_time, sleep_time, total_time, missing_time, total_read, file_count, sleep_count);
  printf("=================================================================\n");
  MPI_Barrier(MPI_COMM_WORLD);
  if (world_rank == 0) 
  	printf("Application end timestamp: %ld\n", time(NULL));
  // Finalize the MPI environment. No more MPI calls can be made after this
  MPI_Finalize();
}
