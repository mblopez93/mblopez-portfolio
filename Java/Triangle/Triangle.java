/*
**
** Program: *Fantastic* Equilateral Triangle Creator
** Author: Ma Lopez
**  
*/

import java.util.*;
public class Triangle {
	public static void main (String[] args){
		int run = 1; //allows the program to execute the do-loop
		do {
		/* Introduction Prompt */
		System.out.print("Hello, Ol' Chap! \n Welcome to the Fantastic Equaliteral Triangle Creator! \n You tell us the length side; we create your fantastic triangle! ");
		System.out.print(" \n Please enter the length size (greater than 2) of your desired triangle:");
		
		
		/* User input and Variable Declarations */
		Scanner input = new Scanner(System.in);
		int line, y; //line dictates the row (horizontal) of the triangle;
		int size = input.nextInt(); //the scanner will read the input from the user and assign it to the size (so that we know what size of the triangle to make)
		String space = " "; //space
		String star = ""; //will be used for the asterik (*)
		
		
		/* Error Prompt 
		** Does not allow the user to input an integer less than 2 and simply prompts the user for another input
		** It will keep looping while the size is less than 2
		*/
		while(size < 2){
			System.out.print("Tricksy! The length sides MUST be greater than 2. Please try again:");
			size = input.nextInt();
		}
		
		/* Triangle For loop
		** Reads in the size and will loop as long as the line is greater than zero, but updates with decrement
		** 		first it prints out a space
		** 			 goes into the for-loop to print the asteriks, that will loop as long as y is greater than 0, updates with decrement
		**				it will print a space then the asterik
		** Prints a new line
		** Another for loop accounts for the proper amount of spaces; as long as the line is less than or equal to the size of the sidelengths, z will increment 
		** 		Prints another space
		*/
		for(line = size; line >=0; line--){
				System.out.print(" ");
				for(y = line-1; y >= 0; y--){
					System.out.print(space);
					star= "*";
					System.out.print(star);
				}
				System.out.println();

				for(int z = line; z<=size; z++){
					System.out.print(space);
				}
		}
		
		
		/* Exit/Restart Prompt */ 
		System.out.println(" ");
		System.out.print("Would you like to create another fantastic triangle? I quite recommed you do! (y/n)");
		Scanner user_input = new Scanner(System.in);
		char endChoice = user_input.next().charAt(0);
		if (endChoice == 'y') {
			run = 1; //continue to loop
		} 
		else{
			/* The farewell prompt */
			System.out.println("Good Day!");
			run = 0;
		}
		} while(run == 1);
	}
}