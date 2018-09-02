#include <mpi.h>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>

using namespace std;

struct status{
    long long int fopen_time, fread_time, fclose_time, sleep_time, total_time, total_read, missing_time;
    int sleep_count, file_count, rank;
};

int main(int argc, char** argv) {
    // Initialize the MPI environment
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

    int s_count = 12;
    MPI_Aint offsets[12] = {0, 8, 16, 24, 32, 40, 48, 56, 64, 68, 72, 76};
    int blocklengths[12] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
    MPI_Datatype types[12] = {MPI_LONG_LONG, MPI_LONG_LONG, MPI_LONG_LONG, MPI_LONG_LONG, MPI_LONG_LONG,
                                MPI_LONG_LONG, MPI_LONG_LONG, MPI_LONG_LONG, MPI_LONG_LONG, MPI_INT, MPI_INT, MPI_INT};
    MPI_Datatype my_mpi_type;
    MPI_Type_create_struct(s_count, blocklengths, offsets, types, &my_mpi_type);
    MPI_Type_commit(&my_mpi_type);


    status s = {0, 0, 0, 0, 0, 0, 0, 0, 0, world_rank};
    
    if (world_rank == 0) {
        int sender;
        int count = 0, total_files = 1000;

        while (count < total_files) {
            MPI_Recv(&sender, 1, MPI_INT, MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            
            MPI_Send(&count, 1, MPI_INT, sender, 0, MPI_COMM_WORLD);
            count += 1;
        }
        count = -1;
        for (int i = 1; i < world_size; i++)
            MPI_Send(&count, 1, MPI_INT, i, 0, MPI_COMM_WORLD); 
    }else {

        char file_name[53] = "/projects/AMASE/lyl/new_test_files_all_ost/file";
        //char file_name[46] = "/projects/AMASE/lyl/read_test_files/file";
        int read_size = 262144;
        char id_arr[5];
        FILE* file;
        char* buffer;
        buffer = (char*) malloc (sizeof(char) * read_size);
        int result;
        if (buffer == NULL) {fputs ("Memory error", stderr); exit (2);}
        int file_id;
        struct timeval start, end;
        //status s = {0, 0, 0, 0, 0, 0, 0, 0, 0, world_rank};

        struct timeval p_start, p_end;
        gettimeofday(&p_start, NULL);

        while (true) {
            MPI_Send(&world_rank, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
            MPI_Recv(&file_id, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            if (file_id == -1) {
                gettimeofday(&p_end ,NULL);
                s.total_time = ((p_end.tv_sec - p_start.tv_sec) * 1000000) + (p_end.tv_usec - p_start.tv_usec);
                s.missing_time = s.total_time - s.fopen_time - s.fread_time - s.fclose_time - s.sleep_time;

                
                break;
            }
            //cout << "processor " << world_rank << " reading file" << file_id << endl; 
            file_name[47] = '\0';
            sprintf(id_arr, "%ld", file_id);
            strcat(file_name, id_arr);
            cout << file_name<<endl;
            gettimeofday(&start, NULL);
            file = fopen(file_name, "rb");
            gettimeofday(&end ,NULL);
            s.fopen_time += ((end.tv_sec - start.tv_sec) * 1000000) + (end.tv_usec - start.tv_usec);

            result = read_size;
            while (result == read_size) {
                gettimeofday(&start, NULL);
                result = fread(buffer, 1, read_size, file);
                cout << "read size: " << result << endl; 
                gettimeofday(&end ,NULL);
                s.fread_time += ((end.tv_sec - start.tv_sec) * 1000000) + (end.tv_usec - start.tv_usec);
                s.total_read += result;

                if(result == read_size) {
                    gettimeofday(&start, NULL);
                    usleep(1500);
                    gettimeofday(&end ,NULL);
                    s.sleep_time += ((end.tv_sec - start.tv_sec) * 1000000) + (end.tv_usec - start.tv_usec);
                    s.sleep_count++;
                }
            }
            s.file_count++;
            

            cout << "process " << world_rank << " readed file" << file_id << endl;
            gettimeofday(&start, NULL);
            fclose(file);
            gettimeofday(&end ,NULL);
            s.fclose_time += ((end.tv_sec - start.tv_sec) * 1000000) + (end.tv_usec - start.tv_usec);   
        }
    }

    MPI_Barrier(MPI_COMM_WORLD);
    
    if (world_rank == 0) {
    	status r_s;
        for (int i = 1; i < world_size; i++) {
            MPI_Recv(&r_s, 1, my_mpi_type, MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            // printf("processor on node %s, rank %d out of %d processors:\n",
            //     processor_name, world_rank, world_size);
            printf("Rank %d out of %d processors:\n", r_s.rank, world_size);
            printf("Total open file time: %lldus\nTotal read file time: %lldus\nTotal close file time: %lldus\nSleep time: %lldus\nTotal elapsed time: %lldus\nMissing time:%lldus\nTotal bytes readed: %lld\nTotal files readed: %d\nTotal sleep counts: %d\n", 
                r_s.fopen_time, r_s.fread_time, r_s.fclose_time, r_s.sleep_time, r_s.total_time, r_s.missing_time, r_s.total_read, r_s.file_count, r_s.sleep_count);
            printf("===========================================================================\n");
        }
    }else {
    	cout << "rank" << s.rank << endl;          
        MPI_Send(&s, 1, my_mpi_type, 0, 0, MPI_COMM_WORLD);
    }


    //printf("Hello world from processor %s, rank %d out of %d processors\n",
           //processor_name, world_rank, world_size);

    // Finalize the MPI environment.
    MPI_Finalize();
}
