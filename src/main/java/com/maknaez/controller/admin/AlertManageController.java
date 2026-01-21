package com.maknaez.controller.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.AlertMapper;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mybatis.support.MapperContainer;
import com.maknaez.service.AlertService;
import com.maknaez.service.AlertServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/alert")
public class AlertManageController {
	private AlertService service = new AlertServiceImpl();

	@GetMapping("list")
	public String list(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setAttribute("list", getAlertList(req.getSession()));
		return "admin/alert/list";
	}

	@GetMapping("history")
	public String history(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setAttribute("list", getAlertList(req.getSession()));
		return "admin/alert/history";
	}

	@SuppressWarnings("unchecked")
	private List<Map<String, Object>> getAlertList(HttpSession session) {
	    List<Map<String, Object>> allAlerts = new ArrayList<>();
	    try {
	        AlertMapper mapper = MapperContainer.get(AlertMapper.class);
	        List<Map<String, Object>> orders = mapper.listNewOrders();
	        List<Map<String, Object>> inquiries = mapper.listNewInquiries();

	        if (orders != null) allAlerts.addAll(orders);
	        if (inquiries != null) allAlerts.addAll(inquiries);

	        List<String> readList = (List<String>) session.getAttribute("READ_ALERTS");
	        
	        if (readList != null && !readList.isEmpty()) {
	            allAlerts.removeIf(map -> {
	                String currentId = String.valueOf(map.get("ID"));
	                return readList.contains(currentId);
	            });
	        }

	        allAlerts.sort((m1, m2) -> String.valueOf(m2.get("REG_DATE")).compareTo(String.valueOf(m1.get("REG_DATE"))));
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return allAlerts;
	}

	@SuppressWarnings("unchecked")
	@PostMapping("read")
	@ResponseBody
	public Map<String, Object> read(HttpServletRequest req) {
		Map<String, Object> model = new HashMap<>();
		try {
			String alertIdx = req.getParameter("alertIdx");
			HttpSession session = req.getSession();
			
			if (alertIdx != null && !alertIdx.isEmpty()) {
				List<String> readList = (List<String>) session.getAttribute("READ_ALERTS");
				if (readList == null) {
					readList = new ArrayList<>();
				}
				
				if (!readList.contains(alertIdx)) {
					readList.add(alertIdx);
				}
				session.setAttribute("READ_ALERTS", readList);
				
				try {
					service.updateRead(Integer.parseInt(alertIdx));
				} catch(Exception e) {}

				model.put("state", "true");
			} else {
				model.put("state", "false");
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.put("state", "false");
		}
		return model;
	}

	@SuppressWarnings("unchecked")
	@PostMapping("readAll")
	@ResponseBody
	public Map<String, Object> readAll(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		Map<String, Object> model = new HashMap<>();
		try {
			HttpSession session = req.getSession();
			List<Map<String, Object>> currentList = getAlertList(session);
			List<String> readList = (List<String>) session.getAttribute("READ_ALERTS");
			if (readList == null) readList = new ArrayList<>();
			
			for(Map<String, Object> alert : currentList) {
				readList.add(String.valueOf(alert.get("ID")));
			}
			session.setAttribute("READ_ALERTS", readList);
			
			model.put("state", "true");
		} catch (Exception e) {
			e.printStackTrace();
			model.put("state", "false");
		}
		return model;
	}
}