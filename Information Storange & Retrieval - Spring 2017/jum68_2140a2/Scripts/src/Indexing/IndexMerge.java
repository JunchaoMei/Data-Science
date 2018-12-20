package Indexing;

import java.io.*;

class IndexMerge
{
	public static String merge2Strings(String a, String b)
	{
		//spliting
		String[] A = StringSplit.content2String(a);
		int nA = A.length;
		String[] B = StringSplit.content2String(b);
		int nB = B.length;

		//add term
		String m0 = A[0];

		//add colFreq
		int a1 = Integer.parseInt(A[1]);
		int b1 = Integer.parseInt(B[1]);
		String m1 = String.valueOf(a1+b1);

		//add docFreq
		int a2 = Integer.parseInt(A[2]);
		int b2 = Integer.parseInt(B[2]);
		String m2 = String.valueOf(a2+b2);

		//add "docIDs:"
		String m3 = "docIDs:";

		//add docid-termFreq
		String m4 = "";
		for (int iA=4; iA<nA; iA++)
			m4 += A[iA] + " ";
		for (int iB=4; iB<nB; iB++)
			m4 += B[iB] + " ";

		//sum to merged
		String m = m0+" "+m1+" "+m2+" "+m3+" "+m4;
		return m;
	}//end merge2Strings

	public static int compareWith(String a, String b) //(a-b)
	{
		String[] A = StringSplit.content2String(a);
		String[] B = StringSplit.content2String(b);
		return A[0].compareTo(B[0]);
	}//end compareWith

	public static void merge2Files(String fileName1, String fileName2, String mergedFileName) throws Exception
	{		//fileName1 = "mergedIndex_i.txt" (i=2~maxIndexFileNo)
		//initialization
		LineNumberReader lr1 = new LineNumberReader(new FileReader(fileName1));
		lr1.setLineNumber(0);
		LineNumberReader lr2 = new LineNumberReader(new FileReader(fileName2));
		lr2.setLineNumber(0);
		BufferedWriter bw = new BufferedWriter(new FileWriter(mergedFileName));

		//merge
		String a=lr1.readLine();
		String b=lr2.readLine();
		String line;
		while (a!=null || b!=null)
		{
			if (a!=null && b!=null)
			{
				if (compareWith(a,b)<0)
				{
					line = a;
					a = lr1.readLine();
				} else if (compareWith(a,b)==0)
				{
					String m = merge2Strings(a,b);
					line = m;
					a = lr1.readLine();
					b = lr2.readLine();
				} else
				{
					line = b;
					b = lr2.readLine();
				}//end else
			} else if (a==null)
			{
				line = b;
				b = lr2.readLine();
			} else //if (b==null)
			{
				line = a;
				a = lr1.readLine();
			}//end else

			bw.write(line);
			bw.newLine();
		}//end while loop
		bw.close();
		lr1.close();
		lr2.close();
	}//end merge2Files

	public static void deleteIntermediateFiles(int maxIndexFileNo, String type)
	{
		String dir;
		if (type.equals("trectext"))
			dir = Classes.Path.IndexTextDir;
		else
			dir = Classes.Path.IndexWebDir;
		for (int i=0; i<maxIndexFileNo; i++)
		{
			String filePath = dir+type+"Merged_"+i+".txt";
			FileOperation.deleteFile(filePath);
		}//end for loop i
	}//end deleteIntermediateFiles

	public static void mergeIndexFiles(int maxIndexFileNo, String finalMergedName, String type) throws Exception
	{	
		//require: pre-created file "data/"+type+"Merged_0.txt";
		String dir;
		if (type.equals("trectext"))
			dir = Classes.Path.IndexTextDir;
		else
			dir = Classes.Path.IndexWebDir;
		for (int i=1; i<=maxIndexFileNo; i++)
		{
			//merge_0 + Index_1 = merge_1 ...
			//merge_1 + Index_2 = merge_2 ...
			String fileName1 = dir+type+"Merged_"+(i-1)+".txt";
			String fileName2 = dir+type+"Index_"+i+".txt";
			String mergedFileName = dir+type+"Merged_"+i+".txt";
			merge2Files(fileName1,fileName2,mergedFileName);
		}//end for loop i

		//delete intermediate files
		deleteIntermediateFiles(maxIndexFileNo,type);

		//rename the final file
		String oldPath = dir+type+"Merged_"+maxIndexFileNo+".txt";
		String newPath = finalMergedName;
		FileOperation.renameFile(oldPath,newPath);
	}//end mergeIndexFiles

	public static void main(String[] args) throws Exception
	{
/*
		//test merge2Strings
		String a = "a 4 2 docIDs: 1-2 2-2";
		String b = "a 3 1 docIDs: 3-3 ";
		String m = merge2Strings(a,b);
		System.out.println(m);

		//test compareWith
		System.out.println(compareWith(a,b));

		//test merge2Files
		String fileName1 = "Index_1.txt";
		String fileName2 = "Index_2.txt";
		String mergedFileName = "test_merge2Files.txt";
		merge2Files(fileName1,fileName2,mergedFileName);
*/
		//test mergeIndexFiles
		//mergeIndexFiles(6, "merged_final.txt",type);
	}//end main
}//end IndexMerge