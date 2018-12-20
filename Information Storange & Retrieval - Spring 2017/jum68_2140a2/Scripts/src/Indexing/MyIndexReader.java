package Indexing;

import java.io.*;
import java.util.*;

public class MyIndexReader
{
	// We suggest you to write very efficient code here, otherwise, your memory cannot hold our corpus...
	LinkedList<Entry> EntryList;
	HashMap<Integer,String> docid2docno;
	String dir;
	
	public MyIndexReader( String type ) throws Exception
	{
		//read the index files you generated in task 1
		//remember to close them when you finish using them
		//use appropriate structure to store your index

		if (type.equals("trectext"))
			dir = Classes.Path.IndexTextDir;
		else
			dir = Classes.Path.IndexWebDir;

		EntryList = BinaryTermList2EntryList.file2EntryList(dir+type+"Merged_final.txt");
		docid2docno = BinaryTermList2EntryList.docid_docno(dir+type+"Map.txt");
	}//end constructor
	
	//get the non-negative integer dociId for the requested docNo
	//If the requested docno does not exist in the index, return -1
	public int GetDocid( String docno )
	{
		for (Map.Entry<Integer,String> m : docid2docno.entrySet())
		{
			if(docno.equals(m.getValue()))
				return m.getKey().intValue();
		}//end foreach loop

		return -1;
	}//end GetDocid

	// Retrieve the docno for the integer docid
	public String GetDocno( int docid )
	{
		Integer Docid = docid;
		if (docid2docno.containsKey(Docid))
			return docid2docno.get(Docid);
		else
			return null;
	}//end GetDocno
	
	/**
	 * Get the posting list for the requested token.
	 * 
	 * The posting list records the documents' docids the token appears and corresponding frequencies of the term, such as:
	 *  
	 *  [docid]		[freq]
	 *  1			3
	 *  5			7
	 *  9			1
	 *  13			9
	 * 
	 * ...
	 * 
	 * In the returned 2-dimension array, the first dimension is for each document, and the second dimension records the docid and frequency.
	 * 
	 * For example:
	 * array[0][0] records the docid of the first document the token appears.
	 * array[0][1] records the frequency of the token in the documents with docid = array[0][0]
	 * ...
	 * 
	 * NOTE that the returned posting list array should be ranked by docid from the smallest to the largest. 
	 * 
	 * @param token
	 * @return
	 */
	public int[][] GetPostingList( String token ) throws IOException
	{

		int index = indexOfEL(token);
		if (index!=-1)
		{
			Entry E = EntryList.get(index);
			int n = E.docIDs.size();
			int[][] result = new int[n][2];
			for (int i=0; i<n; i++)
			{
				result[i][0] = E.docIDs.get(i);
				result[i][1] = E.termFreqs.get(i);
			}//end for loop i
			return result;
		} else
			return null;
	}//end GetPostingList

	public int indexOfEL(String token)
	{
		for (Entry E : EntryList)
		{
			if (E.term.equals(token))
				return EntryList.indexOf(E);
		}//end foreach loop
		return -1;
	}//end indexOfEL

	// Return the number of documents that contains the token.
	public int GetDocFreq( String token ) throws IOException
	{
		int index = indexOfEL(token);
		if (index!=-1)
		{
			Entry E = EntryList.get(index);
			return E.docFreq;
		} else
			return 0;
	}//end GetDocFreq

	// Return the total number of times the token appears in the collection.
	public long GetCollectionFreq( String token ) throws IOException
	{
		int index = indexOfEL(token);
		if (index!=-1)
		{
			Entry E = EntryList.get(index);
			return E.colFreq;
		} else
			return 0;
	}//end GetCollectionFreq
	
	public void Close() throws IOException
	{
	}//end Close
	
}//end class MyIndexReader