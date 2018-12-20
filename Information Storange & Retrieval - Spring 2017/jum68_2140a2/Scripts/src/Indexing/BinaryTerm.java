package Indexing;

class BinaryTerm
{
	//Document Frequency: the number of documents that contain the term
	//Collection Frequency: the number of occurrences of term in the collection
	//Term Frequency: the number of occurrences of term in the document

	public String term;
	public int docid;
	public int termFreq;

	public BinaryTerm(int DOCID, int TERMFERQ)
	{
		docid = DOCID;
		termFreq = TERMFERQ;
	}//end constructor1

	public BinaryTerm(String TERM, int DOCID, int TERMFERQ)
	{
		term = TERM;
		docid = DOCID;
		termFreq = TERMFERQ;
	}//end constructor2

	public void update(String TERM, int DOCID, int TERMFERQ)
	{
		term = TERM;
		docid = DOCID;
		termFreq = TERMFERQ;
	}//end update

}//end class BinaryTerm