package Classes;

import java.io.*;
import java.util.*;

/**
 * This is for INFSCI 2140 in 2017
 *
 */

public class TrectextCollection implements DocumentCollection 
{
	// YOU SHOULD IMPLEMENT THIS METHOD
	// This constructor should open the file in Path.DataTextDir
	// and also should make preparation for function nextDocument()
	// you cannot load the whole corpus into memory here!!

	//you can add essential private methods or variables
	BufferedReader br;
	
	public TrectextCollection(String pathTopics) throws IOException
	{
		try
		{
	         br = new BufferedReader(new FileReader(pathTopics));
	    } catch(Exception e)
		{
	         e.printStackTrace();
	    }//end try...catch
	}//end constructor

	public Map<String, String> nextDocument() throws IOException
	{
		// YOU SHOULD IMPLEMENT THIS METHOD
		// this method should load one document from the corpus, and return this document's number and content.
		// the returned document should never be returned again.
		// when no document left, return null
		// NTT: remember to close the file that you opened, when you do not use it any more

		Map<String, String> store=new HashMap<>();
		String brline;
		String key = null;
		String text = null;
		brline = br.readLine();

		while ((brline=br.readLine())!= null)
		{
			if(brline.trim().startsWith("<num>")/* && brline.trim().endsWith("</num>")*/)
			{
				key=brline.substring(6);
				//System.out.println(key);
			}//end if
			
			if(brline.trim().startsWith("<title>")/* && brline.trim().endsWith("</title>")*/)
			{
				text=brline.substring(8);
				store.put(key,text);
				//System.out.println(text);
				break;
			}//end if
		}//end while loop

		if (brline != null)
		return store;
		else return null;
	}//end nextDocument

	public static void printMap(Map<String, String> map)
	{
		Set<String> keySet = map.keySet();
		Iterator<String> it = keySet.iterator();
		while (it.hasNext())
		{
			Object key = it.next();
			Object value = map.get(key);
			System.out.println(key+": \n"+value);
		}//end while
	}//end printMap

}//end class TrectextCollection