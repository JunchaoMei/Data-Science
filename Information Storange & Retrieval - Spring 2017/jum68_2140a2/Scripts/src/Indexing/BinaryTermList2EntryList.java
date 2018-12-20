package Indexing;

import java.util.*;
import java.io.*;

class BinaryTermList2EntryList
{
	public static LinkedList<Entry> EntryList(LinkedList<BinaryTerm> BTL) //BTL is sorted
	{
		LinkedList<Entry> EL = new LinkedList<Entry>();
		int nBTL = BTL.size();
		String currentTerm = null;
		String lastTerm = null;
		int j = -1; //index of EL

		for (int i=0; i<nBTL; i++)
		{
			BinaryTerm BI = BTL.get(i);
			currentTerm = BI.term;

			if (!currentTerm.equals(lastTerm) || i==0)
			{
				Entry E_new = new Entry(currentTerm);
				E_new.inputBI(BI);
				EL.add(E_new);
				j++;
			} else //currentTerm==lastTerm
			{
				EL.get(j).inputBI(BI);
			}//end else
							
			lastTerm = currentTerm;
		}//end for loop i

		return EL;
	}//end EntryList

	public static void printEntryList(LinkedList<Entry> EL)
	{
		int n = EL.size();
		for (int i=0; i<n; i++)
		{
			Entry E = EL.get(i);
			int m = E.docIDs.size();
			System.out.print(i+": "+E.term+" "+E.colFreq+" "+m+" docIDs: ");
			for (int j=0; j<m; j++)
				System.out.print(E.docIDs.get(j)+"-"+E.termFreqs.get(j)+" ");
			System.out.println();
		}//end for loop i
	}//end printEntryList

	public static void printEntry(Entry E)
	{
		int m = E.docIDs.size();
		System.out.print(E.term+" "+E.colFreq+" "+m+" docIDs: ");
		for (int j=0; j<m; j++)
			System.out.print(E.docIDs.get(j)+"-"+E.termFreqs.get(j)+" ");
	}//end printEntry

	public static Entry String2Entry(String str)
	{
		String[] strs = StringSplit.content2String(str);
		int n = strs.length;

		Entry E = new Entry(strs[0]);
		E.colFreq = Integer.parseInt(strs[1]);
		E.docFreq = Integer.parseInt(strs[2]);

		for (int i=4; i<n; i++)
		{
			String[] I = strs[i].split("-");
			E.docIDs.add(Integer.parseInt(I[0]));
			E.termFreqs.add(Integer.parseInt(I[1]));
		}//end for loop i

		return E;
	}//end String2Entry

	public static LinkedList<Entry> file2EntryList(String mergedIndexFile) throws Exception
	{
		LinkedList<Entry> result = new LinkedList<Entry>();
		BufferedReader br = new BufferedReader(new FileReader(mergedIndexFile));
		String line;
		while ((line=br.readLine())!=null)
		{
			Entry E = String2Entry(line);
			result.add(E);
		}//end while loop
		br.close();
		return result;
	}//end file2EntryList

	public static HashMap<Integer,String> docid_docno(String mapFile) throws Exception
	{
		HashMap<Integer,String> result = new HashMap<Integer,String>();
		BufferedReader br = new BufferedReader(new FileReader(mapFile));
		String line;
		while ((line=br.readLine())!=null)
		{
			String[] strs = StringSplit.content2String(line);
			Integer docid = Integer.parseInt(strs[0]);
			String docno = strs[1];
			result.put(docid,docno);
		}//end while loop
		br.close();
		return result;
	}//end docid_docno

	public static void printMap(HashMap map)
	{
		Set keySet = map.keySet();
		Iterator it = keySet.iterator();
		while (it.hasNext())
		{
			Object key = it.next();
			Object value = map.get(key);
			System.out.println(key+":"+value);
		}//end while loop
	}//end printMap

	public static void main(String[] args) throws Exception
	{
		//initialization
		BinaryTerm A = new BinaryTerm("a1",1,5);
		BinaryTerm B = new BinaryTerm("a1",2,4);
		BinaryTerm C = new BinaryTerm("c3",3,3);
		BinaryTerm D = new BinaryTerm("d4",4,2);
		BinaryTerm E = new BinaryTerm("d4",5,1);
		LinkedList<BinaryTerm> BTL = new LinkedList<BinaryTerm>();
		BTL.add(A);BTL.add(B);BTL.add(C);BTL.add(D);BTL.add(E);
/*
		LinkedList<Entry> EL = EntryList(BTL);
		printEntryList(EL);

		Entry E_new = String2Entry("a 19 4 docIDs: 1-2 2-3 3-7 4-7 ");
		printEntry(E_new);
*/
		LinkedList<Entry> EL_new = file2EntryList("merged_final.txt");
		printEntryList(EL_new);

		HashMap<Integer,String> docid2docno = docid_docno("Map.txt");
		printMap(docid2docno);
	}//end main
}//end class BinaryTermList2EntryList