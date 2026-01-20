package com.maknaez.controller.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.maknaez.mapper.OrderMapper;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.mybatis.support.MapperContainer;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class HomeManageController {
	@RequestMapping("/admin")
	public ModelAndView adminMain(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/home/main");
		
		return mav;
	}
	
	@GetMapping("checkAlarmCount")
	public void checkAlarmCount(HttpServletRequest req, HttpServletResponse resp) {
	    OrderMapper mapper = MapperContainer.get(OrderMapper.class);
	    resp.setContentType("application/json; charset=UTF-8");
	    
	    try {
	        Map<String, Object> map = new HashMap<>();
	        map.put("orderState", "결제완료");
	        int newOrderCount = mapper.dataCount(map);
	        
	        String json = "{\"newOrderCount\":" + newOrderCount + "}";
	        resp.getWriter().print(json);
	        resp.getWriter().flush();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
}