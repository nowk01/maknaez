package com.maknaez.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

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
import com.maknaez.util.FileManager;
import com.maknaez.util.MyMultipartFile;

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
			if (dto == null) {
				ModelAndView mav = new ModelAndView("member/login");
				mav.addObject("message", "아이디 또는 패스워드가 일치하지 않습니다.");
				return mav;
			}
			
			dto.setIp_info(req.getRemoteAddr());
			service.insertLoginLog(dto);
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
			if (tel1 != null && !tel1.isEmpty()) {
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
			if (e.getErrorCode() == 1) message = "아이디 중복으로 회원가입이 실패했습니다.";
			else if (e.getErrorCode() == 1400) message = "필수사항을 입력 하지 않았습니다.";
			else message = "회원가입이 실패했습니다....";
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
	public ModelAndView pwdSubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		try {
			MemberDTO dto = service.findByIdx(info.getMemberIdx());
			if (dto == null) {
				session.invalidate();
				return new ModelAndView("redirect:/");
			}

			String userPwd = req.getParameter("userPwd");
			String mode = req.getParameter("mode");

			if (!dto.getUserPwd().equals(userPwd)) {
				ModelAndView mav = new ModelAndView("member/pwd");
				mav.addObject("mode", mode);
				mav.addObject("message", "패스워드가 일치하지 않습니다.");
				return mav;
			}

			if (mode.equals("delete")) {
				session.removeAttribute("member");
				session.invalidate();
			} else if (mode.equals("update")) {
				// ★ 수정 페이지 이동 (MyPageController로 넘기기 위해 리다이렉트가 낫지만, 여기선 View 바로 연결)
				if (dto.getEmail() != null) {
					String[] emails = dto.getEmail().split("@");
					if (emails.length > 0) dto.setEmail1(emails[0]);
					if (emails.length > 1) dto.setEmail2(emails[1]);
				}
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

	@GetMapping("complete")
	public ModelAndView complete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		String mode = (String) session.getAttribute("mode");
		String userName = (String) session.getAttribute("userName");
		session.removeAttribute("mode");
		session.removeAttribute("userName");

		if (mode == null) return new ModelAndView("redirect:/");

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
	public Map<String, Object> userIdCheck(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Map<String, Object> model = new HashMap<String, Object>();
		String userId = req.getParameter("userId");
		MemberDTO dto = service.findById(userId);
		String passed = "false";
		if (dto == null) passed = "true";
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
	public Map<String, Object> deleteProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
}