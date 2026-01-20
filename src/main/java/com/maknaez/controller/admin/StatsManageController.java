package com.maknaez.controller.admin;

import java.io.IOException;
import java.util.Map;

import org.json.JSONObject;

import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.StatsService;
import com.maknaez.service.StatsServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/admin/stats/*")
public class StatsManageController {
	StatsService service = new StatsServiceImpl();
	
	@GetMapping("sales_stats")
    public ModelAndView salesStats(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ModelAndView mav = new ModelAndView("admin/stats/sales_stats");
        return mav;
    }
    
    @GetMapping("sales_api")
    @ResponseBody 
    public void salesApi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	try {
            Map<String, Object> stats = service.getSalesStats();
            
            JSONObject json = new JSONObject(stats);
            
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace(); 
        }
    }
	
	@GetMapping("product_stats")
	public ModelAndView productStats(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/stats/product_stats");
		
		return mav;
	}
	
	@GetMapping("product_stats_api")
    @ResponseBody
    public void productStatsApi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Map<String, Object> data = service.getProductStats();
            
            JSONObject json = new JSONObject(data);
            
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
	
	@GetMapping("customer_stats")
	public ModelAndView customerStats(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/stats/customer_stats");
		
		return mav;
	}
	
	@GetMapping("customer_stats_api")
    @ResponseBody
    public void customerStatsApi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Map<String, Object> data = service.getCustomerStats();
            JSONObject json = new JSONObject(data);
            
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
	
	@GetMapping("visitor_stats")
	public ModelAndView visitorStats(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/stats/visitor_stats");
		
		return mav;
	}
	
	@GetMapping("visitor_stats_api")
    @ResponseBody
    public void visitorStatsApi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String mode = req.getParameter("mode");
            if(mode == null || mode.isEmpty()) {
                mode = "daily";
            }

            Map<String, Object> data = service.getVisitorStats(mode);
            JSONObject json = new JSONObject(data);

            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
