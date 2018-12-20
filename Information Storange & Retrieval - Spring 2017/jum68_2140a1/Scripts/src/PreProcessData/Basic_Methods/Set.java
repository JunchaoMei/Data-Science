package PreProcessData.Basic_Methods;

import java.util.*;

class Set
{
	public static boolean contains(HashSet<String> set, String str)
	{
		Iterator<String> it = set.iterator();

		while (it.hasNext())
		{
			String nextString = it.next();
			if (nextString.equals(str))
			{
				return true;
			}//end if
		}//end while
		return false;
	}//end contains

	public static void main(String[] args)
	{
		//initialize HashSet
		HashSet<String> keyUsed = new HashSet<String>();
		keyUsed.add("111");
		keyUsed.add("222");
		keyUsed.add("333");

		//initialize str
		String str1 = "12345";
		String str2 = "222";

		//test
		System.out.println("str1 in keyUsed: "+contains(keyUsed, str1));
		System.out.println("str2 in keyUsed: "+contains(keyUsed, str2));
	}//end main
}//end class Set