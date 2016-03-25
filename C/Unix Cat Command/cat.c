/*   Ma Lopez
	 cat program C File 
*/


#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include "cat.h" //not really necessary

int main(int argc, char *argv[]) {
    char buffer[1028];
    //    FILE *point;
    int op, rd, wr;
    if (argc < 2) {
      write(2,"not enough arguments\n",22);
      return -1;
    }
    int i=1;
      while (i < argc) {
	op = open(argv[i], O_RDONLY);
	if (op == -1) {
	  write(2,"can't open file\n",17);
	  return -1;
	}
        rd = read(op, buffer, sizeof(buffer));
	if (rd == -1) {
	    write(2,"can't read file\n", 17);
	    return -1;
        }
        wr = write(1, buffer, rd);
	if (wr == -1) {
	  write(2,"can't write to stdout\n", 23);
	  return -1;
	}
	close(op);
	i++;
      }
    
    return 0;
}



