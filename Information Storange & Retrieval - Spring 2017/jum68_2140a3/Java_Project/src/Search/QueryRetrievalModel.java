package Search;

import java.io.*;
import java.util.*;
import java.util.Map.Entry;

import Classes.*;
import IndexingLucene.MyIndexReader;

public class QueryRetrievalModel
{
	protected MyIndexReader indexReader;
	
    private Map<Integer, Integer> doc_freq;	//<docid, total counts of words>
    private Map<Integer, Double> score_map;	//<docid, score>
	
	public QueryRetrievalModel(MyIndexReader ixreader) throws IOException
	{
		indexReader = new MyIndexReader("trectext");
	}//end constructor
	
	/**
	 * Search for the topic's relevant documents. 
	 * The returned results (retrieved documents) should be ranked by the score (from the most relevant to the least).
	 * TopN specifies the maximum number of results to be returned.
	 * 
	 * @param aQuery The query to be searched for.
	 * @param TopN The maximum number of returned document
	 * @return
	 */
	
	public List<Document> retrieveQuery( Query aQuery, int TopN ) throws IOException
	{
		// NT: you will find our IndexingLucene.Myindexreader provides method: docLength()
		// implement your retrieval model here, and for each input query, return the topN retrieved documents
		// sort the docs based on their relevance score, from high to low

		doc_freq = new HashMap<Integer, Integer>();
		int totalnum = 0;
		int count = 1;
		  
        try
		{  
    		FileReader fr = new FileReader(Path.ResultHM1 + "trectext");
            BufferedReader br = new BufferedReader(fr);  
              
            String temp = null;
    		String docno = null;
    		String content = null;
            int docid = 1;

            while ((temp = br.readLine()) != null)
			{  
    			docno = temp;
    			temp = br.readLine();
    			content = temp;
                int num = content.length();
                doc_freq.put(docid,num);
    		    totalnum = totalnum + num;
                docid++;
                count++;
            }//end while loop
            
            br.close();  
            fr.close();  
        } catch (IOException e) 
		{ System.out.println("error");}  
                
        String Qu = aQuery.GetQueryContent();
        String[] Que = Qu.split(" ");
    	score_map = new HashMap<Integer, Double>();
    	
        for(int j=0; j< Que.length; j++)
		{
        	String token = Que[j];
        	long ctf = indexReader.CollectionFreq(token);
    		int[][] posting = indexReader.getPostingList("singapor");

    		for(int ix=0;ix<posting.length;ix++)
			{
    			int docid1 = posting[ix][0];
    			int freq = posting[ix][1];

    			double q = ((double)ctf)/totalnum;      	
            	double score = ((double)(freq+2000*q))/(2000+doc_freq.get(docid1));

		        if(!score_map.containsKey(docid1))
		        	score_map.put(docid1, score);
		        else
				{
		        	double score1 = score_map.get(docid1);
		        	score_map.put(docid1, score1+score);
		        }//end else
    		}//end for loop ix
        }//end for loop j

		List<Document> results = new ArrayList<Document>();
        Map<Integer, Double> sortedmap = sortByValues(score_map);  
        
        for (Entry<Integer, Double> entry : sortedmap.entrySet())        	
        	results.add(new Document(entry.getKey() + "", indexReader.getDocno(entry.getKey()), entry.getValue()));

		return results.subList(0, TopN);
	}//retrieveQuery
	
	public static <K, V extends Comparable<V>> Map<K, V> sortByValues(final Map<K, V> map)
	{  
        Comparator<K> valueComparator = new Comparator<K>()
		{  
            public int compare(K k1, K k2)
			{  
                int compare = map.get(k2).compareTo(map.get(k1));  
                if (compare == 0)  
                    return 1;  
                else  
                    return compare;  
            }//end compare
        };
        Map<K, V> sortedByValues = new TreeMap<K, V>(valueComparator);  
        sortedByValues.putAll(map);  
        return sortedByValues;  
    }//end sortByValues
}//end class QueryRetrievalModel