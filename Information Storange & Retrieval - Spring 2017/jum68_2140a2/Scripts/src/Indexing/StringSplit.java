package Indexing;

import java.util.*;

class StringSplit
{
	public static String[] content2String(String content)
	{
		String [] arr = content.split("\\s+");
		return arr;
	}//end content2String

	public static void main (String[] args)
	{
		String content = "cairo januari xinhua violenc seem on rise inegypt as a latest sign";
		String[] segments = content2String(content);
		System.out.println(Arrays.toString(segments));
		System.out.println(segments.length);
	}//end main
}//end class StringSplit