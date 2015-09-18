package br.com.auster.nextel.xsl.extensions;

import java.io.File;
import java.util.Map;

import br.com.auster.dware.filter.OutputToFile;
import br.com.auster.dware.graph.Request;

public class BGHUtils {
	
	public static String getFilename(Request request, String formatName) {
		final String path = getAbsolutePath(request, formatName);
		return path.substring(path.lastIndexOf(File.separatorChar) + 1);
	}
	
	public static String getFilenameNoExt(Request request, String formatName) {
		final String filename = getFilename(request, formatName);
		return filename.substring(0, filename.lastIndexOf('.'));
	}
	
	public static String getDirectory(Request request, String formatName) {
		final String path = getAbsolutePath(request, formatName);
		final int sepIndex = path.lastIndexOf(File.separatorChar);
		if (sepIndex < 0) {
			return "";
		}
		return path.substring(0, sepIndex + 1);
	}
	
	public static String getAbsolutePath(Request request, String formatName) {
		final Map files = (Map) 
			request.getAttributes().get(OutputToFile.GENERATED_FILES_KEY);
		if (files == null) {
			return "";
		}
		final String file = (String) files.get(formatName);
		if (file == null) {
			return "";
		}
		return file;
	}

}
