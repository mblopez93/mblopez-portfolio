# Ma Lopez
# myshell makefile

myshell:
	flex lex.l
	cc -Wall lex.yy.c myshell.c -o myshell -lfl
	#cc -Wall -lfl myshell.c lex.yy.c -o myshell
clean:
	rm lex.yy.c
	rm myshell
