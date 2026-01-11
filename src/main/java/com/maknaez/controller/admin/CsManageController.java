package com.maknaez.controller.admin;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.maknaez.model.BoardDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.BoardService;
import com.maknaez.service.BoardServiceImpl;
import com.maknaez.util.FileManager;
import com.maknaez.util.MyMultipartFile;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@Controller
@RequestMapping("/admin/cs/*")
public class CsManageController {
	private BoardService service = new BoardServiceImpl();
	private FileManager fileManager = new FileManager();

	// 1:1 문의 리스트
	@GetMapping("inquiry_list")
	public ModelAndView inquiryList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/cs/inquiry_list");

		try {
			String status = req.getParameter("status"); // all, wait, done
			String keyword = req.getParameter("keyword");
			if (status == null)
				status = "all";
			if (keyword == null)
				keyword = "";

			if (req.getMethod().equalsIgnoreCase("GET")) {
				keyword = URLDecoder.decode(keyword, "utf-8");
			}

			Map<String, Object> map = new HashMap<>();
			map.put("status", status);
			map.put("keyword", keyword);
			map.put("offset", 0);
			map.put("size", 100);

			List<BoardDTO> list = service.listBoard(map);

			mav.addObject("list", list);
			mav.addObject("status", status);
			mav.addObject("keyword", keyword);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	// 1:1 문의 상세 (AJAX)
	@ResponseBody
	@GetMapping("inquiry_detail")
	public void inquiryDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		resp.setContentType("application/json; charset=utf-8");
		JSONObject jobj = new JSONObject();

		try {
			if (info == null || info.getUserLevel() < 51) {
				jobj.put("status", "permission_denied");
				resp.getWriter().print(jobj.toString());
				return;
			}

			long num = Long.parseLong(req.getParameter("num"));
			BoardDTO dto = service.findById(num);

			if (dto != null) {
				jobj.put("status", "success");
				jobj.put("num", dto.getNum());
				jobj.put("subject", dto.getSubject());
				jobj.put("content", dto.getContent());
				jobj.put("userName", dto.getUserName());
				jobj.put("reg_date", dto.getReg_date());
				jobj.put("replyContent", dto.getReplyContent());
				jobj.put("replyDate", dto.getReplyDate());
			} else {
				jobj.put("status", "fail");
			}
		} catch (Exception e) {
			jobj.put("status", "error");
		}

		PrintWriter out = resp.getWriter();
		out.print(jobj.toString());
	}

	// 1:1 문의 답변 등록 (AJAX)
	@ResponseBody
	@PostMapping("inquiry_reply")
	public void inquiryReply(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		resp.setContentType("application/json; charset=utf-8");
		JSONObject jobj = new JSONObject();

		try {
			BoardDTO dto = new BoardDTO();
			dto.setNum(Long.parseLong(req.getParameter("num")));
			dto.setReplyContent(req.getParameter("replyContent"));
			dto.setReplyId(info.getUserId());

			service.updateBoardReply(dto);

			jobj.put("status", "success");
		} catch (Exception e) {
			e.printStackTrace();
			jobj.put("status", "error");
		}

		PrintWriter out = resp.getWriter();
		out.print(jobj.toString());
	}

	// 공지사항 리스트
	@GetMapping("notice_list")
	public ModelAndView noticeList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/cs/notice_list");

		try {
			String page = req.getParameter("page");
			int current_page = 1;
			if (page != null)
				current_page = Integer.parseInt(page);

			String condition = req.getParameter("condition");
			String keyword = req.getParameter("keyword");
			if (condition == null)
				condition = "all";
			if (keyword == null)
				keyword = "";

			if (req.getMethod().equalsIgnoreCase("GET")) {
				keyword = URLDecoder.decode(keyword, "utf-8");
			}

			Map<String, Object> map = new HashMap<>();
			map.put("condition", condition);
			map.put("keyword", keyword);

			int dataCount = service.dataCountNotice(map);
			int size = 10;
			int total_page = dataCount / size + (dataCount % size > 0 ? 1 : 0);
			if (current_page > total_page)
				current_page = total_page;

			int offset = (current_page - 1) * size;
			if (offset < 0)
				offset = 0;

			map.put("offset", offset);
			map.put("size", size);

			List<BoardDTO> list = service.listNotice(map);

			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			mav.addObject("page", current_page);
			mav.addObject("total_page", total_page);
			mav.addObject("condition", condition);
			mav.addObject("keyword", keyword);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	// 공지사항 작성 폼
	@GetMapping("notice_write")
	public ModelAndView noticeWriteForm(HttpServletRequest req) {
		return new ModelAndView("admin/cs/notice_write");
	}

	// 공지사항 등록 처리
	@PostMapping("notice_write")
	public ModelAndView noticeWriteSubmit(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "notice";
		File f = new File(pathname);
		if (!f.exists())
			f.mkdirs();

		try {
			BoardDTO dto = new BoardDTO();
			dto.setUserName(info.getUserName());
			dto.setSubject(req.getParameter("subject"));
			dto.setContent(req.getParameter("content"));
			dto.setIsNotice(req.getParameter("isNotice") != null ? 1 : 0);
			dto.setIsShow(req.getParameter("isShow") != null ? 1 : 0);

			Part p = req.getPart("selectFile");
			if (p != null && p.getSize() > 0) {
				MyMultipartFile mp = fileManager.doFileUpload(p, pathname);
				if (mp != null) {
					dto.setSaveFilename(mp.getSaveFilename());
					dto.setOriginalFilename(mp.getOriginalFilename());
				}
			}

			service.insertNotice(dto);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return new ModelAndView("redirect:/admin/cs/notice_list");
	}

	// 공지사항 삭제
	@GetMapping("notice_delete")
	public ModelAndView noticeDelete(HttpServletRequest req) {
		try {
			long num = Long.parseLong(req.getParameter("num"));
			service.deleteNotice(num);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("redirect:/admin/cs/notice_list");
	}

	// 아래 메서드들을 컨트롤러 클래스 내부에 추가하세요.

	// 리뷰 관리 리스트 페이지
	@GetMapping("review_list")
	public ModelAndView reviewList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// 1:1 문의와 통일감을 주기 위해 inquiry_list와 유사한 구조로 생성
		ModelAndView mav = new ModelAndView("admin/cs/review_list");

		try {
			String score = req.getParameter("score");
			String keyword = req.getParameter("keyword");
			if (score == null)
				score = "0";
			if (keyword == null)
				keyword = "";

			Map<String, Object> map = new HashMap<>();
			map.put("score", Integer.parseInt(score));
			map.put("keyword", keyword);

			// TODO: BoardService에 listReview 메서드 구현 필요
			// List<BoardDTO> list = service.listReview(map);
			// mav.addObject("list", list);
			mav.addObject("score", score);
			mav.addObject("keyword", keyword);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	// 리뷰 상세 데이터 가져오기 (AJAX)
	@ResponseBody
	@GetMapping("review_detail")
	public void reviewDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("application/json; charset=utf-8");
		JSONObject jobj = new JSONObject();
		try {
			long num = Long.parseLong(req.getParameter("num"));
			// TODO: service.findReviewById(num) 구현 필요
			// BoardDTO dto = service.findReviewById(num);

			// 예시 데이터 (테스트용)
			jobj.put("status", "success");
			jobj.put("productName", "상품명 예시");
			jobj.put("userName", "홍길동");
			jobj.put("score", 5);
			jobj.put("content", "리뷰 내용 예시");
			jobj.put("reg_date", "2026-01-11");

		} catch (Exception e) {
			jobj.put("status", "error");
		}
		resp.getWriter().print(jobj.toString());
	}
}