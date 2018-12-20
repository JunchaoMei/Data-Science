package Indexing;

import java.io.*;
import java.util.*;

public class MyIndexWriter
{
	// We suggest you to write very efficient code here, otherwise, your memory cannot hold our corpus...

	private BufferedWriter bwIndex;
	private BufferedWriter bwMap;
	private String type;
	private int docUsing = 1;
	private int indexFileNo = 1;
	private String dir;
	private LinkedList<BinaryTerm> binaryTermList = new LinkedList<BinaryTerm>();
	private HashMap<Integer,String> docid2docno = new HashMap<Integer,String>(); //docid->docno

	public MyIndexWriter(String Type) throws IOException
	{
		// This constructor should initiate the FileWriter to output your index files
		// remember to close files if you finish writing the index
		type = Type;
		if (type.equals("trectext"))
			dir = Classes.Path.IndexTextDir;
		else
			dir = Classes.Path.IndexWebDir;
		String fileName = dir+type+"Index_"+indexFileNo+".txt";
		bwIndex = new BufferedWriter(new FileWriter(fileName,true));
		String mapName = dir+type+"Map.txt";
		bwMap = new BufferedWriter(new FileWriter(mapName,true));
	}//end constructor
	
	public void IndexADocument(String docno, String content) throws IOException
	{
		// you are strongly suggested to build the index by installments
		// you need to assign the new non-negative integer docId to each document, which will be used in MyIndexReader
		
		//record mapping of docid->docno
		docid2docno.put(docUsing,docno);
		//split content into an array of String
		String[] terms = StringSplit.content2String(content);
		int n = terms.length;

		//construct binary terms
		HashSet<String> termSet = new HashSet<String>();

		for (int i=0; i<n; i++)
		{
			String currentTerm = terms[i];
			if (!termSet.contains(currentTerm))//new term
			{
				termSet.add(currentTerm);
				BinaryTerm BInew = new BinaryTerm(currentTerm,docUsing,1);
				binaryTermList.add(BInew);
			} else //existed term
			{
				int BTL_index = ListRetrieval.index(binaryTermList,docUsing,currentTerm);
				binaryTermList.get(BTL_index).termFreq++;
			}//end else
		}//end for loop

		if (docUsing%20==0)
		{
			//sort the binaryTermList
			ListRetrieval.mergesort(binaryTermList);
			//covert binaryTermList into entryList
			LinkedList<Entry> EL = BinaryTermList2EntryList.EntryList(binaryTermList);

		//write files

			//write index file (binaryTermList)
			int nEL = EL.size();
			for (int i=0; i<nEL; i++)
			{
				Entry E = EL.get(i);
				E.getDocFreq();
				String line = /*i+": "+*/E.term+" "+E.colFreq+" "+E.docFreq+" docIDs: ";
				for (int j=0; j<E.docFreq; j++)
					line += E.docIDs.get(j)+"-"+E.termFreqs.get(j)+" ";
				line += "\n";
				bwIndex.write(line);
			}//end for loop i

			//write map file (docid2docno)
			Iterator it = docid2docno.keySet().iterator();
			while (it.hasNext())
			{
				Object key = it.next();
				String value = docid2docno.get(key);
				String line = key + " " + value + "\n";
				bwMap.write(line);
			}//end while loop

			//empty RAM
			binaryTermList.clear();
			docid2docno.clear();
			bwIndex.close();
			bwMap.close();

			//update writer
			indexFileNo++;
			String fileName = dir+type+"Index_"+indexFileNo+".txt";
			bwIndex = new BufferedWriter(new FileWriter(fileName,true));
			String mapName = dir+type+"Map.txt";
			bwMap = new BufferedWriter(new FileWriter(mapName,true));
			System.gc();
		}//end if
		
		docUsing++;
	}//end IndexADocument
	
	public void Close() throws Exception
	{
		// close the index writer, and you should output all the buffered content (if any).
		// if you write your index into several files, you need to fuse them here.

		//output the last partial block
		{
			//sort the binaryTermList
			ListRetrieval.mergesort(binaryTermList);
			//covert binaryTermList into entryList
			LinkedList<Entry> EL = BinaryTermList2EntryList.EntryList(binaryTermList);

		//write files

			//write index file (binaryTermList)
			int nEL = EL.size();
			for (int i=0; i<nEL; i++)
			{
				Entry E = EL.get(i);
				E.getDocFreq();
				String line = /*i+": "+*/E.term+" "+E.colFreq+" "+E.docFreq+" docIDs: ";
				for (int j=0; j<E.docFreq; j++)
					line += E.docIDs.get(j)+"-"+E.termFreqs.get(j)+" ";
				line += "\n";
				bwIndex.write(line);
			}//end for loop i

			//write map file (docid2docno)
			Iterator it = docid2docno.keySet().iterator();
			while (it.hasNext())
			{
				Object key = it.next();
				String value = docid2docno.get(key);
				String line = key + " " + value + "\n";
				bwMap.write(line);
			}//end while loop

			//empty RAM
			binaryTermList.clear();
			docid2docno.clear();
			bwIndex.close();
			bwMap.close();
			System.gc();
		}//end code block

		//merge all the inverted index files
		String mergedFile = dir+type+"Merged_final.txt";
		IndexMerge.mergeIndexFiles(indexFileNo, mergedFile,type);
	}//end Close
	
}//end class MyIndexWriter