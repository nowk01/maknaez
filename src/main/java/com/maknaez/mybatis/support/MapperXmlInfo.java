package com.maknaez.mybatis.support;

public class MapperXmlInfo {
	private final String namespace;
	private final String xmlPath;

	public MapperXmlInfo(String namespace, String xmlPath) {
		this.namespace = namespace;
		this.xmlPath = xmlPath;
	}

	public String getNamespace() {
		return namespace;
	}

	public String getXmlPath() {
		return xmlPath;
	}
}
