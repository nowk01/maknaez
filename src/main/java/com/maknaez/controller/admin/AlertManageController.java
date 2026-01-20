//package com.maknaez.controller.admin;
//
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.Map;
//
//import com.maknaez.mapper.AlertMapper;
//import com.maknaez.mvc.annotation.Controller;
//import com.maknaez.mvc.annotation.GetMapping;
//import com.maknaez.mvc.annotation.RequestMapping;
//import com.maknaez.mybatis.support.MapperContainer;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//@Controller
//@RequestMapping("/admin/alert")
//public class AlertManageController {
//	@GetMapping("list")
//	public String list(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//
//		try {
//			AlertMapper mapper = MapperContainer.get(AlertMapper.class);
//
//			List<Map<String, Object>> orders = mapper.listNewOrders();
//			List<Map<String, Object>> inquiries = mapper.listNewInquiries();
//
//			// 1. 일단 리스트 하나로 합치기
//			List<Map<String, Object>> allAlerts = new ArrayList<>();
//			if (orders != null)
//				allAlerts.addAll(orders);
//			if (inquiries != null)
//				allAlerts.addAll(inquiries);
//
//			int size = allAlerts.size();
//
//			for (int i = 0; i < size - 1; i++) {
//				for (int j = 0; j < size - 1 - i; j++) {
//
//					Map<String, Object> map1 = allAlerts.get(j);
//					Map<String, Object> map2 = allAlerts.get(j + 1);
//
//					String date1 = String.valueOf(map1.get("REG_DATE"));
//					String date2 = String.valueOf(map2.get("REG_DATE"));
//
//					if (date1.compareTo(date2) < 0) {
//						allAlerts.set(j, map2);
//						allAlerts.set(j + 1, map1);
//					}
//				}
//			}
//
//			req.setAttribute("list", allAlerts);
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//
//		return "admin/alert/list";
//	}
//}