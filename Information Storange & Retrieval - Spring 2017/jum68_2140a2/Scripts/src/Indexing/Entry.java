package Indexing;

import java.util.*;

class Entry
{
	//Document Frequency: the number of documents that contain the term
	//Collection Frequency: the number of occurrences of term in the collection
	//Term Frequency: the number of occurrences of term in the document

	public String term;
	public LinkedList<Integer> docIDs = new LinkedList<Integer>();
	public LinkedList<Integer> termFreqs= new LinkedList<Integer>();
	public long colFreq=0;
	public int docFreq;

	public Entry(String TERM)
	{
		term = TERM;
	}//end constructor1

	public void inputBI(BinaryTerm BI)
	{
		docIDs.add(BI.docid);
		termFreqs.add(BI.termFreq);
		colFreq += BI.termFreq;
	}//end inputBI

	public void getDocFreq()
	{
		docFreq = docIDs.size();
	}//end getDocFreq

}//end class BinaryTerm