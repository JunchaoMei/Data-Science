package PreProcessData;

import java.io.*;
import java.util.*;
import Classes.Path;

public class StopWordRemover
{
	//you can add essential private methods or variables
	private ArrayList<String> stopwordsArray = new ArrayList<String>();

	public StopWordRemover( ) throws IOException
	{
		// load and store the stop words from the fileinputstream with appropriate data structure
		// that you believe is suitable for matching stop words.
		// address of stopword.txt should be Path.StopwordDir

		String  br_line = null;
			try
			{
				// open input stream test.txt for reading purpose.
				BufferedReader br = new BufferedReader(new FileReader(Path.StopwordDir));

			    while ((br_line = br.readLine()) != null)
				{
					br_line = br.readLine();
					stopwordsArray.add(br_line.trim());
			    }//end while loop

			    br.close();
			} catch(Exception e)
				{e.printStackTrace();}
	}//end constructor
	
	// YOU MUST IMPLEMENT THIS METHOD
	public boolean isStopword(String word )
	{
		boolean statue=false;

		for (String words: stopwordsArray) 
		{
			if(word.equals(words))
			{
				statue = true;
				break;
			}//end if
		}//end foreach loop

		// return true if the input word is a stopword
		if(statue)
			return true;
		else //or false if not
			return false;
	}//end isStopword

}//end class StopWordRemover