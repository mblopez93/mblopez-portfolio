#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>
#include <stdlib.h>
#define SIZE 128

extern char **getline();

int main() {
  int i;
  int parental_control;
  int control;
  char **args;
  pid_t proc_id1;
  pid_t proc_id2;
  int id2;
  int id1;
  
  /* FLAGS */
  int FLAG_OUT_TO_FILE;
  int FLAG_IN_FR_FILE;
  int FLAG_PIPE;
  int FLAG_VALID_FILE;  
    
  /* COMMAND ARGUMENTS */
  int in;
  int out;
  char* out_loc = "";
  char* in_loc = "";
  int pipe_fd[2];
  int pipe_pos;
    
  /*prompts for user input*/ 
  printf("You have opened myshell!\n");
  printf("Please type a command or 'exit' to quit\n");

  while(1) {
    FLAG_OUT_TO_FILE = 0;
    FLAG_IN_FR_FILE  = 0;
    FLAG_PIPE        = 0;
    FLAG_VALID_FILE  = 0;

    /* gets input from stdin*/
    args = getline();
    
    /* empty command */
    if ( args[0] == '\0') {
      printf("Enter a command or 'exit'\n");
      continue;
    }
    
    /* terminate shell */
    if ( strcmp(args[0], "exit") == 0) {
      printf("You are now exiting myshell.\n");
      exit(0);
    }

    /* parse arguments */
    for (i = 0; args[i] != NULL; i++) {
      /* check for redirect < and possible error 
	 set flags and store arguments  */
      if ( (strcmp(args[i], "<") == 0) ) {
        if (args[i+1] == NULL) {
	  FLAG_VALID_FILE = 0;
	  fprintf(stderr, "ERROR: No file for < redirect!\n");
	} else {
	  FLAG_IN_FR_FILE = 1;
	  FLAG_VALID_FILE = 1;
	  args[i] = NULL;
	  in_loc = args[i+1];
	  args[i+1] = NULL;
	  break;
	}
      }

      /* check for redirect > and possible error 
	 set flag and store arguments  */
      if ( (strcmp(args[i], ">") == 0) ) {
	if (args[i+1] == NULL) {
	  FLAG_VALID_FILE = 0;
	  fprintf(stderr, "ERROR: No file for > redirect!\n");
	} else {
	  FLAG_OUT_TO_FILE = 1;
	  FLAG_VALID_FILE = 1;
	  args[i] = NULL;
	  out_loc = args[i+1];
	  args[i+1] = NULL;;
	  break;
	}
      }

      /* check for pipe | and possible errors 
         set flag and store arguments */
      if ( (strcmp(args[i], "|") == 0) ) {
         FLAG_PIPE = 1;
	 pipe_pos = i;
	 args[i] = NULL;

	 if(pipe(pipe_fd)<0) {
	   perror("pipe");
	 }

	 break;
      }
    }

    /* CHILD THINGS */
    proc_id1 = fork();

      if ( (proc_id1 < 0) ) {
	perror("fork");
	exit(2);
      } else if ( proc_id1 == 0 ) {
     
	/* Child, do redirect < */
	if (FLAG_IN_FR_FILE && FLAG_VALID_FILE) {
	in = open(in_loc, O_RDONLY);

	if (in < 0) {
	  perror("open");
	  exit(1);
	}

	dup2(in,STDIN_FILENO);
	close(in);
      }
      
      /* Child, do Redirect > */
      if (FLAG_OUT_TO_FILE && FLAG_VALID_FILE) {
	out = open( out_loc, O_WRONLY|O_CREAT, 0666 );

	if (out < 0) {
	  perror("open");
	  exit(1);
	}

	dup2(out, STDOUT_FILENO);
	close(out);
      }

      /* Child, do Pipes | */
      if (FLAG_PIPE == 1) {
	pipe(pipe_fd);
	proc_id2 = fork();
	if (proc_id2 == 0) {
	  wait(&id1);
	  
	  printf("DEBUG: doin' pipe things in id2\n");
	  /* parse the right side of pipe */
	  args[0] = args[pipe_pos+1];
	  args[pipe_pos+1] = NULL;

	  /* replace stdin with read part of pipe, then close the write pt */
	  close(1);
	  dup2(pipe_fd[1],1);
	  close(pipe_fd[0]);

	  id2 = execvp(args[pipe_pos+1], args);
	  perror ("execvp");
	  exit(1);
	  
	} else if (proc_id2 > 0) {

	  printf("DEBUG: doin' pipe things in id1\n");
	  
	  /* replace stdout with write part of pipe, then close the read pt */
	  close(0);
	  dup2(pipe_fd[0], 0);
	  close(pipe_fd[1]);
	  
	  id1 = execvp(args[0], args);
	  perror("execvp");
	  exit(1);
	} else {
	  perror("fork");
	  exit(1);
	}
       	
	
      }
      
      /* Child, just do things */
      if (!FLAG_PIPE) control = execvp(args[0], args); //works kinda
      perror("execvp");
      exit(1);

    } else {

    /* PARENT THINGS */
      /* Parent waits. Hurry up, children */
      if ( !FLAG_PIPE ) {
	parental_control = wait(&control);
      } else {
	parental_control = wait(&id2);
      }

      if (parental_control == -1){
	perror("wait");
	exit(1);
      }
    }
  }    
}
