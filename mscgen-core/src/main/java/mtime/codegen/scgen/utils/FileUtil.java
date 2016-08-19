package mtime.codegen.scgen.utils;

import java.io.File;

public class FileUtil {	

	public static void mkdir(String dir) {
		File file = new File(dir);
		mkdir(file);
	}

	public static void mkdir(File file) {
		if (file.exists()) {
			return;
		}
		File pFile = file.getParentFile();
		if (pFile != null) {
			mkdir(pFile);
		}
		//
		file.mkdir();
	}

	public static String appendSeparator(String path) {
		if (!path.endsWith(File.separator)) {
			path += File.separator;
		}
		return path;
	}

	public static String combinePath(String path1, String path2) {
		
		if(path1.endsWith(File.separator) && path2.startsWith(File.separator)){
			return path1 + path2.substring(1);
		}
		if(path1.endsWith(File.separator) || path2.startsWith(File.separator)){
			return path1 + path2;
		}
		return path1 + File.separator + path2;
	}
}
