package Classes;

public class WordTokenizer
{
	//you can add essential private methods or variables
	String[] words;
	private int num;

	// YOU MUST IMPLEMENT THIS METHOD
	public WordTokenizer(String text)
	{
		// this constructor will tokenize the input text
		// please remove all punctuations

		words = text.replaceAll("[^a-zA-Z ]", "").split("\\s+");
	}//end constructor
	
	// YOU MUST IMPLEMENT THIS METHOD
	public String nextWord()
	{
		// read and return the next word of the document
		// or return null if it is the end of the document

		if(this.num < this.words.length)
			return words[num++];
		else
			return null;
	}//end nextWord
	
}//end class WordTokenizer