// Client side C/C++ program to demonstrate Socket programming 
#include <stdio.h> 
#include <sys/socket.h> 
#include <stdlib.h> 
#include <netinet/in.h> 
#include <string.h> 
#include <time.h>
#include <sys/time.h>
#define PORT 50100
#define BLOCK_SIZE 262144
#define SEND_SEG 2048
#define MAX_FNAME_LEN 1024
   
int main(int argc, char const *argv[]) 
{ 
    struct sockaddr_in address; 
    int sock = 0, valread; 
    struct sockaddr_in serv_addr; 
    char *hello = "Hello from client"; 
    char buffer[1024] = {0}; 
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) 
    { 
        printf("\n Socket creation error \n"); 
        return -1; 
    } 
   
    memset(&serv_addr, '0', sizeof(serv_addr)); 
   
    serv_addr.sin_family = AF_INET; 
    serv_addr.sin_port = htons(PORT); 
       
    // Convert IPv4 and IPv6 addresses from text to binary form 
    if(inet_pton(AF_INET, "140.221.68.96", &serv_addr.sin_addr)<=0)  
    { 
        printf("\nInvalid address/ Address not supported \n"); 
        return -1; 
    } 
   
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) 
    { 
        printf("\nConnection Failed \n"); 
        return -1; 
    }
    long long int total_size = 5368709120;
    int file_num = atoi(argv[1]);
    //printf("%d files\n", file_num);
    int file_count;
    long long int file_size = total_size / file_num;
    char* io_buffer = (char*) malloc (sizeof(char) * BLOCK_SIZE);
    char file_name[20] = "/dev/zero";
    FILE* fp;
    size_t rd_size;
    //char fid[10];
    long long int size_count;
    int sent_once;
    int tsleep;
    struct timeval start, end;
    while(file_count < file_num) {
	fp = fopen(file_name, "rb");
        size_count = 0;
        while (size_count < file_size) {
	    rd_size = fread(io_buffer, 1, BLOCK_SIZE, fp);
            sent_once = send(sock, io_buffer, BLOCK_SIZE, 0);
            size_count += sent_once;
        }

        //gettimeofday(&start, NULL);
        //usleep(200000);
        //gettimeofday(&end, NULL);
        //tsleep = ((end.tv_sec - start.tv_sec) * 1000) + (end.tv_usec - start.tv_usec) / 1000;
        //printf("sleeped %d\n", tsleep);
        file_count += 1;
	fclose(fp);
	io_buffer[0] = '\0';
	send(sock, io_buffer , 1, 0);
    }
    close(sock);
    // for (i = 0; i < 10; i++) {
        // sprintf(fid, "%d", i);
        // strcpy(file_name, "/global/cscratch1/sd/yuanlai/gf_test/from_chame/20_1G/file");
        // strcat(file_name, fid);
        // printf("Send file %s\n", file_name);
        // fp = fopen(file_name, "rb");
        // if (!fp) {
        //     printf("file open error: %s", file_name); 
        //     return 0;
        // }
        // int sent_total;
        // size_t bytesleft;
        // int sent_once;
        // while(1) {
        //     rd_size = fread(io_buffer, 1, BLOCK_SIZE, fp);
        //     if (rd_size != BLOCK_SIZE){
        //         break;
        //     }
        //     sent_total = 0;        // how many bytes we've sent
        //     bytesleft = rd_size; // how many we have left to send

        //     while(sent_total < rd_size) {
        //         sent_once = send(sock, io_buffer + sent_total, bytesleft, 0);
        //         printf("%d data is sent\n", sent_once);
        //         if (sent_once == -1) { break; }
        //         sent_total += sent_once;
        //         bytesleft -= sent_once;
        //         //valread = recv(sock , buffer, 1024, 0);
        //         //printf("%s data received by server\n", buffer);
        //     }

             
        // }
        // fclose(fp);
        // printf("Transfer %s is done\n", file_name);
    // }
    //buffer[0] = '\0';
    //send(sock, buffer , 1024, 0);

    return 0; 
} 
