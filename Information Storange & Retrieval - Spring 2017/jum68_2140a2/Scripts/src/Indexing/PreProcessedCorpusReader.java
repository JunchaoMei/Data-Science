package Indexing;

import java.io.*;
import java.util.*;

public class PreProcessedCorpusReader
{
	private String fileName;
	private LineNumberReader lr;
	
	public PreProcessedCorpusReader(String type) throws IOException
	{
		// This constructor opens the pre-processed corpus file, Path.ResultHM1 + type
		// You can use your own version, or download from http://crystal.exp.sis.pitt.edu:8080/iris/resource.jsp
		// Close the file when you do not use it any more

		fileName = Classes.Path.ResultHM1 + type;
		lr = new LineNumberReader(new FileReader(fileName));
		lr.setLineNumber(0);
	}//end constructor
	
	public Map<String, String> NextDocument() throws IOException
	{
		// read a line for docNo, put into the map with <"DOCNO", docNo>
		// read another line for the content , put into the map with <"CONTENT", content>

		Map<String, String> store=new HashMap<>();
		String lrline = null;
		String key = null;
		String value = null;

		if ((lrline=lr.readLine())!= null)
			key = lrline; //get key
		else
		{
			lr.close();
			return null;
		}//end else

		if ((lrline=lr.readLine())!= null)	
			value = lrline; //get value
		else
		{
			lr.close();
			return null;
		}//end else

		//put key & value
		store.put(key,value);

		return store;
	}//end NextDocument()

	public static void printMap(Map<String, String> map)
	{
		if (map != null)
		{
			Set<String> keySet = map.keySet();
			Iterator<String> it = keySet.iterator();
			while (it.hasNext())
			{
				Object key = it.next();
				Object value = map.get(key);
				System.out.println(key+": \n"+value);
			}//end while
		} else
			System.out.println("map is null");

	}//end printMap

}//end class PreProcessedCorpusReader