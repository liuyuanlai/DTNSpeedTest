#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>

#define MAX_FNAME_LEN 1024
#define MAX_LOG_LEN   1024
#define BLOCK_SIZE    262144
#define S2MICRO_S     1000000

int main(int argc, char** argv) {
    if (argc != 2){
        printf("please provide a file which saves the file name list\n");
        exit(0);
    }
    char file_name[MAX_FNAME_LEN], log_buffer[MAX_LOG_LEN];
    FILE* fp;
    char* io_buffer = (char*) malloc (sizeof(char) * BLOCK_SIZE);

    MPI_Init(NULL, NULL);
    int np, rank, ret;
    MPI_Comm_size(MPI_COMM_WORLD, &np);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len, req_rank, done_cnt = 0;
    size_t rd_size;
    MPI_Get_processor_name(processor_name, &name_len);

    int net_wr_us = (int)(BLOCK_SIZE / (1e10 / (np - 1)) * S2MICRO_S); // network write time, asssue 80Gbps
    // rank 0 works as the scheduler
    char* tmp_rdbuf = NULL;
    if (rank == 0) {
        fp = fopen(argv[1], "r");
        if (!fp) {
            printf("Cannot open file of file name\n"); 
            exit(0);
        }
        for(int r=1; r<np; r++){
            if (getline(&tmp_rdbuf, &rd_size, fp) != -1){ // use fscanf if ost information is provided
                tmp_rdbuf[strlen(tmp_rdbuf)-1] = '\0'; // remove CR
                strcpy(file_name, tmp_rdbuf);
                ret = MPI_Send(&file_name, MAX_FNAME_LEN, MPI_CHAR, r, 0, MPI_COMM_WORLD);
            }            
        }
        // printf("start experiment with np:%d\n", np);
        while (1){
            ret = MPI_Recv(&req_rank, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            if (getline(&tmp_rdbuf, &rd_size, fp) != -1){ // use fscanf if ost information is provided
                tmp_rdbuf[strlen(tmp_rdbuf)-1] = '\0'; // remove CR
                strcpy(file_name, tmp_rdbuf);
                ret = MPI_Send(&file_name, MAX_FNAME_LEN, MPI_CHAR, req_rank, 0, MPI_COMM_WORLD);
            }
            else{ // when there is no more file to transfer
                file_name[0] = '\0'; // send an empty file name to represent finishing 
                // printf("send finishing signal to %d\n", req_rank);
                ret = MPI_Send(&file_name, MAX_FNAME_LEN, MPI_CHAR, req_rank, 0, MPI_COMM_WORLD);
                ret = MPI_Recv(log_buffer, MAX_LOG_LEN, MPI_INT, req_rank, MPI_ANY_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                done_cnt ++ ;
                printf("%s", log_buffer);
            }
            if (done_cnt == (np-1)){
                break;
            }
        }
        free(tmp_rdbuf);
        fclose(fp);
    }else{
        struct timeval start, end, g_start, g_end;
        long long tfopen = 0, tfread = 0, tfclose = 0, tsleep = 0, telapse = 0, cfread = 0, nfile = 0, nbyte = 0, rtsleep = 0;
        long long t_per_fread; 
        gettimeofday(&g_start, NULL);
        ret = MPI_Recv(file_name, MAX_FNAME_LEN, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        while(1){
            // send a dummy to request a file from scheduler
            // printf("%d sent request to scheduler\n", rank);
            // send log to rank 0 when there is no more job
            if (strlen(file_name) == 0){
                gettimeofday(&g_end, NULL);
                telapse = ((g_end.tv_sec - g_start.tv_sec) * S2MICRO_S) + (g_end.tv_usec - g_start.tv_usec);
                // printf("%d received a finishing signal\n", rank);
                snprintf(log_buffer, MAX_LOG_LEN, "%d,%d,%s,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld\n", 
                         np-1, rank-1, processor_name, nfile, nbyte, tfopen, tfread, tfclose, tsleep, telapse, cfread, rtsleep);

                ret = MPI_Send(log_buffer, MAX_LOG_LEN, MPI_CHAR, 0, 0, MPI_COMM_WORLD);
                break;
            }
            nfile += 1;
            // printf("%d received task %s\n", rank, file_name);

            gettimeofday(&start, NULL);
            fp = fopen(file_name, "rb");
            gettimeofday(&end, NULL);
            if (!fp) {
                printf("file open error: %s", file_name); 
                continue;
            }
            tfopen += ((end.tv_sec - start.tv_sec) * S2MICRO_S) + (end.tv_usec - start.tv_usec);

            while(1){
                gettimeofday(&start, NULL);
                rd_size = fread(io_buffer, 1, BLOCK_SIZE, fp);
                gettimeofday(&end, NULL);
                t_per_fread = ((end.tv_sec - start.tv_sec) * S2MICRO_S) + (end.tv_usec - start.tv_usec);
                tfread += t_per_fread; 
                nbyte  += rd_size;
                cfread ++;
                if (rd_size != BLOCK_SIZE){
                    break;
                }
                //long long _tsleep = net_wr_us > t_per_fread ? net_wr_us - t_per_fread: 0;
                long long _tsleep = 0;
                gettimeofday(&start, NULL);
                //usleep(_tsleep);
                //usleep(0);
                gettimeofday(&end, NULL);
                rtsleep += _tsleep;
                tsleep  += ((end.tv_sec - start.tv_sec) * S2MICRO_S) + (end.tv_usec - start.tv_usec);            
            }
            gettimeofday(&start, NULL);
            fclose(fp);
            gettimeofday(&end, NULL);
            tfclose += ((end.tv_sec - start.tv_sec) * S2MICRO_S) + (end.tv_usec - start.tv_usec);

            ret = MPI_Send(&rank, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
            ret = MPI_Recv(file_name, MAX_FNAME_LEN, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
    }
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Finalize();
}
