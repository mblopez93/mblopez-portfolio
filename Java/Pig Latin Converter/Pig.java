/*
**
** Program: Pig Converter
** Author: Ma Lopez
**
*/

import java.util.Scanner;

public class Pig {
	
	/* Method: pigLatinConvert
	** Converts the input string, englishWord, according to the vowel, special q, and consonant cases as specified on the website
	** Expected examples: 	
	**				Vowel Rule: apple -> appleay
	**				Consonant Rule: Trash -> rashtay 
	**				Special Case: quarry -> arryquay
	*/
	
	public static String pigLatinConvert(String englishWord) {
		String pigWord = " ";
		
		/* vowel case */
		if(englishWord.charAt(0) == 'a' || englishWord.charAt(0) == 'e' || englishWord.charAt(0) == 'i' || englishWord.charAt(0) == 'o' || englishWord.charAt(0)== 'u') { 
			pigWord = englishWord + "ay";
			return pigWord;
		}
		/* special q case */
		else if (englishWord.charAt(0) == 'q') { 
			pigWord = englishWord.substring(2) + "quay";
			return pigWord;
		} 
		/* consonant case */
		else {
			pigWord = englishWord.substring(1) + englishWord.charAt(0) + "ay";
			return pigWord;
		}
	}

	public static void main(String[] args) {
		
		int game = 1;
		do {
			/* Introduction Prompt */
			System.out.print("Hello! Welcome to Pig Converter! \n Please enter a word, sentence or phrase to begin: ");
			
			
			/* Scanner Declarations 
			** This takes in the input from the user (scanner called input) 
			** and places that into a string variable (called sentence)
			** Then the new scanner (called phrase) will be used to read the 'sentence' string */
			Scanner input = new Scanner(System.in);
			String sentence = input.nextLine();
			Scanner phrase = new Scanner(sentence);
			
			
			/* Read Loops 
			** These while loops allow the program to check whether or not there is a line to read or more words to read
			** In the first while loop: the string variable (called englishWord) will be used to store the first word and englishWord
			** 		will be used as the String variable when the method pigLatinConvert is called; the string in the method will be converted
			** 		to Pig Latin
			** In the nested (second) while loop: the program will see if it has any more words and will store (one word at a time) into 
			** 		englishWord and proceed to convert englishWord into Pig Latin also using the method pigLatinConvert */
			while (phrase.hasNextLine()){
				String englishWord = phrase.next();
				System.out.print(pigLatinConvert(englishWord));
				while(phrase.hasNext()){
					englishWord = phrase.next();
					System.out.print(" " + pigLatinConvert(englishWord));
				}
				System.out.println();
			}
			
			
			/* Exit/Restart Prompt */ 
			System.out.println(" ");
			System.out.println("Would you like to convert another phrase? (y/n)");
			Scanner user_input = new Scanner(System.in);
			char endChoice = user_input.next().charAt(0);
			if (endChoice == 'y') {
				game = 1;
			} 
			else{
				/* The farewell prompt
				** Also uses the method pigLatinConvert to convert the goodbye message to Pig Latin */
				System.out.println(pigLatinConvert("Good") + " " + pigLatinConvert("Day") + "!");
				game = 0;
			}
		} while (game == 1);
	}
}	