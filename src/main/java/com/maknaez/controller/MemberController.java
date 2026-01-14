package com.maknaez.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.maknaez.util.FileManager;
import com.maknaez.util.MyMultipartFile;
import com.maknaez.util.MyUtil;
import com.maknaez.mapper.OrderMapper;
import com.maknaez.model.AddressDTO;
import com.maknaez.model.MemberDTO;
import com.maknaez.model.OrderDTO;
import com.maknaez.model.ProductDTO;
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
	public ModelAndView consentForm(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		return new ModelAndView("member/consent");
	}

	@GetMapping("login")
	public ModelAndView loginForm(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		return new ModelAndView("member/login");
	}

	@GetMapping("mypage/main.do")
	public ModelAndView myPageMain(HttpServletRequest req, HttpServletResponse resp) {
		ModelAndView mav = new ModelAndView("mypage/myMain");
		return mav;
	}

	@PostMapping("login")
	public ModelAndView loginSubmit(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();

		try {
			String userId = req.getParameter("userId");
			String userPwd = req.getParameter("userPwd");

			Map<String, Object> map = new HashMap<>();
			map.put("userId", userId);
			map.put("userPwd", userPwd);

			MemberDTO dto = service.loginMember(map);

			if (dto == null) {
				ModelAndView mav = new ModelAndView("member/login");
				mav.addObject("message", "아이디 또는 패스워드가 일치하지 않습니다.");
				return mav;
			}

			session.setMaxInactiveInterval(20 * 60);

			SessionInfo info = new SessionInfo();
			info.setMemberIdx(dto.getMemberIdx());
			info.setUserId(dto.getUserId());

			if ("admin".equals(dto.getUserId())) {
				info.setUserName("관리자");
			} else {
				info.setUserName(dto.getUserName());
			}

			info.setAvatar(dto.getProfile_photo());
			info.setUserLevel(dto.getUserLevel());

			session.setAttribute("member", info);

			String preLoginURI = (String) session.getAttribute("preLoginURI");
			session.removeAttribute("preLoginURI");
			if (preLoginURI != null) {
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
	public ModelAndView noAuthorized(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		return new ModelAndView("member/noAuthorized");
	}

	@GetMapping("account")
	public ModelAndView accountForm(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("member/member");
		mav.addObject("mode", "account");
		return mav;
	}

	@PostMapping("account")
	public ModelAndView accountSubmit(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "member";
		String message = "";

		try {
			MemberDTO dto = new MemberDTO();

			dto.setUserId(req.getParameter("userId"));
			dto.setUserPwd(req.getParameter("userPwd"));
			dto.setUserName(req.getParameter("userName"));
			dto.setNickName(req.getParameter("nickName"));
			dto.setBirth(req.getParameter("birth"));

			String email1 = req.getParameter("email1");
			String email2 = req.getParameter("email2");
			dto.setEmail(email1 + "@" + email2);

			Part p = req.getPart("selectFile");
			MyMultipartFile mp = fileManager.doFileUpload(p, pathname);
			if (mp != null) {
				dto.setProfile_photo(mp.getSaveFilename());
			}

			String tel1 = req.getParameter("tel1");
			String tel2 = req.getParameter("tel2");
			String tel3 = req.getParameter("tel3");
			String tel = "";

			if(tel1 != null && !tel1.isEmpty()) {
			    tel = tel1 + "-" + tel2 + "-" + tel3;
			}

			dto.setTel(tel);
			dto.setZip(req.getParameter("zip"));
			dto.setAddr1(req.getParameter("addr1"));
			dto.setAddr2(req.getParameter("addr2"));

			service.insertMember(dto);

			session.setAttribute("mode", "account");
			session.setAttribute("userName", dto.getUserName());

			return new ModelAndView("redirect:/member/complete");

		} catch (SQLException e) {
			if (e.getErrorCode() == 1) {
				message = "아이디 중복으로 회원가입이 실패했습니다.";
			} else if (e.getErrorCode() == 1400) {
				message = "필수사항을 입력 하지 않았습니다.";
			} else if (e.getErrorCode() == 1840 || e.getErrorCode() == 1861) {
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
	public ModelAndView pwdForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("member/pwd");
		String mode = req.getParameter("mode");
		mav.addObject("mode", mode);
		return mav;
	}

	@PostMapping("pwd")
	public ModelAndView pwdSubmit(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		try {
			// 1. 회원 정보 가져오기
			MemberDTO dto = service.findByIdx(info.getMemberIdx());

			if (dto == null) {
				session.invalidate();
				return new ModelAndView("redirect:/");
			}

			String userPwd = req.getParameter("userPwd");
			String mode = req.getParameter("mode");

			// 2. 비밀번호 확인
			if (!dto.getUserPwd().equals(userPwd)) {
				ModelAndView mav = new ModelAndView("member/pwd");
				mav.addObject("mode", mode);
				mav.addObject("message", "패스워드가 일치하지 않습니다.");
				return mav;
			}

			// 3. 모드별 처리
			if (mode.equals("delete")) {
				// 회원 탈퇴 처리 (기존 유지)
				session.removeAttribute("member");
				session.invalidate();
			} else if (mode.equals("update")) {
				/*
				 * ============================================== [수정 핵심] 여기를 바꿔야 새 페이지가 뜹니다!
				 * ==============================================
				 */

				// (1) 이메일 분리: DB에 있는 email(user@naver.com)을 쪼개서 화면에 보냄
				if (dto.getEmail() != null) {
					String[] emails = dto.getEmail().split("@");
					if (emails.length > 0)
						dto.setEmail1(emails[0]);
					if (emails.length > 1)
						dto.setEmail2(emails[1]);
				}

				// (2) 이동 경로 변경: member/member -> mypage/myInfo
				ModelAndView mav = new ModelAndView("mypage/myInfo");
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
	public ModelAndView updateSubmit(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		// 1. 로그인 여부 확인
		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		try {
			// 2. 기존 정보 가져오기
			MemberDTO dto = service.findByIdx(info.getMemberIdx());
			if (dto == null) {
				session.invalidate();
				return new ModelAndView("redirect:/member/login");
			}

			// --- [디버깅] 넘어온 파라미터 확인 (콘솔창 확인용) ---
			System.out.println("--- 회원정보 수정 요청 시작 ---");
			System.out.println("비밀번호: " + req.getParameter("userPwd"));
			System.out.println("이름: " + req.getParameter("userName"));
			System.out.println("이메일1: " + req.getParameter("email1"));
			System.out.println("이메일2: " + req.getParameter("email2"));
			// ------------------------------------------------

			// 3. 폼 데이터로 DTO 업데이트
			dto.setUserPwd(req.getParameter("userPwd"));
			dto.setUserName(req.getParameter("userName"));

			String email1 = req.getParameter("email1");
			String email2 = req.getParameter("email2");
			if (email1 != null && email2 != null) {
				dto.setEmail(email1 + "@" + email2);
			}

			dto.setTel(req.getParameter("tel"));

			String genderStr = req.getParameter("gender");
			if (genderStr != null && !genderStr.isEmpty()) {
				dto.setGender(Integer.parseInt(genderStr));
			}

			dto.setZip(req.getParameter("zip"));
			dto.setAddr1(req.getParameter("addr1"));
			dto.setAddr2(req.getParameter("addr2"));

			// 이메일 수신동의 처리 (JSP에 체크박스가 있다면)
			String receiveEmail = req.getParameter("receiveEmail");
			dto.setReceiveEmail(receiveEmail != null ? 1 : 0);

			// 4. DB 업데이트 실행
			service.updateMember(dto);
			System.out.println("--- DB 업데이트 성공 ---");

			// 5. 세션 정보 갱신
			info.setUserName(dto.getUserName());
			session.setAttribute("member", info);

			session.setAttribute("mode", "update");
			session.setAttribute("userName", dto.getUserName());

			return new ModelAndView("redirect:/member/complete");

		} catch (Exception e) {
			// [중요] 에러 발생 시 콘솔에 빨간 줄로 원인 출력
			System.err.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
			System.err.println("회원정보 수정 중 에러 발생!");
			System.err.println("에러 메시지: " + e.getMessage());
			e.printStackTrace();
			System.err.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		}

		// 실패 시 다시 폼으로
		return new ModelAndView("redirect:/member/mypage/myInfo");
	}

	@GetMapping("complete")
	public ModelAndView complete(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();

		String mode = (String) session.getAttribute("mode");
		String userName = (String) session.getAttribute("userName");

		session.removeAttribute("mode");
		session.removeAttribute("userName");

		if (mode == null) {
			return new ModelAndView("redirect:/");
		}

		String title;
		String message = "<b>" + userName + "</b>님";
		if (mode.equals("account")) {
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
	public Map<String, Object> userIdCheck(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		Map<String, Object> model = new HashMap<String, Object>();

		String userId = req.getParameter("userId");
		MemberDTO dto = service.findById(userId);

		String passed = "false";
		if (dto == null) {
			passed = "true";
		}

		model.put("passed", passed);
		return model;
	}

	@PostMapping("nickNameCheck")
	public void nickNameCheck(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String nickName = req.getParameter("nickName");

		MemberDTO dto = service.findByNickName(nickName);
		boolean isPassed = (dto == null);

		JSONObject json = new JSONObject();
		json.put("passed", isPassed);

		resp.setContentType("application/json; charset=UTF-8");
		PrintWriter out = resp.getWriter();
		out.print(json.toString());
		out.flush();
		out.close();
	}

	@ResponseBody
	@PostMapping("deleteProfile")
	public Map<String, Object> deleteProfile(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		Map<String, Object> model = new HashMap<String, Object>();

		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "member";

		String state = "false";

		try {
			String profile_photo = req.getParameter("profile_photo");

			if (profile_photo != null && profile_photo.length() != 0) {
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

	@GetMapping("mypage/orderList")
	public ModelAndView orderList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
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
			if (page != null)
				current_page = Integer.parseInt(page);

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
			if (current_page > total_page)
				current_page = total_page;

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

	@GetMapping("mypage/cancelList")
	public ModelAndView cancelList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
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
			if (page != null)
				current_page = Integer.parseInt(page);

			Map<String, Object> map = new HashMap<>();
			map.put("memberIdx", info.getMemberIdx());
			map.put("mode", "cancel"); // 기본 모드: 취소/반품 내역만 조회

			int dataCount = mapper.dataCount(map);

			map.put("orderState", "취소완료"); // 혹은 "주문취소"
			int cancelCount = mapper.dataCount(map);

			map.put("orderState", "반품신청");
			int returnCheckCount = mapper.dataCount(map);

			map.put("orderState", "반품중");
			int returnIngCount = mapper.dataCount(map);

			map.put("orderState", "반품완료");
			int returnDoneCount = mapper.dataCount(map);

			map.remove("orderState");

			int size = 5;
			int total_page = util.pageCount(dataCount, size);
			if (current_page > total_page)
				current_page = total_page;

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

			mav.addObject("cancelCount", cancelCount);
			mav.addObject("returnCheckCount", returnCheckCount);
			mav.addObject("returnIngCount", returnIngCount);
			mav.addObject("returnDoneCount", returnDoneCount);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	
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

			map.put("orderState", "배송완료");

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

	// [MemberController.java 내부에 추가]

	@GetMapping("mypage/wishList")
	public ModelAndView wishList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("mypage/wishList");
		HttpSession session = req.getSession();

		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		List<ProductDTO> list = new ArrayList<>();

		// 더미 데이터 1
		ProductDTO item1 = new ProductDTO();
		item1.setProdId(101); // setProductNo -> setProdId
		item1.setProdName("ACS 프로 (관심상품 예시)"); // setProductName -> setProdName
		item1.setPrice(290000);
		// 이미지 경로 설정: 전체 URL 대신 파일명만 넣는 것을 권장합니다 (JSP에서 경로 처리)
		item1.setThumbnail("sport_acs.jpg"); // setImageFile -> setThumbnail
		item1.setDiscountRate(0); // 할인율 (선택)
		list.add(item1);

		// 더미 데이터 2
		ProductDTO item2 = new ProductDTO();
		item2.setProdId(102);
		item2.setProdName("XT-6 GTX");
		item2.setPrice(280000);
		item2.setThumbnail("sport_xt6.jpg");
		list.add(item2);

		// 더미 데이터 3
		ProductDTO item3 = new ProductDTO();
		item3.setProdId(103);
		item3.setProdName("SPEEDCROSS 6");
		item3.setPrice(198000);
		item3.setThumbnail("women_trail_1.jpg");
		list.add(item3);

		mav.addObject("list", list);
		mav.addObject("dataCount", list.size());

		return mav;
	}

	@GetMapping("mypage/myInfo")
	public ModelAndView myInfo(HttpServletRequest req, HttpServletResponse resp) {

		HttpSession session = req.getSession(false);
		if (session == null) {
			return new ModelAndView("redirect:/member/login");
		}

		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		ModelAndView mav = new ModelAndView("mypage/myInfo");

		try {
			MemberDTO dto = service.findByIdx(info.getMemberIdx());

			if (dto != null && dto.getEmail() != null) {
				String[] emails = dto.getEmail().split("@");
				if (emails.length > 0)
					dto.setEmail1(emails[0]);
				if (emails.length > 1)
					dto.setEmail2(emails[1]);
			}
			mav.addObject("dto", dto); // JSP에서 사용할 수 있도록 'dto'라는 이름으로 전달
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}
	
	// 1. 배송지 목록 페이지 이동
	@GetMapping("mypage/addr")
	public ModelAndView addressList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		// 로그인 확인
		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		ModelAndView mav = new ModelAndView("mypage/addr"); // 뷰 페이지: /WEB-INF/views/mypage/addr.jsp

		try {
			// Service에서 배송지 목록 가져오기
			// (MemberService에 listAddress 메서드가 구현되어 있어야 합니다)
			List<AddressDTO> list = service.listAddress(info.getMemberIdx());
			mav.addObject("list", list);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	
	@PostMapping("mypage/addr/write")
	public ModelAndView addressWrite(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		try {
			AddressDTO dto = new AddressDTO();
			dto.setMemberIdx(info.getMemberIdx());

			dto.setReceiverName(req.getParameter("receiverName")); 
	        dto.setAddrName(req.getParameter("addrName"));
	        dto.setReceiverTel(req.getParameter("receiverTel"));  
	        dto.setZipCode(req.getParameter("zipCode"));         
	        dto.setAddr1(req.getParameter("addr1"));
	        dto.setAddr2(req.getParameter("addr2"));

			// 기본 배송지 체크 여부 (체크되면 1, 아니면 0)
	        String isBasic = req.getParameter("isBasic");       
	        dto.setIsBasic(isBasic != null ? 1 : 0);

			// Service에 저장 요청
			service.insertAddress(dto);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return new ModelAndView("redirect:/member/mypage/addr");
	}

	// 3. 배송지 삭제 처리
	@GetMapping("mypage/addr/delete")
	public ModelAndView addressDelete(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		try {
	        long addrId = Long.parseLong(req.getParameter("addrId"));
	       
	        service.deleteAddress(addrId);

		} catch (Exception e) {
			e.printStackTrace();
		}

		// 삭제 후 목록으로 리다이렉트
		return new ModelAndView("redirect:/member/mypage/addr");
	}
	
	@GetMapping("membership")
	public ModelAndView membership(HttpServletRequest req, HttpServletResponse resp) {
	    return new ModelAndView("mypage/membership");
	}
}
