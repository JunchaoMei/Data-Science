package PreProcessData.Basic_Methods;

import java.util.*;

/**
* param search -> content
* param buf -> pattern
*/

class KMP
{
	public static int search(String search, String buf)
	{
		int[] next = new int[search.length()];
		kmpNext(search, next);
		int i = 0;
		int j = 0;

		while(i < search.length() && j < buf.length())
		{
			
			if(i == -1 || search.charAt(i) == buf.charAt(j))
			{
				i++;
				j++;
			} else
				i = next[i];
		}//end while

		if(i == search.length())
			return j - i;
		else
			return -1;
	}//end search
	
	private static void kmpNext(String buf, int next[])
	{
		int m = 0;
		int n = -1;
		next[0] = -1;

		while(m < buf.length() - 1)
		{
			if(n == -1 || buf.charAt(m) == buf.charAt(n))
			{
				m++;
				n++;
				next[m] = n;
			} else
				n = next[n];//if no found
		}//end while
	}//end kmpNext

	public static void main(String[] args)
	{
		Scanner inScan = new Scanner(System.in);
		System.out.println("Please input the Content String: ");
		String content = inScan.next();
		System.out.println("Please input the Pattern String: ");
		String pattern = inScan.next();

		int location = search(pattern, content);
		System.out.println("The start index is " + location);
	}//end main
}//end KMP