package com.maknaez.controller.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.maknaez.model.MemberDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.MemberService;
import com.maknaez.service.MemberServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminLoginController {
	private MemberService service = new MemberServiceImpl();

	// 관리자 로그인 화면 (주소: /admin/login)
	@GetMapping("/login")
	public ModelAndView loginForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		// 이미 관리자로 로그인 상태라면 관리자 메인으로 이동
		// HomeManageController가 @RequestMapping("/admin")을 담당하므로 '/admin'으로 보내야 함
		if(info != null && info.getUserLevel() > 50) {
			return new ModelAndView("redirect:/admin");
		}
		
		return new ModelAndView("admin/login/login");
	}

	@PostMapping("/login")
	public ModelAndView loginSubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();

		try {
			String userId = req.getParameter("userId");
			String userPwd = req.getParameter("userPwd");

			Map<String, Object> map = new HashMap<>();
			map.put("userId", userId);
			map.put("userPwd", userPwd);

			MemberDTO dto = service.loginMember(map);

			// 1. 아이디/비번 불일치
			if (dto == null) {
				ModelAndView mav = new ModelAndView("admin/login/login");
				mav.addObject("message", "아이디 또는 패스워드가 일치하지 않습니다.");
				return mav;
			}

			// 2. 권한 체크 (레벨 51 미만은 접근 불가)
			if (dto.getUserLevel() < 51) {
				ModelAndView mav = new ModelAndView("admin/login/login");
				mav.addObject("message", "관리자 권한이 없는 계정입니다.");
				return mav;
			}

			// 3. 로그인 성공 및 세션 저장
			session.setMaxInactiveInterval(60 * 60); // 60분 유지

			SessionInfo info = new SessionInfo();
			info.setMemberIdx(dto.getMemberIdx());
			info.setUserId(dto.getUserId());
			info.setUserName(dto.getUserName());
			// DTO 필드명에 따라 getProfile_photo() 혹은 getProfilePhoto() 확인 필요
			info.setAvatar(dto.getProfile_photo()); 
			info.setUserLevel(dto.getUserLevel());

			session.setAttribute("member", info);

			// 4. 로그인 후 이동할 페이지 결정 (LoginFilter와 연동)
			// 필터가 저장해둔 주소가 있으면 거기로, 없으면 관리자 메인으로 이동
			String uri = (String) session.getAttribute("preLoginURI");
			session.removeAttribute("preLoginURI"); // 한 번 썼으면 세션에서 지워주기

			if (uri == null || uri.trim().isEmpty()) {
				uri = "redirect:/admin"; // 기본값: 관리자 메인
			}

			return new ModelAndView(uri);

		} catch (Exception e) {
			e.printStackTrace();
		}

		// 오류 발생 시 다시 로그인 페이지로
		return new ModelAndView("redirect:/admin/login");
	}
}