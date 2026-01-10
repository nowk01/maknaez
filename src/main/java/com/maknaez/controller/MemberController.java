package com.maknaez.controller;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.util.FileManager;
import com.maknaez.util.MyMultipartFile;
import com.maknaez.util.MyUtil;
import com.maknaez.mapper.OrderMapper;
import com.maknaez.model.MemberDTO;
import com.maknaez.model.OrderDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.mybatis.support.MapperContainer;
import com.maknaez.service.MemberService;
import com.maknaez.service.MemberServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@Controller
@RequestMapping("/member")
public class MemberController {
	private MemberService service = new MemberServiceImpl();
	private FileManager fileManager = new FileManager();
	
	@GetMapping("consent")
	public ModelAndView consentForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		return new ModelAndView("member/consent");
	}
	
	@GetMapping("login")
	public ModelAndView loginForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		return new ModelAndView("member/login");
	}
	
	@GetMapping("mypage/main.do")
	public ModelAndView myPageMain(HttpServletRequest req, HttpServletResponse resp) {
		ModelAndView mav = new ModelAndView("mypage/myMain");
		return mav;
	}

	@PostMapping("login")
	public ModelAndView loginSubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		
		try {
			String userId = req.getParameter("userId");
			String userPwd = req.getParameter("userPwd");

			Map<String, Object> map = new HashMap<>();
			map.put("userId", userId);
			map.put("userPwd", userPwd);
			
			MemberDTO dto = service.loginMember(map);
			
			if(dto == null) {
				ModelAndView mav = new ModelAndView("member/login");
				mav.addObject("message", "아이디 또는 패스워드가 일치하지 않습니다.");
				return mav;
			}
			
			session.setMaxInactiveInterval(20 * 60); 

			SessionInfo info = new SessionInfo();
			info.setMemberIdx(dto.getMemberIdx());
			info.setUserId(dto.getUserId());
			
			if("admin".equals(dto.getUserId())) {
				info.setUserName("관리자");
			} else {
				info.setUserName(dto.getUserName());
			}
			
			info.setAvatar(dto.getProfile_photo());
			info.setUserLevel(dto.getUserLevel());

			session.setAttribute("member", info);

			String preLoginURI = (String)session.getAttribute("preLoginURI");
			session.removeAttribute("preLoginURI");
			if(preLoginURI != null) {
				return new ModelAndView(preLoginURI);
			} 
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return new ModelAndView("redirect:/member/mypage/main.do");
	}
	
	@GetMapping("logout")
	public ModelAndView logout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		session.removeAttribute("member");
		session.invalidate();
		return new ModelAndView("redirect:/");
	}
	
	@GetMapping("noAuthorized")
	public ModelAndView noAuthorized(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		return new ModelAndView("member/noAuthorized");
	}
	
	@GetMapping("account")
	public ModelAndView accountForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("member/member");
		mav.addObject("mode", "account");
		return mav;
	}
	
	@PostMapping("account")
	public ModelAndView accountSubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "member";
		String message = "";
		
		try {
			MemberDTO dto = new MemberDTO();
			
			dto.setUserId(req.getParameter("userId"));
			dto.setUserPwd(req.getParameter("userPwd"));
			dto.setUserName(req.getParameter("userName"));
			dto.setBirth(req.getParameter("birth"));
			
			String email1 = req.getParameter("email1");
			String email2 = req.getParameter("email2");
			dto.setEmail(email1 + "@" + email2);
			
			Part p = req.getPart("selectFile");
			MyMultipartFile mp = fileManager.doFileUpload(p, pathname);
			if(mp != null) {
				dto.setProfile_photo(mp.getSaveFilename());
			}
			
			dto.setTel(req.getParameter("tel"));
			dto.setZip(req.getParameter("zip"));
			dto.setAddr1(req.getParameter("addr1"));
			dto.setAddr2(req.getParameter("addr2"));
			
			service.insertMember(dto);
			
			session.setAttribute("mode", "account");
			session.setAttribute("userName", dto.getUserName());
			
			return new ModelAndView("redirect:/member/complete");
			
		} catch (SQLException e) {
			if(e.getErrorCode() == 1) {
				message = "아이디 중복으로 회원가입이 실패했습니다.";
			} else if(e.getErrorCode() == 1400) {
				message = "필수사항을 입력 하지 않았습니다.";
			} else if(e.getErrorCode() == 1840 || e.getErrorCode() == 1861) {
				message = "날짜형식이 일치하지 않습니다.";
			} else {
				message = "회원가입이 실패했습니다....";
			}
		} catch (Exception e) {
			message = "회원 가입이 실패했습니다.";
			e.printStackTrace();
		}
		
		ModelAndView mav = new ModelAndView("member/member");
		mav.addObject("mode", "account");
		mav.addObject("message", message);
		return mav;
	}
	
	@GetMapping("pwd")
	public ModelAndView pwdForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		ModelAndView mav = new ModelAndView("member/pwd");
		String mode = req.getParameter("mode");
		mav.addObject("mode", mode);
		return mav;
	}
	
	@PostMapping("pwd")
	public ModelAndView pwdSubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		try {
			MemberDTO dto = service.findById(info.getUserId());
			
			if(dto == null) {
				session.invalidate();
				return new ModelAndView("redirect:/");
			}
			
			String userPwd = req.getParameter("userPwd");
			String mode = req.getParameter("mode");
			
			if(! dto.getUserPwd().equals(userPwd)) {
				ModelAndView mav = new ModelAndView("member/pwd");
				mav.addObject("mode", mode);
				mav.addObject("message", "패스워드가 일치하지 않습니다.");
				return mav;
			}
			
			if(mode.equals("delete")) {
				session.removeAttribute("member");
				session.invalidate();
			} else if(mode.equals("update")) {
				ModelAndView mav = new ModelAndView("member/member");
				mav.addObject("dto", dto);
				mav.addObject("mode", "update");
				return mav;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return new ModelAndView("redirect:/");
	}
	
	@PostMapping("update")
	public ModelAndView updateSubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "member";
		
		try {
			MemberDTO dto = new MemberDTO();
			
			dto.setUserId(info.getUserId());
			dto.setUserPwd(req.getParameter("userPwd"));
			dto.setUserName(req.getParameter("userName"));
			dto.setBirth(req.getParameter("birth"));
			
			String email1 = req.getParameter("email1");
			String email2 = req.getParameter("email2");
			dto.setEmail(email1 + "@" + email2);
			
			dto.setProfile_photo(req.getParameter("profile_photo"));
			Part p = req.getPart("selectFile");
			
			MyMultipartFile mp = fileManager.doFileUpload(p, pathname);
			if(mp != null) {
				if(dto.getProfile_photo().length() != 0) {
					fileManager.doFiledelete(pathname, dto.getProfile_photo());
				}
				dto.setProfile_photo(mp.getSaveFilename()); 
			}
			
			dto.setTel(req.getParameter("tel"));
			dto.setZip(req.getParameter("zip"));
			dto.setAddr1(req.getParameter("addr1"));
			dto.setAddr2(req.getParameter("addr2"));
			
			service.updateMember(dto);
			
			info.setAvatar(dto.getProfile_photo());
			
			session.setAttribute("mode", "update");
			session.setAttribute("userName", dto.getUserName());
			
			return new ModelAndView("redirect:/member/complete");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return new ModelAndView("redirect:/");
	}
	
	@GetMapping("complete")
	public ModelAndView complete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		HttpSession session = req.getSession();
		
		String mode = (String)session.getAttribute("mode");
		String userName = (String)session.getAttribute("userName");
		
		session.removeAttribute("mode");
		session.removeAttribute("userName");
		
		if(mode == null) {
			return new ModelAndView("redirect:/");
		}
		
		String title;
		String message = "<b>" + userName + "</b>님";
		if(mode.equals("account")) {
			title = "회원가입";
			message += "회원가입이 완료 되었습니다.<br>로그인 하시면 정보를 이용할 수 있습니다.";
		} else {
			title = "정보수정";
			message += "회원정보가 수정 되었습니다.<br>메인 화면으로 이동하시기 바랍니다.";
		}
		
		ModelAndView mav = new ModelAndView("member/complete");
		mav.addObject("title", title);
		mav.addObject("message", message);
		return mav;
	}
	
	@ResponseBody
	@PostMapping("userIdCheck")
	public Map<String, Object> userIdCheck(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		Map<String, Object> model = new HashMap<String, Object>();
		
		String userId = req.getParameter("userId");
		MemberDTO dto = service.findById(userId);
		
		String passed = "false";
		if(dto == null) {
			passed = "true";
		}
		
		model.put("passed", passed);
		return model;
	}
	
	@ResponseBody
	@PostMapping("deleteProfile")
	public Map<String, Object> deleteProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		Map<String, Object> model = new HashMap<String, Object>();
		
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "member";
		
		String state = "false";
		
		try {
			String profile_photo = req.getParameter("profile_photo");
			
			if(profile_photo != null && profile_photo.length() != 0) {
				fileManager.doFiledelete(pathname, profile_photo);
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("userId", info.getUserId());
				
				service.deleteProfilePhoto(map);
				
				info.setAvatar("");
				state = "true";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		model.put("state", state);
		return model;
	}
	
	/* =========================================================
	   [수정됨] 주문/배송 조회 (상태별 카운트 추가)
	   ========================================================= */
	@GetMapping("mypage/orderList")
	public ModelAndView orderList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("mypage/orderList");
		HttpSession session = req.getSession();
		
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}
		
		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		MyUtil util = new MyUtil(); 
		
		try {
			String page = req.getParameter("page");
			int current_page = 1;
			if (page != null) current_page = Integer.parseInt(page);
			
			// 1. 기본 파라미터 맵 설정
			Map<String, Object> map = new HashMap<>();
			map.put("memberIdx", info.getMemberIdx());
			
			// 2. 전체 주문 개수 (빨간색 숫자용)
			int dataCount = mapper.dataCount(map);

			// 3. [추가] 상태별 개수 구하기
			// (주의: MyBatis Mapper XML에서 <if test="orderState!=null"> 로직이 있어야 동작합니다)
			
			// 결제완료
			map.put("orderState", "결제완료");
			int paymentCount = mapper.dataCount(map);
			
			// 배송중
			map.put("orderState", "배송중");
			int shippingCount = mapper.dataCount(map);
			
			// 배송완료
			map.put("orderState", "배송완료");
			int completeCount = mapper.dataCount(map);
			
			// ★ 중요: 리스트를 가져올 때는 상태 조건(orderState)을 지워야 전체 목록이 보입니다!
			map.remove("orderState");
			
			// 4. 페이징 처리
			int size = 5; 
			int total_page = util.pageCount(dataCount, size);
			if (current_page > total_page) current_page = total_page;
			
			int start = (current_page - 1) * size + 1;
			int end = current_page * size;
			map.put("start", start);
			map.put("end", end);
			
			// 5. 리스트 가져오기
			List<OrderDTO> list = mapper.listOrder(map);
			
			String listUrl = req.getContextPath() + "/member/mypage/orderList";
			String paging = util.paging(current_page, total_page, listUrl);
			
			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount); // 전체
			mav.addObject("paging", paging);
			
			// [추가] 상태별 개수 전달
			mav.addObject("paymentCount", paymentCount);
			mav.addObject("shippingCount", shippingCount);
			mav.addObject("completeCount", completeCount);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return mav;
	}
	
	/* =========================================================
	   [수정됨] 취소/반품 조회 (상태별 카운트 추가)
	   ========================================================= */
	@GetMapping("mypage/cancelList")
	public ModelAndView cancelList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("mypage/cancelList");
		HttpSession session = req.getSession();
		
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}
		
		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		MyUtil util = new MyUtil();
		
		try {
			String page = req.getParameter("page");
			int current_page = 1;
			if (page != null) current_page = Integer.parseInt(page);
			
			Map<String, Object> map = new HashMap<>();
			map.put("memberIdx", info.getMemberIdx());
			map.put("mode", "cancel"); // 기본 모드: 취소/반품 내역만 조회
			
			// 1. 전체 취소/반품 개수
			int dataCount = mapper.dataCount(map);
			
			// 2. [추가] 취소/반품 상태별 개수 구하기
			// (DB에 저장되는 실제 상태명에 맞춰주세요. 예: "주문취소", "반품신청" 등)
			
			// 취소 (주문취소 완료된 건)
			map.put("orderState", "취소완료"); // 혹은 "주문취소"
			int cancelCount = mapper.dataCount(map);
			
			// 반품신청 (조회)
			map.put("orderState", "반품신청");
			int returnCheckCount = mapper.dataCount(map);
			
			// 반품진행중
			map.put("orderState", "반품중");
			int returnIngCount = mapper.dataCount(map);

			// 반품완료
			map.put("orderState", "반품완료");
			int returnDoneCount = mapper.dataCount(map);
			
			// ★ 중요: 리스트 조회 전 상태 조건 제거 (mode="cancel"은 유지)
			map.remove("orderState");
			
			
			int size = 5;
			int total_page = util.pageCount(dataCount, size);
			if (current_page > total_page) current_page = total_page;
			
			int start = (current_page - 1) * size + 1;
			int end = current_page * size;
			map.put("start", start);
			map.put("end", end);
			
			List<OrderDTO> list = mapper.listOrder(map);
			
			String listUrl = req.getContextPath() + "/member/mypage/cancelList";
			String paging = util.paging(current_page, total_page, listUrl);
			
			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			mav.addObject("paging", paging);
			
			// [추가] 상태별 개수 전달
			mav.addObject("cancelCount", cancelCount);
			mav.addObject("returnCheckCount", returnCheckCount);
			mav.addObject("returnIngCount", returnIngCount);
			mav.addObject("returnDoneCount", returnDoneCount);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return mav;
	}
	
	/* MemberController.java 내부에 추가 */

	/* [수정] 상품 리뷰 페이지 - 배송완료된 목록 가져오기 */
	@GetMapping("mypage/review")
	public ModelAndView review(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("mypage/review");
		HttpSession session = req.getSession();
		
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}
		
		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		
		try {
			Map<String, Object> map = new HashMap<>();
			map.put("memberIdx", info.getMemberIdx());
			
			// ★ 핵심: '배송완료'된 상품만 가져와서 리뷰 작성 목록으로 보여줍니다.
			map.put("orderState", "배송완료");
			
			// 페이징 없이 최근 100개만 가져옴 (필요 시 페이징 추가 가능)
			map.put("start", 1);
			map.put("end", 100);
			
			List<OrderDTO> list = mapper.listOrder(map);
			int dataCount = mapper.dataCount(map); // 작성 가능한 리뷰 개수
			
			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return mav;
	}
	
	
	
	
}