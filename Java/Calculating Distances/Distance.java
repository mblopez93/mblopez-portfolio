/*
** Program: Distance
** Author: Ma Lopez 
**
*/


import java.util.Scanner;

public class Distance {

	public static void main (String[] args) {
	
		/* Acquire User Inputs for the point coordinates */			
		Scanner user_input = new Scanner(System.in);										//allows user input
		
		/* Introduction */
		System.out.println("When prompted, please enter the desired inputs. Then press Enter to continue.");
		System.out.printf("%n");
		
		/* Inputting First Coordinates */
		System.out.print("Please enter your first x-coordinate: ");
		double x1 = user_input.nextDouble(); 											//stores user input as x1
		System.out.printf("%n");
		System.out.print("Please enter your first y-coordinate: ");
		double y1 = user_input.nextDouble();											//stores user input as y1
	
		System.out.printf("%n");
		
		/* Inputting Second Coordinates */
		System.out.print("Please enter your second x-coordinate: ");
		double x2 = user_input.nextDouble();											//stores user input as x2
		System.out.printf("%n");
		System.out.print("Please enter your second y-coordinate: ");
		double y2 = user_input.nextDouble();											//stores user input as y2
		 
		System.out.printf("%n");

		/* Output of First Coordinates */
		System.out.print("Your first coordinate is: " + x1);
		System.out.print(" , ");
		System.out.print(y1);
		
		System.out.printf("%n");;
		
		/* Output of Second Coordinates */
		System.out.print("Your second coordinate is: " + x2);
		System.out.print(" , ");
		System.out.print(y2);
		
		System.out.printf("%n");
		
		
		/* Double to Integer conversion */
		int x1Int = (int)x1;
		int x2Int = (int)x2;
		int y1Int = (int)y1;
		int y2Int = (int)y2;
		
		
		/* Distances between the points */
		int xDist = x2Int - x1Int;													//x distance
		int yDist = y2Int - y1Int;													//y distance
	
	
		/* Euclidean Distance! */
		int eXDist = xDist*xDist;												//x distance squared 
		int eYDist = yDist*yDist;												//y distance squared
		int eXYSum = eXDist + eYDist;											//sum of the squared distances
		double euclidDist = Math.sqrt(eXYSum);									//the square root of (x^2 + y^2) is the Euclidean distance
		double finalEuclid = (double)Math.round(euclidDist* 100) / 100; 		// rounds the Euclidean distance to two decimal places

	
		/* Manhattan Distance! */
		int manDist = Math.abs(xDist) + Math.abs(yDist);						//the sum of the absolute values of x and y distance is Manhattan Distance
		double finalManhattan = (double)Math.round(manDist* 100) / 100;			// rounds the Manhattan distance to two decimal places
	
		/* Output of the Euclidean and Manhattan Distances */
		System.out.printf("%n");
		System.out.println("Euclidean Distance: " + finalEuclid);
		System.out.println("Manhattan Distance: " + finalManhattan);
	}

}
