package PseudoRFSearch;

import java.util.*;
import Classes.*;
import java.io.*;
import java.util.Map.Entry;
import IndexingLucene.MyIndexReader;
import Search.QueryRetrievalModel;

public class PseudoRFRetrievalModel
{
	protected MyIndexReader indexReader;
    private Map<Integer, Integer> doc_freq;	//<docid, total counts of words>
    private Map<Integer, Double> score_map;	//<docid, score>

	MyIndexReader ixreader;
	
	public PseudoRFRetrievalModel(MyIndexReader ixreader)
	{
		this.ixreader=ixreader;
	}//end constructor
	
	/**
	 * Search for the topic with pseudo relevance feedback in 2017 spring assignment 4. 
	 * The returned results (retrieved documents) should be ranked by the score (from the most relevant to the least).
	 * 
	 * @param aQuery The query to be searched for.
	 * @param TopN The maximum number of returned document
	 * @param TopK The count of feedback documents
	 * @param alpha parameter of relevance feedback model
	 * @return TopN most relevant document, in List structure
	 */
	public List<Document> RetrieveQuery( Query aQuery, int TopN, int TopK, double alpha) throws Exception
	{	
		// this method will return the retrieval result of the given Query, and this result is enhanced with pseudo relevance feedback
		// (1) you should first use the original retrieval model to get TopK documents, which will be regarded as feedback documents
		// (2) implement GetTokenRFScore to get each query token's P(token|feedback model) in feedback documents
		// (3) implement the relevance feedback model for each token: combine the each query token's original retrieval score P(token|document) with its score in feedback documents P(token|feedback model)
		// (4) for each document, use the query likelihood language model to get the whole query's new score, P(Q|document)=P(token_1|document')*P(token_2|document')*...*P(token_n|document')
		
		//get listTopK
		List<Document> all = new ArrayList<Document>();
        Map<Integer, Double> originalMap = GetTokenRFScore(aQuery);
        for (Entry<Integer, Double> entry : originalMap.entrySet())
        	all.add(new Document(entry.getKey() + "", ixreader.getDocno(entry.getKey()), entry.getValue()));
		List<Document> listTopK = all.subList(0, TopK);

		//get PFB = P(aQuery|feedback docments)
		double PFB = 0;
		int[] docLengths = getDocLengths(listTopK,TopK);
		double[] docScores = getDocScores(listTopK,TopK);
		for (int i=0; i<TopK; i++)
			PFB += docScores[i]*docLengths[i]/docLengths[TopK];

		//get new score
		double[] docNewScores = new double[TopK];
		for (int i=0; i<TopK; i++)
			docNewScores[i] = alpha*docScores[i] + (1-alpha)*PFB;

		//get newListTopK
		List<Document> newListTopK = new ArrayList<Document>();
		for (int i=0; i<TopK; i++)
		{
			Document docI = listTopK.get(i);
			Document nextDoc = new Document(docI.docid(),docI.docno(),docNewScores[i]);
			newListTopK.add(nextDoc);
		}//end for loop i

		//sort newListTopK, and return TopN
		listSort.bubbleSort(newListTopK);
		List<Document> results = newListTopK.subList(0,TopN);
		return results;
	}//end RetrieveQuery
	
	public Map<Integer, Double> GetTokenRFScore(Query aQuery) throws Exception
	{
		// for each document in the collection, calculate document's score: P(aQuery|document)
		// use Dirichlet smoothing
		// save <docid, score> in HashMap docScore, and return it

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
        	long ctf = ixreader.CollectionFreq(token);
    		int[][] posting = ixreader.getPostingList("singapor");

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

        Map<Integer, Double> sortedmap = sortByValues(score_map);  
        return sortedmap;
	}//end GetTokenRFScore

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

	public int length(String docno) throws Exception
	{
		FileReader fr = new FileReader(Path.ResultHM1 + "trectext");
		BufferedReader br = new BufferedReader(fr);

		String nextLine = null;;
		while ((nextLine=br.readLine().trim())!=null)
		{
			 if (nextLine.equals(docno))
			 {
				 String content = br.readLine().trim();
				 String[] strArr = content.split(" ");
				 br.close();
				 fr.close();
				 return strArr.length;
			 }//end if
		}//end while loop

		br.close();
		fr.close();
		return -1;
	}//end length

	public int[] getDocLengths (List<Document> listTopK, int TopK) throws Exception
	{
		int[] result = new int[TopK+1];
		int totLength=0;
		for (int i=0; i<TopK; i++)
		{
			String docno = listTopK.get(i).docno();
			result[i] = length(docno);
			totLength += result[i];
		}//end for loop i
		result[TopK] = totLength;
		return result;
	}//end getDocLengths

	public double[] getDocScores (List<Document> listTopK, int TopK)
	{
		double[] result = new double[TopK];
		for (int i=0; i<TopK; i++)
		{
			double docscore = listTopK.get(i).score();
			result[i] = docscore;
		}//end for loop i
		return result;
	}//end getDocScores

}//end class PseudoRFSearch