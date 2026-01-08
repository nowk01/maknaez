package com.maknaez.controller;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.maknaez.util.FileManager;
import com.maknaez.util.MyMultipartFile;
import com.maknaez.model.MemberDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
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
		// 약관 동의 폼
			throws ServletException, IOException {

			return new ModelAndView("member/consent");
	}
	
	// @RequestMapping(value = "login", method = RequestMethod.GET)
	@GetMapping("login")
	public ModelAndView loginForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 로그인 폼
		return new ModelAndView("member/login");
	}
	
	@GetMapping("mypage/main.do")
	public ModelAndView myPageMain(HttpServletRequest req, HttpServletResponse resp) {
        ModelAndView mav = new ModelAndView("mypage/myMain");
        return mav;
    }

	// @RequestMapping(value = "login", method = RequestMethod.POST)
	@PostMapping("login")
	public ModelAndView loginSubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 로그인 처리
		// 세션객체. 세션 정보는 서버에 저장(로그인 정보, 권한등을 저장)
		HttpSession session = req.getSession();
		
		try {
			String userId = req.getParameter("userId");
			String userPwd = req.getParameter("userPwd");

			Map<String, Object> map = new HashMap<>();
			map.put("userId", userId);
			map.put("userPwd", userPwd);
			
			MemberDTO dto = service.loginMember(map);
			
			if(dto == null) {
				// 로그인 실패인 경우
				ModelAndView mav = new ModelAndView("member/login");
				
				String msg = "아이디 또는 패스워드가 일치하지 않습니다.";
				mav.addObject("message", msg);

				return mav;
			}
			
			// 로그인 성공 : 로그인정보를 서버에 저장
			// 세션의 유지시간을 20분설정(기본 30분)
			session.setMaxInactiveInterval(20 * 60);

			// 세션에 저장할 내용
			SessionInfo info = new SessionInfo();
			info.setMemberIdx(dto.getMemberIdx());
			info.setUserId(dto.getUserId());
			info.setUserName(dto.getUserName());
			info.setAvatar(dto.getProfile_photo());
			info.setUserLevel(dto.getUserLevel());

			// 세션에 member이라는 이름으로 저장
			session.setAttribute("member", info);

			String preLoginURI = (String)session.getAttribute("preLoginURI");
			session.removeAttribute("preLoginURI");
			if(preLoginURI != null) {
				// 로그인 전페이지로 리다이렉트
				return new ModelAndView(preLoginURI);
			} 
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		
		return new ModelAndView("redirect:/member/mypage/main.do");
	}
	
	@GetMapping("logout")
	public ModelAndView logout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 로그아웃
		HttpSession session = req.getSession();

		// 세션에 저장된 정보를 지운다.
		session.removeAttribute("member");

		// 세션에 저장된 모든 정보를 지우고 세션을 초기화 한다.
		session.invalidate();
		
		return new ModelAndView("redirect:/");
	}
	
	@GetMapping("noAuthorized")
	public ModelAndView noAuthorized(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 권한이 없는 경우
		return new ModelAndView("member/noAuthorized");
	}
	
	@GetMapping("account")
	public ModelAndView accountForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 회원가입 폼
		ModelAndView mav = new ModelAndView("member/member");
		
		mav.addObject("mode", "account");
		return mav;
	}
	
	@PostMapping("account")
	public ModelAndView accountSubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// 회원 정보 : 정보 저장
		HttpSession session = req.getSession();
		
		// 파일 저장 경로
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
			
			// 파일 업로드
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
				// 2291 : 참조키 위반, 12899 : 폭보다 문장열이 긴 경우
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
		// 패스워드 확인 폼
		ModelAndView mav = new ModelAndView("member/pwd");
		
		String mode = req.getParameter("mode");
		mav.addObject("mode", mode);
		
		return mav;
	}
	
	@PostMapping("pwd")
	public ModelAndView pwdSubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		// 패스워드 확인
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
				// 회원 탈퇴
				
				// profile_photo 삭제
				
				// 테이블에 저장된 회원 정보 삭제
				
				// 세션 정보 지우기
				session.removeAttribute("member");
				session.invalidate();
			} else if(mode.equals("update")) {
				// 회원 정보 수정 폼
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
		// 수정 완료
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
				// 기존 이미지 파일 삭제
				if(dto.getProfile_photo().length() != 0) {
					fileManager.doFiledelete(pathname, dto.getProfile_photo());
				}
				
				// 새로운 이미지
				String filename = mp.getSaveFilename();
				dto.setProfile_photo(filename); 
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
		}else {
			title = "정보수정";
			message += "회원정보가 수정 되었습니다.<br>메인 화면으로 이동하시기 바랍니다.";
		}
		
		ModelAndView mav = new ModelAndView("member/complete");
		
		mav.addObject("title", title);
		mav.addObject("message", message);
		
		return mav;
	}
	
	@ResponseBody // AJAX-JSON : Map을 JSON 형식의 문자열로 반환(없으면 포워딩 됨)
	@PostMapping("userIdCheck")
	public Map<String, Object> userIdCheck(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
		// 아이디 중복 검사
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
		// 사진 삭제
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
			
		}
		
		model.put("state", state);
		
		return model;
	}
}
