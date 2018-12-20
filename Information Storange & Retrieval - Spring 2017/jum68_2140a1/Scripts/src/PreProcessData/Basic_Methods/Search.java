package PreProcessData.Basic_Methods;

import java.io.*;

public class Search
{ 
     /** 
    * 使用暴力字符串查找方式，在txt中查找和pat匹配的子字符串 
    *  
    * @param pat 
    *            匹配的模板字符串 
    * @param txt 
    *            查找的字符串 
    * @return 模板字符串第一次出现的位置 
    */ 
    public static int BF_search(String pat, String txt, int startPoint) 
	{	//[startPoint, the end]
        int M = pat.length();
        int N = txt.length();
 
        // 逐个位置匹配模式字符串 
        for (int i = startPoint; i < N; i++) 
		{ 
            int j; 
            for (j = 0; j < M; j++)
			{ 
                if (txt.charAt(i + j) != pat.charAt(j))
                    break; 
            }//end for loop j
 
            //found 
            if (j == M)
                return i; 
        }//end for loop i
        return -1; 
    }//end search

	public static char charAt(String fileName, int index) throws Exception
	{
		FileReader reader = new FileReader(fileName);
		BufferedReader br = new BufferedReader(reader);
		br.skip(index);
		char ch = (char)br.read();
		br.close();
		return ch;
	}//end charAt
 
 	public static int fileSearch(String pat, String fileName, int startPoint) throws Exception
	{	//[startPoint, the_end]
		FileReader readerI = new FileReader(fileName);
		BufferedReader brI = new BufferedReader(readerI);
		int i=startPoint;
		int chI;
        int M = pat.length();
 
		while ((chI=brI.read())!=-1) 
		{ 
            int j;

            for (j = 0; j < M; j++)
			{
                if (charAt(fileName,i+j) != pat.charAt(j))
                    break;
            }//end for loop j
 
            //found 
            if (j == M)
                return i;
			i++;
        }//end for loop i
		brI.close();
        return -1;
	}//end fileSearch

    public static void main(String[] args) throws Exception
	{ 
        //String txt = "012345678901234567890123456789"; 
        //String pat = "678"; 
 
        //System.out.println(BF_search(pat, txt, 22)); 
		System.out.println(charAt("docset.trectext",62));
		System.out.println(fileSearch("<DOC>","docset.trectext",40));
		
    }//end main
}//end class Search