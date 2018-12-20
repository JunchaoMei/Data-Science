package Indexing;

import java.util.*;

class ListRetrieval
{
	public static int index(LinkedList<BinaryTerm> LL, int Docid, String Term)
	{
		int n = LL.size();
		for (int i=0; i<n; i++)
		{
			BinaryTerm BI = LL.get(i);
			if (BI.docid == Docid && BI.term.equals(Term))
				return i;
		}//end for loop i
		return -1;
	}//end index

	public static void printBTList(LinkedList<BinaryTerm> LL)
	{
		int n = LL.size();
		for (int i=0; i<n; i++)
		{
			BinaryTerm BI = LL.get(i);
			System.out.println(i+": "+BI.term+" "+BI.docid+" "+BI.termFreq);
		}//end for loop i
	}//end printBTList

	public static void mergesort (LinkedList<BinaryTerm> S)
	{
		int n = S.size();

		if (n>1)
		{
			int h = n/2, m = n-h;
			LinkedList<BinaryTerm> U = new LinkedList<BinaryTerm>();
			LinkedList<BinaryTerm> V = new LinkedList<BinaryTerm>();

			//copy S[0] through S[h-1] to U[0] through U[h-1]
			for (int i=0; i<=h-1; i++)
			{
				BinaryTerm Si = new BinaryTerm(S.get(i).term,S.get(i).docid,S.get(i).termFreq);
				U.add(Si);
			}//end for loop i

			//copy S[h] through S[n-1] to V[0] through V[m-1]
			for (int i=h; i<=n-1; i++)
			{
				BinaryTerm Si = new BinaryTerm(S.get(i).term,S.get(i).docid,S.get(i).termFreq);
				V.add(Si);
			}//end for loop i

			mergesort(U);
			mergesort(V);

			merge(h,m,U,V,S);
		}//end if
	}//end mergesort

	public static void merge (int h, int m, LinkedList<BinaryTerm> U, LinkedList<BinaryTerm> V, LinkedList<BinaryTerm> S)
	{
		int i,j,k;
		i=1;j=1;k=1;

		while (i<=h && j<=m)
		{
			if ( U.get(i-1).term.compareTo(V.get(j-1).term) <= 0)
			{	
				S.get(k-1).update(U.get(i-1).term,U.get(i-1).docid,U.get(i-1).termFreq);
				i++;
			} else
			{
				S.get(k-1).update(V.get(j-1).term,V.get(j-1).docid,V.get(j-1).termFreq);
				j++;
			}//end else
			k++;
		}//end while

		if (i>h)
		{
			//copy V[j-1] through V[m-1] to S[k-1] through S[h+m-1];
			for (int x=j-1; x<=m-1; x++)
			{
				S.get(x+k-j).update(V.get(x).term,V.get(x).docid,V.get(x).termFreq);
			}//end for loop x
		} else
		{
			//copy U[i-1] through U[h-1] to S[k-1] through S[h+m-1];
			for (int x=i-1; x<=h-1; x++)
			{
				S.get(x+k-i).update(U.get(x).term,U.get(x).docid,U.get(x).termFreq);
			}//end for loop x
		}//end else
	}//end merge

	public static void main(String[] args)
	{
		//initialization
		BinaryTerm A = new BinaryTerm("a1",1,1);
		BinaryTerm B = new BinaryTerm("a1",2,2);
		BinaryTerm C = new BinaryTerm("c3",1,3);
		BinaryTerm D = new BinaryTerm("d4",3,4);
		BinaryTerm E = new BinaryTerm("d4",4,5);
		LinkedList<BinaryTerm> LL = new LinkedList<BinaryTerm>();
		LL.add(E);LL.add(D);LL.add(C);LL.add(B);LL.add(A);
/*
		//test method - index
		int BTL_index = index(LL,1,"c3");
		LL.get(BTL_index).termFreq++;
		System.out.println(C.termFreq);
*/
		//test method - printBTList
		System.out.println("Before Sorting:");
		printBTList(LL);
		//test method - mergesort
		mergesort(LL);
		System.out.println("After Sorting:");
		printBTList(LL);
	}//end main
}//end class ListRetrieval