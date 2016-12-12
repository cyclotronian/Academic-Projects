#include <stdio.h>
#include <fcntl.h>
#include <assert.h>
#include <string.h>

int main(int argc, char *argv[]){
	char buf[100];
	memset(buf,0,100);
	int fp = open("/dev/myDev",O_RDWR);
	while(1){
		read(fp,&buf[0],1);
	}
}
