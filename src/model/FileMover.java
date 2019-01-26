package model;

import java.io.File;
import java.io.IOException;
import org.apache.commons.io.FileUtils;

public class FileMover {
	public static void deleteDirectories(String cachePath, String seriesPath) {
		File enbcache = new File(cachePath);
		File enbseries = new File(seriesPath);
		try {
			FileUtils.deleteDirectory(enbcache);
			FileUtils.deleteDirectory(enbseries);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static void deleteBaseFiles(File directory) {
		for (File f : directory.listFiles()) {
			if (f.getName().startsWith("enb") || f.getName().startsWith("d3d11")
					|| f.getName().startsWith("d3dcompiler_46e")) {
				f.delete();
			}
		}
	}

	public static void copy(String sourceFile, String targetFile) {
		File source = new File(sourceFile);
		File dest = new File(targetFile);
		try {
			if (source.isDirectory()) {
				FileUtils.copyDirectory(source, dest);
			} else {
				FileUtils.copyFile(source, dest);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
