package Search;

import java.util.*;
import Classes.*;

public class ExtractQuery
{
	private TrectextCollection trectextCol;
	private Map<String,String> nextMap;

	public ExtractQuery() throws Exception
	{
		//you should extract the 4 queries from the Path.TopicDir
		//NT: the query content of each topic should be 1) tokenized, 2) to lowercase, 3) remove stop words, 4) stemming
		//NT: you can simply pick up title only for query, or you can also use title + description + narrative for the query content.

		trectextCol = new TrectextCollection(Path.TopicDir);
	}//end constructor

	public static String PreProcess(String title) throws Exception
	{
		String result="";
		StopWordRemover stopwordRemover = new StopWordRemover();
		WordNormalizer normalizer = new WordNormalizer();
		WordTokenizer tokenizer = new WordTokenizer(title);

		String word = null;
		// process word by word iteratively
		while ((word = tokenizer.nextWord()) != null)
		{
			// each word is transformed into lowercase
			word = normalizer.lowercase(word);

			// filter out stopword, and only non-stopword will be written into result file
			// stemmed format of each word is written into result file
			if (!stopwordRemover.isStopword(word))
				result += (normalizer.stem(word) + " ");
		}//end while loop

		return result;
	}//end PreProcess
	
	public boolean hasNext() throws Exception
	{
		nextMap = trectextCol.nextDocument();
		if (nextMap == null)
			return false;
		else
			return true;
	}//end hasNext

	public Query next() throws Exception
	{
		Query nextQuery = new Query();
		String key = nextMap.keySet().iterator().next();
		String value = nextMap.get(key);
		nextQuery.SetTopicId(key);
		nextQuery.SetQueryContent(PreProcess(value));
		return nextQuery;
	}//end next

	public static void main(String[] args) throws Exception
	{
		String title = "Homosexual acceptance Europe";
		String processed = PreProcess(title);
		System.out.println(processed);
	}//end main

}//end class ExtractQuery