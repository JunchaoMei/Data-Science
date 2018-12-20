package PreProcessData;

import java.io.*;
import java.util.*;
import Classes.Path;
import java.util.regex.*; 

/**
 * This is for INFSCI 2140 in 2017 
 *
 */

public class TrecwebCollection implements DocumentCollection
{
	//you can add essential private methods or variables
	private HashSet<String> keyUsed = new HashSet<String>();
	private String fileName;
	private int start=0;

	// YOU SHOULD IMPLEMENT THIS METHOD
	public TrecwebCollection() throws IOException
	{
		// This constructor should open the file in Path.DataWebDir
		// and also should make preparation for function nextDocument()
		// you cannot load the whole corpus into memory here!!

		fileName = Path.DataWebDir;
	}//end constructor

	public char charAt(String file, int index) throws Exception
	{
		file = fileName;
		FileReader reader = new FileReader(file);
		BufferedReader br = new BufferedReader(reader);
		br.skip(index);
		char ch = (char)br.read();
		br.close();
		return ch;
	}//end charAt
 
 	public int fileSearch(String pat, String file, int startPoint) throws Exception
	{	//[startPoint, the_end]
		file = fileName;
		FileReader readerI = new FileReader(file);
		BufferedReader brI = new BufferedReader(readerI);
		int i=startPoint;
		int chI;
        int M = pat.length();
 
		while ((chI=brI.read())!=-1)
		{ 
            int j;

            for (j = 0; j < M; j++)
			{
                if (charAt(file,i+j) != pat.charAt(j))
                    break;
            }//end for loop j
 
            //found 
            if (j == M)
			{
				brI.close();
                return i;
			}//end if

			i++;
        }//end for loop i
		brI.close();
        return -1;
	}//end fileSearch

	public String capture(int startIndex, int endIndex) throws Exception
	{	//[startIndex, endIndex]
		FileReader reader = new FileReader(fileName);
		BufferedReader br = new BufferedReader(reader);
		String captured="";

		br.skip(startIndex);
		int index=startIndex;
		int ch;

		while (index <= endIndex+1 && (ch=br.read())!=-1)
		{
			captured += (char)ch;
			index++;
		}//end while loop

		br.close();
		return captured;
	}//end Test_capture

	public String removeTags(String text)
	{
        String regEx_script="<script[^>]*?>[\\s\\S]*?<\\/script>"; //定义script的正则表达式 
        String regEx_style="<style[^>]*?>[\\s\\S]*?<\\/style>"; //定义style的正则表达式 
        String regEx_html="<[^>]+>"; //define the Regular Expression of html tags
        String htmlStr = text;

        Pattern p_script=Pattern.compile(regEx_script,Pattern.CASE_INSENSITIVE); 
        Matcher m_script=p_script.matcher(htmlStr); 
        htmlStr=m_script.replaceAll(""); //filter script tags 
         
        Pattern p_style=Pattern.compile(regEx_style,Pattern.CASE_INSENSITIVE); 
        Matcher m_style=p_style.matcher(htmlStr); 
        htmlStr=m_style.replaceAll(""); //filter style tags
         
        Pattern p_html=Pattern.compile(regEx_html,Pattern.CASE_INSENSITIVE); 
        Matcher m_html=p_html.matcher(htmlStr); 
        htmlStr=m_html.replaceAll(""); //filter html tags 

        return htmlStr.trim(); //返回文本字符串 
/*
		String content = text;
		// <p> -> new line
		content = content.replaceAll("<p.*?>", "\r\n"); 
		// <br><br/> -> new line
		content = content.replaceAll("<br\\s*//*?>", "\r\n"); 
		// remove <*****>
		content = content.replaceAll("\\<.*?>", ""); 
		// return html
		// content = HTMLDecoder.decode(content); 
		return content;
*/
	}//end removeTags

	// YOU SHOULD IMPLEMENT THIS METHOD
	public Map<String, String> nextDocument() throws Exception 
	{
		// this method should load one document from the corpus, and return this document's number and content.
		// the returned document should never be returned again.
		// when no document left, return null
		// NT: the returned content of the document should be cleaned, all html tags should be removed.
		// NTT: remember to close the file that you opened, when you do not use it any more
		
		Map<String, String> map = new HashMap<String, String>();
		int startDocument = fileSearch("<DOC>",fileName,start);
		if (startDocument==-1)
		{
			return null;
		} else
		{
			int startDocNO = fileSearch("<DOCNO>",fileName,startDocument)+7;
			int endDocNO = fileSearch("</DOCNO>",fileName,startDocNO)-2;
			String key = capture(startDocNO,endDocNO).trim();

			int startContent = fileSearch("<DOCHDR>",fileName,startDocument)+8;
			int endContent = fileSearch("</DOC>",fileName,startContent)-2;
			String text = capture(startContent,endContent).trim();
			String value = removeTags(text);

			int endDocument = endContent;
			start = endDocument+3;
			keyUsed.add(key);
			map.put(key,value);
			return map;
		}//end else
	}//end nextDocument
}//end class TrecwebCollection