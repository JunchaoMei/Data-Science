package Classes;

public class WordNormalizer
{
	//you can add essential private methods or variables
	
	// YOU MUST IMPLEMENT THIS METHOD
	public String lowercase(String str)
	{
		str = str.toLowerCase();
		//transform the uppercase characters in the word to lowercase
		return str;
	}//end lowercase
	
	public String stem(String str)
	{
		//use the stemmer in Classes package to do the stemming on input word, and return the stemmed word

		Stemmer stem = new Stemmer();
	    //return stem.stem(str);
		stem.add(str.toCharArray(), str.length());
		stem.stem();
		return stem.toString();
	}//end stem
	
}//end class WordNormalizer