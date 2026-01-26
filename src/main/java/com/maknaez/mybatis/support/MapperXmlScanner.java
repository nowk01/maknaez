package com.maknaez.mybatis.support;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.ibatis.io.Resources;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class MapperXmlScanner {
	/**
	 * mapper 디렉토리 하위 XML 모두 스캔
	 */
	public static List<MapperXmlInfo> scan(String basePath) {
		List<MapperXmlInfo> result = new ArrayList<>();

		try {
			var urls = Thread.currentThread().getContextClassLoader().getResources(basePath);

			while (urls.hasMoreElements()) {
				var url = urls.nextElement();
				var dir = new java.io.File(url.toURI());

				for (var file : dir.listFiles(f -> f.getName().endsWith(".xml"))) {
					try (InputStream is = Resources.getResourceAsStream(basePath + "/" + file.getName())) {

						Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(is);

						Element mapper = (Element) doc.getElementsByTagName("mapper").item(0);

						String namespace = mapper.getAttribute("namespace");
						if(namespace.equalsIgnoreCase("temp")) {
							continue;
						}
						
						result.add(new MapperXmlInfo(namespace, basePath + "/" + file.getName()));
					}
				}
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return result;
	}
}
