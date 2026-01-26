package com.maknaez.mybatis.support;

import java.io.InputStream;
import java.util.List;

import org.apache.ibatis.builder.xml.XMLMapperBuilder;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.Configuration;
import org.apache.ibatis.session.SqlSessionFactory;

public class MapperAutoLoader {
	public static void loadAll(SqlSessionFactory factory, String mapperBasePath) {

		Configuration config = factory.getConfiguration();

		List<MapperXmlInfo> xmlInfos = MapperXmlScanner.scan(mapperBasePath);

		for (MapperXmlInfo info : xmlInfos) {
			try {
				Class<?> mapperClass = Class.forName(info.getNamespace());

				if (! config.hasMapper(mapperClass)) {
					config.addMapper(mapperClass);
				}

				InputStream xml = Resources.getResourceAsStream(info.getXmlPath());

				new XMLMapperBuilder(xml, config, info.getXmlPath(), config.getSqlFragments()).parse();

				// ThreadLocal 대응 Mapper 등록
				MapperContainer.register(mapperClass);

			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}
}
