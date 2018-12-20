package PreProcessData;

import java.io.*;
import java.util.*;

class Test
{
	public static void main(String[] args) throws Exception
	{
/*
		TrectextCollection textDomo = new TrectextCollection();
		Map<String,String> first = textDomo.nextDocument();
		TrectextCollection.printMap(first);
		Map<String,String> second = textDomo.nextDocument();
		TrectextCollection.printMap(second);
*/
		TrecwebCollection webDomo = new TrecwebCollection();
		Map<String,String> first = webDomo.nextDocument();
		TrectextCollection.printMap(first);
		Map<String,String> second = webDomo.nextDocument();
		TrectextCollection.printMap(second);
	}//end main
}//end class Test