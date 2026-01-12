package com.maknaez.controller.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.maknaez.model.MemberDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.MemberService;
import com.maknaez.service.MemberServiceImpl;
import com.maknaez.util.MyUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/admin/member/*")
public class MemberManageController {
	private MemberService service = new MemberServiceImpl();
	private MyUtil util = new MyUtil();
	
	@GetMapping("member_list")
	public ModelAndView memberList(HttpServletRequest req, HttpServletResponse resp) throws Exception {
	    
	    // 1. 파라미터 준비
	    String page = req.getParameter("page");
	    int current_page = 1;
	    if(page != null && !page.equals("")) {
	        try {
	            current_page = Integer.parseInt(page);
	        } catch(Exception e) { }
	    }
	    
	    // 검색 조건 파라미터 처리
	    String searchKey = req.getParameter("searchKey");
	    String searchValue = req.getParameter("searchValue");
	    String startDate = req.getParameter("startDate");
	    String endDate = req.getParameter("endDate");
	    String userLevel = req.getParameter("userLevel");

	    if(searchKey == null) searchKey = "all";
	    if(searchValue == null) searchValue = "";
	    if(userLevel == null) userLevel = "전체 등급"; // 기본값 설정

	    Map<String, Object> map = new HashMap<>();
	    map.put("searchKey", searchKey);
	    map.put("searchValue", searchValue);
	    map.put("startDate", startDate);
	    map.put("endDate", endDate);
	    map.put("userLevel", userLevel);

	    // 2. 전체 데이터 개수 구하기
	    int dataCount = service.dataCount(map);
	    
	    // 3. 페이징 계산 (OFFSET 방식)
	    int size = 10; // 한 페이지에 보여줄 개수
	    int total_page = util.pageCount(dataCount, size);
	    
	    if(current_page > total_page) {
	        current_page = total_page;
	    }
	    
	    int offset = (current_page - 1) * size; // 건너뛸 개수 계산
	    if(offset < 0) offset = 0;

	    map.put("offset", offset);
	    map.put("size", size);

	    // 4. 데이터 가져오기
	    List<MemberDTO> list = service.listMember(map);

	    // 5. 페이징 바 만들기
	    // (검색 조건 유지를 위한 쿼리 스트링 생성)
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

	    // 6. View로 전달
	    ModelAndView mav = new ModelAndView("admin/member/member_list");
	    mav.addObject("list", list);
	    mav.addObject("page", current_page);
	    mav.addObject("dataCount", dataCount);
	    mav.addObject("total_page", total_page);
	    mav.addObject("paging", paging);
	    
	    // 검색 조건 유지를 위해 다시 전달
	    mav.addObject("searchKey", searchKey);
	    mav.addObject("searchValue", searchValue);
	    mav.addObject("startDate", startDate);
	    mav.addObject("endDate", endDate);
	    mav.addObject("userLevel", userLevel);

	    return mav;
	}
	
	// 1. 회원 상세 정보 조회 (AJAX)
    @ResponseBody
    @GetMapping("detail")
    public Map<String, Object> detail(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        
        try {
            long memberIdx = Long.parseLong(req.getParameter("memberIdx"));
            MemberDTO dto = service.findByIdx(memberIdx);
            
            if (dto != null) {
                model.put("state", "true");
                
                // [핵심 수정] DTO를 JSONObject로 감싸서 넣어야 필드(getter)들이 JSON으로 풀립니다.
                // new JSONObject(dto)는 dto의 Getter들을 읽어서 JSON으로 만들어줍니다.
                // toString()으로 변환되어, 맵에 저장되는 것을 방지하기 위해 .toMap()을 사용하는 것이 가장 안전합니다.
                // 라이브러리 버전에 따라 .toMap()이 없다면 new JSONObject(dto) 자체를 넣으셔도 됩니다.
                
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
    
    // 2. 회원 추가 처리 (AJAX)
    @ResponseBody
    @PostMapping("write")
    public Map<String, Object> write(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> model = new HashMap<>();
        
        try {
            MemberDTO dto = new MemberDTO();
            
            // 파라미터 매핑
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
    
    // 3. 회원 수정 처리 (AJAX)
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
	public ModelAndView pointManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/member/point_manage");
		
		return mav;
	}
	
	@GetMapping("dormant_manage")
	public ModelAndView dormantManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/member/dormant_manage");
		
		return mav;
	}
}
