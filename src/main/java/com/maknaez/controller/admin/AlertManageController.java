package com.maknaez.controller.admin;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.maknaez.mapper.AlertMapper;
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mybatis.support.MapperContainer;
import com.maknaez.service.AlertService;
import com.maknaez.service.AlertServiceImpl;

@Controller
@RequestMapping("/admin/alert")
public class AlertManageController {
	private AlertService service = new AlertServiceImpl();

	@GetMapping("list")
	public String list(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setAttribute("list", getAlertList());
		return "admin/alert/list";
	}

	@GetMapping("history")
	public String history(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setAttribute("list", getAlertList());
		return "admin/alert/history";
	}

	private List<Map<String, Object>> getAlertList() {
		List<Map<String, Object>> allAlerts = new ArrayList<>();
		try {
			AlertMapper mapper = MapperContainer.get(AlertMapper.class);

			List<Map<String, Object>> orders = mapper.listNewOrders();
			List<Map<String, Object>> inquiries = mapper.listNewInquiries();

			if (orders != null)
				allAlerts.addAll(orders);
			if (inquiries != null)
				allAlerts.addAll(inquiries);

			int size = allAlerts.size();
			for (int i = 0; i < size - 1; i++) {
				for (int j = 0; j < size - 1 - i; j++) {
					Map<String, Object> map1 = allAlerts.get(j);
					Map<String, Object> map2 = allAlerts.get(j + 1);

					String date1 = String.valueOf(map1.get("REG_DATE"));
					String date2 = String.valueOf(map2.get("REG_DATE"));

					if (date1.compareTo(date2) < 0) {
						allAlerts.set(j, map2);
						allAlerts.set(j + 1, map1);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return allAlerts;
	}

	@PostMapping("readAll")
	@ResponseBody
	public Map<String, Object> readAll(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		Map<String, Object> model = new HashMap<>();
		try {
			HttpSession session = req.getSession();
			SessionInfo info = (SessionInfo) session.getAttribute("member");

			if (info != null) {
				service.updateReadAll(info.getMemberIdx());
				model.put("state", "true");
			}
		} catch (Exception e) {
			e.printStackTrace();
			model.put("state", "false");
		}
		return model;
	}

	@PostMapping("read")
	@ResponseBody
	public Map<String, Object> read(HttpServletRequest req) {
	    Map<String, Object> model = new HashMap<>();
	    try {
	        String strIdx = req.getParameter("alertIdx");
	        
	        if (strIdx != null && !strIdx.isEmpty()) {
	            int alertIdx = Integer.parseInt(strIdx);
	            
	            service.updateRead(alertIdx);
	            
	            model.put("state", "true");
	            System.out.println("알림 읽음 처리 성공: " + alertIdx);
	        } else {
	            model.put("state", "false");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        model.put("state", "false");
	    }
	    return model;
	}
}