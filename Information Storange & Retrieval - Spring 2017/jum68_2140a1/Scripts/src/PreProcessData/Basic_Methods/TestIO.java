package PreProcessData.Basic_Methods;

import java.io.*;

class TestIO
{
	public static void Test_FileReader() throws Exception
	{
		FileReader reader = new FileReader("reader.trectext");
		int charNumber;
		
		//get single characters
		while ((charNumber=reader.read())!=-1)
		{
			System.out.println((char)charNumber);
		}//end while

		reader.close();
	}//end main

	public static void Test_FileWriter() throws Exception
	{
		FileWriter writer = new FileWriter("writer.trectext");
		String str1 = "Test_FileWriter line1";
		writer.write(str1+"\r\n");  //writting a line
		String str2 = "Test_FileWriter line2";
		writer.write(str2+"\r\n");
		writer.close(); //close writer
	}//end Test_FileWriter()

	public static void Test_readLine() throws Exception
	{
		FileReader reader = new FileReader("reader.trectext");
		BufferedReader br = new BufferedReader(reader);
		FileWriter writer = new FileWriter("LineWriter.trectext");
		BufferedWriter bw = new BufferedWriter(writer);

		String str;
		while ((str = br.readLine()) != null) 
		{
			bw.write(str);
			bw.newLine(); //enter a new line
		}//end while loop

		br.close();              
		bw.close();
	}//end Test_readLine

	public static void Test_capture(int startIndex, int endIndex) throws Exception
	{	//[startIndex, endIndex]
		FileReader reader = new FileReader("docset.trectext");
		BufferedReader br = new BufferedReader(reader);
		FileWriter writer = new FileWriter("captured.trectext");
		BufferedWriter bw = new BufferedWriter(writer);

		br.skip(startIndex);
		int index=startIndex;
		int ch;

		while (index <= endIndex+1 && (ch=br.read())!=-1) 
		{
			bw.write((char)ch);
			index++;
		}//end while loop

		br.close();              
		bw.close();
	}//end Test_capture

	public static void main(String[] args) throws Exception
	{
		//Test_FileReader();
		//Test_FileWriter();
		//Test_LineNumberReader();
		//Test_readLine();
		Test_capture(10, 200);
	}//end main
}//end class TestFileReader