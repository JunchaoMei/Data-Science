package PseudoRFSearch;

import java.util.*;
import Classes.*;

class listSort
{
	public static void bubbleSort (List<Document> list)
	{
		int n = list.size();
		for (int i = 0; i < n-1; i++)
		{
			for (int j = 0; j < n-i-1; j++)
			{
				Document J = list.get(j);
				double Jscore = J.score();
				Document J1 = list.get(j+1);
				double J1score = J1.score();

				if (Jscore < J1score)
					swap(list,j,j+1);
			}//end for loop j
		}//end for loop i
	}//end bubbleSort

	public static void swap(List<Document> list, int i, int j)
	{
		final List l = list;
		l.set(i, l.set(j, l.get(i)));
	}//end swap

	public static void printList(List<Document> list)
	{
		int n = list.size();
		for (int i=0; i<n; i++)
		{
			Document I = list.get(i);
			System.out.println(I.docid()+" "+I.docno()+" "+I.score());
		}//end for loop i
	}//end printList

	public static void main(String[] args)
	{
		List<Document> list = new ArrayList<Document>();
		Document doc1 = new Document("docid1","docno1",0.04);
		Document doc2 = new Document("docid2","docno2",0.01);
		Document doc3 = new Document("docid3","docno3",0.03);
		Document doc4 = new Document("docid4","docno4",0.02);
		Document doc5 = new Document("docid5","docno5",0.05);
		list.add(doc1);list.add(doc2);list.add(doc3);list.add(doc4);list.add(doc5);
		System.out.println("Before sorting:");
		printList(list);
		bubbleSort(list);
		System.out.println("After sorting:");
		printList(list);
	}//end main
}//end class listSort