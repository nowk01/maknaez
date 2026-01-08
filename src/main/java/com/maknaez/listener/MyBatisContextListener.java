package com.maknaez.listener;

import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.maknaez.mybatis.support.MapperAutoLoader;
import com.maknaez.mybatis.support.SqlSessionManager;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class MyBatisContextListener implements ServletContextListener {
	private static final String CONFIG_FILENAME = "mybatis/mybatis-config.xml";
	private static final String MAPPER_PATH = "mybatis/mapper";
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		try {
			InputStream is = Resources.getResourceAsStream(CONFIG_FILENAME);

			SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(is);

			SqlSessionManager.init(factory);

			MapperAutoLoader.loadAll(factory, MAPPER_PATH);

		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

}
