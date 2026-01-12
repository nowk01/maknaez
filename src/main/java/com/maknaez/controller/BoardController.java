package com.maknaez.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import com.maknaez.model.BoardDTO;
import com.maknaez.model.FaqDTO;
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
@RequestMapping("/cs/*")
public class BoardController {
	private BoardService service = new BoardServiceImpl();
	private FileManager fileManager = new FileManager();

	@GetMapping("list")
	public ModelAndView list(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		ModelAndView mav = new ModelAndView("cs/inquiry_list");

		try {
			// [수정] 페이지 번호 파라미터 처리 및 offset 계산 적용
			String pageStr = req.getParameter("page");
			int current_page = (pageStr != null) ? Integer.parseInt(pageStr) : 1;
			int size = 10;
			int offset = (current_page - 1) * size;

			String condition = "all";
			String keyword = req.getParameter("keyword");
			if (keyword == null)
				keyword = "";

			if (req.getMethod().equalsIgnoreCase("GET") && !keyword.isEmpty()) {
				keyword = URLDecoder.decode(keyword, "utf-8");
			}

			Map<String, Object> map = new HashMap<>();
			map.put("condition", condition);
			map.put("keyword", keyword);
			map.put("userId", info.getUserId());

			int dataCount = service.dataCount(map);
			int total_page = dataCount / size + (dataCount % size > 0 ? 1 : 0);

			map.put("offset", offset);
			map.put("size", size);

			List<BoardDTO> list = service.listBoard(map);

			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			mav.addObject("page", current_page);
			mav.addObject("total_page", total_page);
			mav.addObject("keyword", keyword);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	// ==========================================
	// [AJAX] 무한 스크롤용 데이터 반환
	// ==========================================
	@ResponseBody
	@GetMapping("listData")
	public void listData(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		resp.setContentType("application/json; charset=utf-8");
		JSONObject jobj = new JSONObject();

		if (info == null) {
			jobj.put("status", "login_required");
			resp.getWriter().print(jobj.toString());
			return;
		}

		try {
			String pageStr = req.getParameter("page");
			int page = (pageStr != null) ? Integer.parseInt(pageStr) : 1;

			int size = 10;
			int offset = (page - 1) * size;

			Map<String, Object> map = new HashMap<>();
			map.put("condition", "all");
			map.put("keyword", "");
			map.put("userId", info.getUserId());
			map.put("offset", offset);
			map.put("size", size);

			List<BoardDTO> list = service.listBoard(map);

			JSONArray jarr = new JSONArray();
			for (BoardDTO dto : list) {
				JSONObject jo = new JSONObject();
				jo.put("num", dto.getNum());
				jo.put("subject", dto.getSubject());
				jo.put("userName", dto.getUserName());
				jo.put("reg_date", dto.getReg_date().substring(0, 10));

				// [핵심수정] isEmpty() 호출 제거하여 NullPointerException 방지
				boolean isAnswered = (dto.getReplyDate() != null && !dto.getReplyDate().equals(""));
				jo.put("isAnswered", isAnswered);

				// 미리보기용 content 추가
				jo.put("content", dto.getContent());

				jarr.put(jo);
			}

			jobj.put("status", "success");
			jobj.put("list", jarr);

		} catch (Exception e) {
			e.printStackTrace();
			jobj.put("status", "error");
		}

		PrintWriter out = resp.getWriter();
		out.print(jobj.toString());
	}

	@GetMapping("write")
	public ModelAndView writeForm(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		return new ModelAndView("cs/inquiry_write");
	}

	@PostMapping("write")
	public ModelAndView writeSubmit(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "cs";
		File f = new File(pathname);
		if (!f.exists())
			f.mkdirs();

		try {
			BoardDTO dto = new BoardDTO();

			dto.setUserId(info.getUserId());
			dto.setUserName(info.getUserName());
			dto.setSubject(req.getParameter("subject"));
			dto.setContent(req.getParameter("content"));

			Part p = req.getPart("selectFile");
			if (p != null && p.getSize() > 0) {
				MyMultipartFile mp = fileManager.doFileUpload(p, pathname);
				if (mp != null) {
					dto.setSaveFilename(mp.getSaveFilename());
					dto.setOriginalFilename(mp.getOriginalFilename());
				}
			}

			service.insertBoard(dto);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return new ModelAndView("redirect:/cs/list");
	}

	@GetMapping("article")
	public ModelAndView article(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		String page = req.getParameter("page");
		String keyword = req.getParameter("keyword");

		if (page == null)
			page = "1";
		if (keyword == null)
			keyword = "";

		String query = "page=" + page;
		if (keyword.length() != 0) {
			query += "&keyword=" + URLEncoder.encode(keyword, "utf-8");
		}

		try {
			long num = Long.parseLong(req.getParameter("num"));

			service.updateHitCount(num);

			BoardDTO dto = service.findById(num);

			if (dto == null) {
				return new ModelAndView("redirect:/cs/list?" + query);
			}

			if (!dto.getUserId().equals(info.getUserId()) && info.getUserLevel() < 51) {
				resp.setContentType("text/html;charset=utf-8");
				PrintWriter out = resp.getWriter();
				out.print("<script>alert('접근 권한이 없습니다.'); location.href='/cs/list';</script>");
				return null;
			}

			dto.setContent(dto.getContent().replaceAll("\n", "<br>"));

			if (dto.getReplyContent() != null) {
				dto.setReplyContent(dto.getReplyContent().replaceAll("\n", "<br>"));
			}

			Map<String, Object> map = new HashMap<>();
			map.put("num", num);
			map.put("keyword", keyword);
			map.put("userId", info.getUserId());

			BoardDTO prevDto = service.findByPrev(map);
			BoardDTO nextDto = service.findByNext(map);

			ModelAndView mav = new ModelAndView("cs/inquiry_article");
			mav.addObject("dto", dto);
			mav.addObject("prevDto", prevDto);
			mav.addObject("nextDto", nextDto);
			mav.addObject("page", page);
			mav.addObject("query", query);

			return mav;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return new ModelAndView("redirect:/cs/list?" + query);
	}

	@ResponseBody
	@GetMapping("detailData")
	public void detailData(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		resp.setContentType("application/json; charset=utf-8");
		JSONObject jobj = new JSONObject();

		if (info == null || info.getUserLevel() < 51) {
			jobj.put("status", "permission_denied");
			resp.getWriter().print(jobj.toString());
			return;
		}

		try {
			long num = Long.parseLong(req.getParameter("num"));

			BoardDTO dto = service.findById(num);

			if (dto != null) {
				jobj.put("status", "success");
				jobj.put("num", dto.getNum());
				jobj.put("subject", dto.getSubject());
				jobj.put("content", dto.getContent());
				jobj.put("userId", dto.getUserId());
				jobj.put("userName", dto.getUserName());
				jobj.put("reg_date", dto.getReg_date());

				if (dto.getOriginalFilename() != null) {
					jobj.put("originalFilename", dto.getOriginalFilename());
					jobj.put("saveFilename", dto.getSaveFilename());
				}

				boolean isAnswered = (dto.getReplyDate() != null && !dto.getReplyDate().equals(""));
				jobj.put("isAnswered", isAnswered);
				if (isAnswered) {
					jobj.put("replyContent", dto.getReplyContent());
					jobj.put("replyDate", dto.getReplyDate());
				}
			} else {
				jobj.put("status", "not_found");
			}

		} catch (Exception e) {
			e.printStackTrace();
			jobj.put("status", "error");
		}

		PrintWriter out = resp.getWriter();
		out.print(jobj.toString());
	}

	@GetMapping("download")
	public void download(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "cs";

		try {
			long num = Long.parseLong(req.getParameter("num"));
			BoardDTO dto = service.findById(num);

			if (dto != null) {
				boolean b = fileManager.doFiledownload(dto.getSaveFilename(), dto.getOriginalFilename(), pathname,
						resp);
				if (!b) {
					resp.setContentType("text/html;charset=utf-8");
					resp.getWriter().print("<script>alert('파일을 다운로드 할 수 없습니다.');history.back();</script>");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@GetMapping("delete")
	public ModelAndView delete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		try {
			long num = Long.parseLong(req.getParameter("num"));
			service.deleteBoard(num);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return new ModelAndView("redirect:/cs/list");
	}

	// ==========================================
	// 공지사항 (Notice)
	// ==========================================
	@GetMapping("notice")
	public ModelAndView notice(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("cs/notice_list");

		try {
			String page = req.getParameter("page");
			int current_page = 1;
			if (page != null)
				current_page = Integer.parseInt(page);

			String keyword = req.getParameter("keyword");
			if (keyword == null)
				keyword = "";

			Map<String, Object> map = new HashMap<>();
			map.put("keyword", keyword);
			map.put("isShow", 1);

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
			mav.addObject("keyword", keyword);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	@GetMapping("notice/article")
	public ModelAndView noticeArticle(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("cs/notice_article");

		try {
			long num = Long.parseLong(req.getParameter("num"));
			String page = req.getParameter("page");

			BoardDTO dto = service.findByIdNotice(num);
			if (dto != null) {
				dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
			}

			mav.addObject("dto", dto);
			mav.addObject("page", page);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	// ==========================================
	// FAQ
	// ==========================================
	@GetMapping("faq")
	public ModelAndView faq(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("cs/faq");

		try {
			String category = req.getParameter("category");
			if (category == null)
				category = "all";

			Map<String, Object> map = new HashMap<>();
			map.put("category", category);

			List<FaqDTO> list = service.listFaq(map);

			mav.addObject("list", list);
			mav.addObject("category", category);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}
}