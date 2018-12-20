package Indexing;

import java.io.*;

class FileOperation
{
	public static void deleteFile (String path)
	{
		File f = new File(path);
		if (f.isFile() && f.exists())
		{
			System.gc();
			f.delete();
		} else
			System.out.println("file does not exist!");
	}//end deleteFile

	public static void renameFile (String oldPath, String newPath)
	{
		File f = new File(oldPath);
		if (f.isFile() && f.exists())
		{
			System.gc();
			f.renameTo(new File(newPath));
		} else
			System.out.println("file does not exist!");
	}//end renameFile

	public static void main (String[] args)
	{
/*
		String path_relative = "../FileTest/zdelete_relative.txt";
		deleteFile(path_relative);
		String path_currentFolder = "zdelete_currentFolder.txt";
		deleteFile(path_currentFolder);
		String path_absolute = "F:/¿Î¼þ/Ë¶Ê¿/¡¾Spring 2017¡¿/IS2140 - Information Storage and Retrieval/Homework/HW2/Assignment2/src/Indexing/FileTest/zdelete_absolute.txt";
		deleteFile(path_absolute);
*/
		String path_relative = "../FileTest/zdelete_relative.txt";
		String newPath = "../FileTest/zdelete_relative_new.txt";
		renameFile(path_relative,newPath);
	}//end main
}//end class FileOperation