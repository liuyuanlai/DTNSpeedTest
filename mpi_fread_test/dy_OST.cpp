#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>
#include <unordered_map>
#include <vector>
#include <utility>
#include <string>
#include <algorithm>
#include <iostream>

using namespace std;

#define MAX_FNAME_LEN 1024
#define MAX_LOG_LEN   1024
#define BLOCK_SIZE    262144
#define S2MICRO_S     1000000
#define OST_NUM 5

int getNextOST(vector<int>& ost_count, vector<bool>& ost_completed) {
    int min_load_ost = -1, min_load = 100000;
    for (int i = 0; i < OST_NUM; i++) {
        if (!ost_completed[i] && ost_count[i] < min_load) {
            min_load_ost = i;
            min_load = ost_count[i];
        }
    }
    return min_load_ost;
}

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

    vector<vector<pair<int, string>>> v_file_ost(OST_NUM);

    if (rank == 0) {
        fp = fopen(argv[1], "r");
        if (!fp) {
            printf("Cannot open file of file name\n"); 
            exit(0);
        }

        char fname[MAX_FNAME_LEN], fsize[10], fost[10];
        string f_name;
        int f_size, f_ost;

        while (fscanf(fp, "%s %s %s", fname, fsize, fost) != EOF) {
            f_name = fname; 
            f_size = atoi(fsize);
            f_ost = atoi(fost);
            cout << f_name << " " << f_size << " " << f_ost << endl;
            v_file_ost[f_ost].push_back({f_size, f_name});
        }

        for (int i = 0; i < OST_NUM; i++)
            sort(v_file_ost[i].begin(), v_file_ost[i].end(), [](const pair<int, string>& a, 
                const pair<int, string>& b) {return a.first > b.first; });
    }



    MPI_Barrier(MPI_COMM_WORLD);

    // rank 0 works as the scheduler
    if (rank == 0) {

        vector<int> ost_pointer(OST_NUM, 0);
        vector<int> ost_count(OST_NUM, 0);
        unordered_map<int, int> rank_ost;
        vector<bool> ost_completed(OST_NUM, false);


        // printf("start experiment with np:%d\n", np);
        while (1){
            ret = MPI_Recv(&req_rank, 1, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            if (rank_ost.find(req_rank) != rank_ost.end()) {
                ost_count[rank_ost[req_rank]] -= 1;
            }
            int next_ost = getNextOST(ost_count, ost_completed);
            //cout << "next ost:" << next_ost << endl;

            if (next_ost >= 0) {
                string f_name = v_file_ost[next_ost][ost_pointer[next_ost]++].second;
                if (ost_pointer[next_ost] == v_file_ost[next_ost].size()) ost_completed[next_ost] = true;
                rank_ost[req_rank] = next_ost;
                ost_count[next_ost] += 1;

                strcpy(file_name, f_name.c_str());
                ret = MPI_Send(&file_name, MAX_FNAME_LEN, MPI_CHAR, req_rank, 0, MPI_COMM_WORLD);

                printf("Assign reading task: %s to %d\n", file_name, req_rank);

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
        fclose(fp);
    }else{
        struct timeval start, end, g_start, g_end;
        long long tfopen = 0, tfread = 0, tfclose = 0, tsleep = 0, telapse = 0, cfread = 0, nfile = 0, nbyte = 0;
        gettimeofday(&g_start, NULL);
        while(1){
            // send a dummy to request a file from scheduler
            // printf("%d sent request to scheduler\n", rank);
            ret = MPI_Send(&rank, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
            ret = MPI_Recv(file_name, MAX_FNAME_LEN, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            // send log to rank 0 when there is no more job
            if (strlen(file_name) == 0){
                gettimeofday(&g_end, NULL);
                telapse = ((g_end.tv_sec - g_start.tv_sec) * S2MICRO_S) + (g_end.tv_usec - g_start.tv_usec);
                // printf("%d received a finishing signal\n", rank);
                snprintf(log_buffer, MAX_LOG_LEN, "%d,%d,%s,%lld,%lld,%lld,%lld,%lld,%lld,%lld,%lld\n", 
                         np-1, rank-1, processor_name, nfile, nbyte, tfopen, tfread, tfclose, tsleep, telapse, cfread);

                ret = MPI_Send(log_buffer, MAX_LOG_LEN, MPI_CHAR, 0, 0, MPI_COMM_WORLD);
                break;
            }
            nfile += 1;
            printf("%d received task %s\n", rank, file_name);

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
                tfread += ((end.tv_sec - start.tv_sec) * S2MICRO_S) + (end.tv_usec - start.tv_usec);
                nbyte  += rd_size;
                cfread ++;
                if (rd_size != BLOCK_SIZE){
                    break;
                }

                gettimeofday(&start, NULL);
                usleep(0);
                gettimeofday(&end, NULL);
                tsleep += ((end.tv_sec - start.tv_sec) * S2MICRO_S) + (end.tv_usec - start.tv_usec);            
            }
            gettimeofday(&start, NULL);
            fclose(fp);
            gettimeofday(&end, NULL);
            tfclose += ((end.tv_sec - start.tv_sec) * S2MICRO_S) + (end.tv_usec - start.tv_usec);
        }
    }
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Finalize();
}
