package com.maknaez.controller.admin;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.OrderMapper;
import com.maknaez.model.OrderDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.mybatis.support.MapperContainer;
import com.maknaez.util.MyUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/admin/order/*")
public class orderManageController {

	@GetMapping("order_list")
	public ModelAndView orderList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/order/order_list");

		return mav;
	}

	@GetMapping("claim_list")
	public ModelAndView claimList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/order/claim_list");
		
		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		MyUtil util = new MyUtil(); 
		
		try {
			String page = req.getParameter("page");
			int current_page = 1;
			if(page != null && !page.equals("")) {
				current_page = Integer.parseInt(page);
			}
			
			String searchKey = req.getParameter("searchKey");
			String searchValue = req.getParameter("searchValue");
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("mode", "claim"); 
			
			if(searchValue != null && !searchValue.equals("")) {
				map.put("searchKey", searchKey);
				map.put("searchValue", searchValue);
			}
			
			int dataCount = mapper.dataCount(map);
			
			int size = 10;
			int total_page = util.pageCount(dataCount, size);
			if(current_page > total_page) current_page = total_page;
			
			int start = (current_page - 1) * size + 1;
			int end = current_page * size;
			map.put("start", start);
			map.put("end", end);
			
			List<OrderDTO> list = mapper.listOrder(map);
			
			String cp = req.getContextPath();
			String listUrl = cp + "/admin/order/claim_list";
			
			if(searchValue != null && !searchValue.equals("")) {
				listUrl += "?searchKey=" + searchKey + "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8");
			}
			
			String paging = util.paging(current_page, total_page, listUrl);
			
			mav.addObject("list", list);
			mav.addObject("page", current_page);
			mav.addObject("dataCount", dataCount);
			mav.addObject("total_page", total_page);
			mav.addObject("paging", paging);
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	@GetMapping("estimate_list")
	public ModelAndView estimateList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/order/estimate_list");

		return mav;
	}

	@GetMapping("approve")
	public ModelAndView approve(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		try {
			OrderMapper mapper = MapperContainer.get(OrderMapper.class);

			String orderNum = req.getParameter("orderNum");
			String claimType = req.getParameter("claimType");
			String productNum = req.getParameter("productNum");
			String pdSize = req.getParameter("pdSize");
			String qtyStr = req.getParameter("qty");
			int qty = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 0;

			Map<String, Object> map = new HashMap<String, Object>();
			map.put("orderNum", orderNum);
			map.put("productNum", productNum);
			map.put("pdSize", pdSize);
			map.put("qty", qty);
			

			if ("취소".equals(claimType)) {
				map.put("status", "취소완료");
			} else {
				map.put("status", "반품완료");
			}

			mapper.updateOrderState(map);
			mapper.updateStockIncrease(map);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return new ModelAndView("redirect:/admin/order/claim_list");
	}
}
