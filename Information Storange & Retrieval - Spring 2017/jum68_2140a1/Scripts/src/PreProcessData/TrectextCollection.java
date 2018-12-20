package PreProcessData;

import java.io.*;
import java.util.*;
import Classes.Path;

/**
 * This is for INFSCI 2140 in 2017
 *
 */

public class TrectextCollection implements DocumentCollection
{
	//you can add essential private methods or variables
	private HashSet<String> keyUsed = new HashSet<String>();
	private String fileName;
	private int start=0;
/*
	private BufferedReader bufferedReader;
	private BufferedWriter bufferedWriter;
*/
	// YOU SHOULD IMPLEMENT THIS METHOD
	public TrectextCollection() throws IOException
	{
		// This constructor should open the file in Path.DataTextDir
		// and also should make preparation for function nextDocument()
		// you cannot load the whole corpus into memory here!!

		fileName = Path.DataTextDir;
	}//end constructor

	public char charAt(String file, int index) throws Exception
	{
		file = fileName;
		FileReader reader = new FileReader(file);
		BufferedReader br = new BufferedReader(reader);
		br.skip(index);
		char ch = (char)br.read();
		br.close();
		return ch;
	}//end charAt
 
 	public int fileSearch(String pat, String file, int startPoint) throws Exception
	{	//[startPoint, the_end]
		file = fileName;
		FileReader readerI = new FileReader(file);
		BufferedReader brI = new BufferedReader(readerI);
		int i=startPoint;
		int chI;
        int M = pat.length();
 
		while ((chI=brI.read())!=-1)
		{ 
            int j;

            for (j = 0; j < M; j++)
			{
                if (charAt(file,i+j) != pat.charAt(j))
                    break;
            }//end for loop j
 
            //found 
            if (j == M)
			{
				brI.close();
                return i;
			}//end if

			i++;
        }//end for loop i
		brI.close();
        return -1;
	}//end fileSearch

	public String capture(int startIndex, int endIndex) throws Exception
	{	//[startIndex, endIndex]
		FileReader reader = new FileReader(fileName);
		BufferedReader br = new BufferedReader(reader);
		String captured="";

		br.skip(startIndex);
		int index=startIndex;
		int ch;

		while (index <= endIndex+1 && (ch=br.read())!=-1)
		{
			captured += (char)ch;
			index++;
		}//end while loop

		br.close();
		return captured;
	}//end Test_capture

	// YOU SHOULD IMPLEMENT THIS METHOD
	public Map<String, String> nextDocument() throws Exception
	{
		// this method should load one document from the corpus, and return this document's number and content.
		// the returned document should never be returned again.
		// when no document left, return null
		// NTT: remember to close the file that you opened, when you do not use it any more

		Map<String, String> map = new HashMap<String, String>();
		int startDocument = fileSearch("<DOC>",fileName,start);
		if (startDocument==-1)
		{
			return null;
		} else
		{
			int startDocNO = fileSearch("<DOCNO>",fileName,startDocument)+7;
			int endDocNO = fileSearch("</DOCNO>",fileName,startDocNO)-2;
			String key = capture(startDocNO,endDocNO).trim();

			int startContent = fileSearch("<TEXT>",fileName,startDocument)+6;
			int endContent = fileSearch("</TEXT>",fileName,startContent)-2;
			String value = capture(startContent,endContent).trim();

			int endDocument = fileSearch("</DOC>",fileName,start);
			start = endDocument+3;
			keyUsed.add(key);
			map.put(key,value);
			return map;
		}//end else
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
	}//end mapIteration
	
}//end class TrectextCollection