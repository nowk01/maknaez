 package com.maknaez.controller.admin;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.maknaez.model.MemberDTO;
import com.maknaez.model.PointDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.MemberService;
import com.maknaez.service.MemberServiceImpl;
import com.maknaez.service.PointService;
import com.maknaez.service.PointServiceImpl;
import com.maknaez.util.MyUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/member/*")
public class MemberManageController {
	private MemberService service = new MemberServiceImpl();
	private PointService pointService = new PointServiceImpl();
	private MyUtil util = new MyUtil();
	
	@GetMapping("member_list")
	public ModelAndView memberList(HttpServletRequest req, HttpServletResponse resp) throws Exception {
	    
	    String page = req.getParameter("page");
	    int current_page = 1;
	    if(page != null && !page.equals("")) {
	        try {
	            current_page = Integer.parseInt(page);
	        } catch(Exception e) { }
	    }
	    
	    String searchKey = req.getParameter("searchKey");
	    String searchValue = req.getParameter("searchValue");
	    String startDate = req.getParameter("startDate");
	    String endDate = req.getParameter("endDate");
	    String userLevel = req.getParameter("userLevel");

	    if(searchKey == null) searchKey = "all";
	    if(searchValue == null) searchValue = "";
	    if(userLevel == null) userLevel = "전체 등급"; 

	    Map<String, Object> map = new HashMap<>();
	    map.put("searchKey", searchKey);
	    map.put("searchValue", searchValue);
	    map.put("startDate", startDate);
	    map.put("endDate", endDate);
	    map.put("userLevel", userLevel);

	    int dataCount = service.dataCount(map);
	    
	    int size = 10;
	    int total_page = util.pageCount(dataCount, size);
	    
	    if(current_page > total_page) {
	        current_page = total_page;
	    }
	    
	    int offset = (current_page - 1) * size; 
	    if(offset < 0) offset = 0;

	    map.put("offset", offset);
	    map.put("size", size);

	    List<MemberDTO> list = service.listMember(map);

	    String query = "";
	    if(searchValue.length() != 0) {
	        query = "searchKey=" + searchKey + "&searchValue=" + java.net.URLEncoder.encode(searchValue, "UTF-8");
	    }
	    
	    if(startDate != null && !startDate.equals("")) {
	        if(query.length() != 0) query += "&";
	        query += "startDate=" + startDate + "&endDate=" + endDate;
	    }
	    
	    if(!userLevel.equals("전체 등급")) {
	        if(query.length() != 0) query += "&";
	        query += "userLevel=" + java.net.URLEncoder.encode(userLevel, "UTF-8");
	    }

	    String listUrl = req.getContextPath() + "/admin/member/member_list";
	    if(query.length() != 0) {
	        listUrl += "?" + query;
	    }
	    
	    String paging = util.paging(current_page, total_page, listUrl);

	    ModelAndView mav = new ModelAndView("admin/member/member_list");
	    mav.addObject("list", list);
	    mav.addObject("page", current_page);
	    mav.addObject("dataCount", dataCount);
	    mav.addObject("total_page", total_page);
	    mav.addObject("paging", paging);
	    
	    mav.addObject("searchKey", searchKey);
	    mav.addObject("searchValue", searchValue);
	    mav.addObject("startDate", startDate);
	    mav.addObject("endDate", endDate);
	    mav.addObject("userLevel", userLevel);

	    return mav;
	}
	
	// 회원 상세 정보 조회 (AJAX)
    @ResponseBody
    @GetMapping("detail")
    public Map<String, Object> detail(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        
        try {
            long memberIdx = Long.parseLong(req.getParameter("memberIdx"));
            MemberDTO dto = service.findByIdx(memberIdx);
            
            if (dto != null) {
                model.put("state", "true");
                model.put("dto", new JSONObject(dto).toMap());
                
            } else {
                model.put("state", "false");
            }
        } catch (Exception e) {
            model.put("state", "false");
            e.printStackTrace();
        }
        
        return model;
    }
    
    // 회원 추가 처리 (AJAX)
    @ResponseBody
    @PostMapping("write")
    public Map<String, Object> write(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        
        try {
            MemberDTO dto = new MemberDTO();
            
            dto.setUserId(req.getParameter("userId"));
            dto.setUserPwd(req.getParameter("userPwd"));
            dto.setUserName(req.getParameter("userName"));
            dto.setNickName(req.getParameter("nickName"));
            dto.setGender(Integer.parseInt(req.getParameter("gender")));
            dto.setBirth(req.getParameter("birth")); 
            dto.setEmail(req.getParameter("email"));
            dto.setTel(req.getParameter("tel"));
            dto.setUserLevel(Integer.parseInt(req.getParameter("userLevel")));
            
            service.insertMember(dto);
            
            model.put("state", "true");
        } catch (Exception e) {
            model.put("state", "false");
            e.printStackTrace();
        }
        
        return model;
    }
    
    // 회원 수정 처리 (AJAX)
    @ResponseBody
    @PostMapping("update")
    public Map<String, Object> update(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        
        try {
            MemberDTO dto = new MemberDTO();
            
            dto.setMemberIdx(Long.parseLong(req.getParameter("memberIdx")));
            dto.setUserPwd(req.getParameter("userPwd"));
            dto.setNickName(req.getParameter("nickName"));
            dto.setGender(Integer.parseInt(req.getParameter("gender")));
            dto.setBirth(req.getParameter("birth"));
            dto.setEnabled(Integer.parseInt(req.getParameter("enabled")));
            dto.setUserLevel(Integer.parseInt(req.getParameter("userLevel")));
            dto.setUserName(req.getParameter("userName"));
            dto.setEmail(req.getParameter("email"));
            dto.setTel(req.getParameter("tel"));

            service.updateMember(dto);
            
            model.put("state", "true");
        } catch (Exception e) {
            model.put("state", "false");
            e.printStackTrace();
        }
        
        return model;
    }
    
    @ResponseBody
    @PostMapping("deleteList")
    public Map<String, Object> deleteList(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        
        try {
            String[] memberIdxs = req.getParameterValues("memberIdxs");
            
            if (memberIdxs != null) {
                for (String memberIdx : memberIdxs) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("memberIdx", memberIdx);
                    
                    service.deleteMember(map);
                }
            }
            model.put("state", "true");
            
        } catch (Exception e) {
            model.put("state", "false");
            e.printStackTrace();
        }
        
        return model;
    }
	
    @GetMapping("point_manage")
    public ModelAndView pointManage(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        ModelAndView mav = new ModelAndView("admin/member/point_manage");

        String page = req.getParameter("page");
        int current_page = 1;
        if (page != null) current_page = Integer.parseInt(page);

        String condition = req.getParameter("condition");
        String keyword = req.getParameter("keyword");
        String startDate = req.getParameter("startDate"); 
        String endDate = req.getParameter("endDate");    
        String minPointStr = req.getParameter("minPoint"); 
        String maxPointStr = req.getParameter("maxPoint"); 

        if (condition == null) condition = "all";
        if (keyword == null) keyword = "";
        
        if (req.getMethod().equalsIgnoreCase("GET")) {
            keyword = URLDecoder.decode(keyword, "UTF-8");
        }

        Map<String, Object> map = new HashMap<>();
        map.put("condition", condition);
        map.put("keyword", keyword);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        
        if(minPointStr != null && !minPointStr.matches("\\d+")) minPointStr = null;
        if(maxPointStr != null && !maxPointStr.matches("\\d+")) maxPointStr = null;
        
        if(minPointStr != null) map.put("minPoint", Integer.parseInt(minPointStr));
        if(maxPointStr != null) map.put("maxPoint", Integer.parseInt(maxPointStr));

        int dataCount = pointService.dataCountMemberPoint(map);
        int size = 10;
        int total_page = util.pageCount(dataCount, size);
        if (current_page > total_page) current_page = total_page;

        int start = (current_page - 1) * size + 1;
        int end = current_page * size;
        map.put("start", start);
        map.put("end", end);

        List<MemberDTO> list = pointService.listMemberPoint(map);
        
        String query = "";
        if (keyword.length() != 0) {
            query = "condition=" + condition + "&keyword=" + URLEncoder.encode(keyword, "UTF-8");
        }
        if (startDate != null && startDate.length() != 0) {
            if(query.length() != 0) query += "&";
            query += "startDate=" + startDate;
        }
        if (endDate != null && endDate.length() != 0) {
            if(query.length() != 0) query += "&";
            query += "endDate=" + endDate;
        }
        if (minPointStr != null) {
            if(query.length() != 0) query += "&";
            query += "minPoint=" + minPointStr;
        }
        if (maxPointStr != null) {
            if(query.length() != 0) query += "&";
            query += "maxPoint=" + maxPointStr;
        }

        String listUrl = req.getContextPath() + "/admin/member/point_manage";
        if (query.length() != 0) listUrl += "?" + query;
        
        String paging = util.paging(current_page, total_page, listUrl);

        mav.addObject("list", list);
        mav.addObject("page", current_page);
        mav.addObject("dataCount", dataCount);
        mav.addObject("paging", paging);
        
        mav.addObject("condition", condition);
        mav.addObject("keyword", keyword);
        mav.addObject("startDate", startDate);
        mav.addObject("endDate", endDate);
        mav.addObject("minPoint", minPointStr); 
        mav.addObject("maxPoint", maxPointStr);

        return mav;
    }

    // 포인트 상세 내역
    @GetMapping("point_history")
    public ModelAndView pointHistory(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        ModelAndView mav = new ModelAndView("admin/member/point_history");

        String memberIdxStr = req.getParameter("memberIdx");
        long memberIdx = Long.parseLong(memberIdxStr);
        String userId = req.getParameter("userId"); 

        String startDate = req.getParameter("startDate");
        String endDate = req.getParameter("endDate");
        String reason = req.getParameter("reason");

        String page = req.getParameter("page");
        int current_page = 1;
        if (page != null) current_page = Integer.parseInt(page);

        int size = 10;
        Map<String, Object> map = new HashMap<>();
        map.put("memberIdx", memberIdx);
        map.put("startDate", startDate);
        map.put("endDate", endDate);     
        map.put("reason", reason);       

        int dataCount = pointService.dataCountPointHistory(map);
        int total_page = util.pageCount(dataCount, size);
        if (current_page > total_page) current_page = total_page;

        int start = (current_page - 1) * size + 1;
        int end = current_page * size;
        map.put("start", start);
        map.put("end", end);

        List<PointDTO> list = pointService.listPointHistory(map);
        
        String query = "memberIdx=" + memberIdx + "&userId=" + userId;
        
        if (startDate != null && !startDate.isEmpty()) {
            query += "&startDate=" + startDate;
        }
        if (endDate != null && !endDate.isEmpty()) {
            query += "&endDate=" + endDate;
        }
        if (reason != null && !reason.isEmpty()) {
            query += "&reason=" + URLEncoder.encode(reason, "UTF-8");
        }

        String listUrl = req.getContextPath() + "/admin/member/point_history?" + query;
        String paging = util.paging(current_page, total_page, listUrl);

        mav.addObject("list", list);
        mav.addObject("page", current_page);
        mav.addObject("dataCount", dataCount);
        mav.addObject("paging", paging);
        mav.addObject("memberIdx", memberIdx);
        mav.addObject("userId", userId);
        
        mav.addObject("startDate", startDate);
        mav.addObject("endDate", endDate);
        mav.addObject("reason", reason);

        return mav;
    }
    
    @ResponseBody
    @PostMapping("updatePoint")
    public Map<String, Object> updatePoint(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        try {
            String mode = req.getParameter("mode");
            String amountStr = req.getParameter("point_amount");
            String reason = req.getParameter("reason");
            String[] memberIdxsStr = req.getParameterValues("memberIdxs");
            
            int amount = 0;
            if(amountStr != null && !amountStr.isEmpty()) {
                amount = Integer.parseInt(amountStr);
            }
            
            if ("minus".equals(mode) || "차감".equals(mode)) {
                amount = -Math.abs(amount); 
            }
            
            if (memberIdxsStr != null && memberIdxsStr.length > 0 && amount != 0) {
                List<Long> list = new ArrayList<>();
                for (String idx : memberIdxsStr) {
                    if (idx.contains(",")) {
                        String[] splitIdx = idx.split(",");
                        for (String s : splitIdx) {
                            if (s != null && !s.trim().isEmpty()) {
                                list.add(Long.parseLong(s.trim()));
                            }
                        }
                    } else {
                        if (idx != null && !idx.trim().isEmpty()) {
                            list.add(Long.parseLong(idx.trim()));
                        }
                    }
                }
                
                pointService.insertPointList(list, amount, reason);
                
                model.put("state", "true");
            } else {
                model.put("state", "false");
                model.put("message", "잘못된 요청 데이터입니다.");
            }
        } catch (Exception e) {
            model.put("state", "false");
            e.printStackTrace();
        }
        return model;
    }
	
	@GetMapping("dormant_manage")
	public ModelAndView dormantManage(HttpServletRequest req, HttpServletResponse resp) throws Exception {
	    ModelAndView mav = new ModelAndView("admin/member/dormant_manage");
	    
	    String page = req.getParameter("page");
	    int current_page = 1;
	    if(page != null) current_page = Integer.parseInt(page);
	    
	    String startDate = req.getParameter("startDate");
	    String endDate = req.getParameter("endDate");
	    String sortType = req.getParameter("sortType"); 
	    String keyword = req.getParameter("keyword");  

	    if(startDate == null) startDate = "";
	    if(endDate == null) endDate = "";
	    if(sortType == null) sortType = "latestDormant"; 
	    if(keyword == null) keyword = "";

	    if(req.getMethod().equalsIgnoreCase("GET")) {
	        keyword = java.net.URLDecoder.decode(keyword, "UTF-8");
	    }

	    Map<String, Object> map = new HashMap<>();
	    map.put("startDate", startDate);
	    map.put("endDate", endDate);
	    map.put("sortType", sortType);
	    map.put("keyword", keyword);

	    int size = 10;
	    int dataCount = service.dataCountDormant(map);
	    int total_page = util.pageCount(dataCount, size);
	    
	    if(current_page > total_page) current_page = total_page;
	    
	    int offset = (current_page - 1) * size;
	    if(offset < 0) offset = 0;

	    map.put("offset", offset);
	    map.put("size", size);

	    List<MemberDTO> list = service.listDormantMembers(map);

	    String cp = req.getContextPath();
	    String listUrl = cp + "/admin/member/dormant_manage";
	    String query = "";

	    if(keyword.length() != 0 || startDate.length() != 0 || !sortType.equals("latestDormant")) {
	        query = "startDate=" + startDate + "&endDate=" + endDate + 
	                "&sortType=" + sortType + 
	                "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8");
	    }

	    if(query.length() != 0) {
	        listUrl += "?" + query;
	    }

	    String paging = util.paging(current_page, total_page, listUrl);

	    mav.addObject("list", list);
	    mav.addObject("dataCount", dataCount);
	    mav.addObject("page", current_page);
	    mav.addObject("paging", paging);
	    
	    mav.addObject("startDate", startDate);
	    mav.addObject("endDate", endDate);
	    mav.addObject("sortType", sortType);
	    mav.addObject("keyword", keyword);

	    return mav;
	}
	
	@ResponseBody
    @PostMapping("releaseDormantList")
    public Map<String, Object> releaseDormantList(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        
        try {
            String[] memberIdxs = req.getParameterValues("memberIdxs");
            
            if (memberIdxs != null && memberIdxs.length > 0) {
                List<Long> list = new ArrayList<>();
                for (String idx : memberIdxs) {
                    list.add(Long.parseLong(idx));
                }
                
                service.releaseDormantMembers(list);
                
                model.put("state", "true");
                model.put("count", list.size());
            } else {
                model.put("state", "false");
                model.put("message", "선택된 회원이 없습니다.");
            }
            
        } catch (Exception e) {
            model.put("state", "false");
            model.put("message", "에러가 발생했습니다.");
            e.printStackTrace();
        }
        
        return model;
    }
	
	@GetMapping("profile")
	public ModelAndView adminProfile(HttpServletRequest req, HttpServletResponse resp) {
	    ModelAndView mav = new ModelAndView("admin/member/profile");
	    
	    HttpSession session = req.getSession();
	    SessionInfo info = (SessionInfo) session.getAttribute("member");

	    try {
	        MemberDTO dto = service.findByIdx(info.getMemberIdx());
	        mav.addObject("dto", dto);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return mav;
	}
	
	@PostMapping("updateProfile")
    public String updateProfile(HttpServletRequest req, HttpServletResponse resp) {
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        
        try {
            MemberDTO dto = service.findByIdx(info.getMemberIdx());
            
            dto.setUserName(req.getParameter("userName"));
            dto.setTel(req.getParameter("tel"));
            
            String pwd = req.getParameter("userPwd");
            if(pwd != null && !pwd.trim().isEmpty()) {
                dto.setUserPwd(pwd);
            }

            service.updateMember(dto);

            info.setUserName(dto.getUserName());
            session.setAttribute("member", info);
            
            return "redirect:/admin?result=profile_updated";

        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return "redirect:/admin/member/profile";
    }
}