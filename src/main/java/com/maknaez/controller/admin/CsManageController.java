package com.maknaez.controller.admin;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.maknaez.model.BoardDTO;
import com.maknaez.model.ReviewDTO; // 추가
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.BoardService;
import com.maknaez.service.BoardServiceImpl;
import com.maknaez.service.ReviewService; // 추가
import com.maknaez.service.ReviewServiceImpl; // 추가
import com.maknaez.util.FileManager;
import com.maknaez.util.MyMultipartFile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@MultipartConfig
@Controller
@RequestMapping("/admin/cs/*")
public class CsManageController {
	private BoardService service = new BoardServiceImpl();
	private FileManager fileManager = new FileManager();
	private ReviewService reviewService = new ReviewServiceImpl();

	// 1:1 문의 리스트
	@GetMapping("inquiry_list")
	public ModelAndView inquiryList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/cs/inquiry_list");

		try {
			String status = req.getParameter("status");
			String keyword = req.getParameter("keyword");
			if (status == null)
				status = "all";
			if (keyword == null)
				keyword = "";

			if (req.getMethod().equalsIgnoreCase("GET") && !keyword.isEmpty()) {
				keyword = URLDecoder.decode(keyword, "utf-8");
			}

			Map<String, Object> map = new HashMap<>();
			map.put("status", "all");
			map.put("keyword", keyword);
			map.put("condition", "all");
			map.put("offset", 0);
			map.put("size", 1000);

			map.put("userId", "");

			List<BoardDTO> list = service.listBoard(map);

			mav.addObject("list", list);
			mav.addObject("status", status);
			mav.addObject("keyword", keyword);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	// 1:1 문의 상세
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
				jobj.put("userId", dto.getUserId());
				jobj.put("reg_date", dto.getReg_date());

				jobj.put("replyContent", dto.getReplyContent() != null ? dto.getReplyContent() : "");
				jobj.put("replyDate", dto.getReplyDate() != null ? dto.getReplyDate() : "");
				jobj.put("saveFilename", dto.getSaveFilename() != null ? dto.getSaveFilename() : "");
				jobj.put("originalFilename", dto.getOriginalFilename() != null ? dto.getOriginalFilename() : "");
			} else {
				jobj.put("status", "fail");
			}
		} catch (Exception e) {
			jobj.put("status", "error");
		}

		PrintWriter out = resp.getWriter();
		out.print(jobj.toString());
	}

	// 1:1 문의 답변 등록
	@ResponseBody
	@PostMapping("inquiry_reply")
	public void inquiryReply(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

			BoardDTO dto = new BoardDTO();
			dto.setNum(Long.parseLong(req.getParameter("num")));
			dto.setReplyContent(req.getParameter("replyContent"));
			dto.setReplyId(info.getUserId()); // 답변자(관리자) ID 저장

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
			int current_page = (page != null) ? Integer.parseInt(page) : 1;
			
			String schType = req.getParameter("schType");
	        String kwd = req.getParameter("kwd");
	        
	        if (schType == null) schType = "all";
	        if (kwd == null) kwd = "";

			String condition = req.getParameter("condition");
			String keyword = req.getParameter("keyword");
			if (condition == null)
				condition = "all";
			if (keyword == null)
				keyword = "";

			if (req.getMethod().equalsIgnoreCase("GET") && !keyword.isEmpty()) {
				keyword = URLDecoder.decode(keyword, "utf-8");
			}

			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
	        map.put("kwd", kwd);
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
			mav.addObject("schType", schType);
	        mav.addObject("kwd", kwd);
	        
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	@GetMapping("notice_write")
	public ModelAndView noticeWriteForm(HttpServletRequest req, HttpServletResponse resp) {
		return new ModelAndView("admin/cs/notice_write");
	}

	@PostMapping("notice_write")
	public ModelAndView noticeWriteSubmit(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		if (info == null) {
			return new ModelAndView("redirect:/admin/login");
		}
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "notice";

		try {
			File f = new File(pathname);
			if (!f.exists()) {
				f.mkdirs();
			}

			BoardDTO dto = new BoardDTO();
			dto.setUserName(info.getUserName());
			dto.setSubject(req.getParameter("subject"));
			dto.setContent(req.getParameter("content"));
			dto.setIsNotice(req.getParameter("isNotice") != null ? 1 : 0);
			dto.setIsShow(req.getParameter("isShow") != null ? 1 : 0);

			try {
				Part p = req.getPart("selectFile");
				if (p != null && p.getSize() > 0) {
					MyMultipartFile mp = fileManager.doFileUpload(p, pathname);
					if (mp != null) {
						dto.setSaveFilename(mp.getSaveFilename());
						dto.setOriginalFilename(mp.getOriginalFilename());
					}
				}
			} catch (Exception fe) {
				System.out.println("파일 업로드 중 오류 발생 (무시하고 진행): " + fe.getMessage());
			}

			service.insertNotice(dto);

		} catch (Exception e) {
			System.out.println("공지사항 등록에 오류가 발생하였습니다.");
			e.printStackTrace();
		}

		return new ModelAndView("redirect:/admin/cs/notice_list");
	}

	@GetMapping("notice_article")
	public ModelAndView noticeArticle(HttpServletRequest req, HttpServletResponse resp) {
		String numStr = req.getParameter("num");
		HttpSession session = req.getSession();

		if (numStr == null || numStr.isEmpty()) {
			return new ModelAndView("redirect:/admin/cs/notice_list");
		}

		try {
			long num = Long.parseLong(numStr);

			@SuppressWarnings("unchecked")
			List<Long> readList = (List<Long>) session.getAttribute("readNoticeList");
			if (readList == null) {
				readList = new ArrayList<>();
			}

			if (!readList.contains(num)) {
				readList.add(num);
				session.setAttribute("readNoticeList", readList);
			}

			BoardDTO dto = service.findByIdNotice(num);

			if (dto == null) {
				return new ModelAndView("redirect:/admin/cs/notice_list");
			}

			ModelAndView mav = new ModelAndView("admin/cs/notice_article");
			mav.addObject("dto", dto);

			mav.addObject("query", req.getQueryString());

			return mav;

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("redirect:/admin/cs/notice_list");
		}
	}

	// 공지사항 삭제
	@GetMapping("notice_delete")
	public ModelAndView noticeDelete(HttpServletRequest req, HttpServletResponse resp) {
		try {
			long num = Long.parseLong(req.getParameter("num"));
			service.deleteNotice(num);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("redirect:/admin/cs/notice_list");
	}

	@GetMapping("review_list")
	public ModelAndView reviewList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/cs/review_list");

		try {
			String page = req.getParameter("page");
			int current_page = 1;
			if (page != null) {
				current_page = Integer.parseInt(page);
			}

			String sort = req.getParameter("sort"); // latest(기본), score
			String keyword = req.getParameter("keyword");
			int score = 0;

			if (req.getParameter("score") != null && !req.getParameter("score").equals("0")) {
				try {
					score = Integer.parseInt(req.getParameter("score"));
				} catch (NumberFormatException e) {
				}
			}

			if (sort == null)
				sort = "latest";
			if (keyword == null)
				keyword = "";

			if (req.getMethod().equalsIgnoreCase("GET") && !keyword.isEmpty()) {
				keyword = URLDecoder.decode(keyword, "utf-8");
			}

			Map<String, Object> map = new HashMap<>();
			map.put("sort", sort);
			map.put("keyword", keyword);
			map.put("score", score);

			int dataCount = reviewService.dataCountAdmin(map);
			int size = 10;
			int total_page = dataCount / size + (dataCount % size > 0 ? 1 : 0);
			if (current_page > total_page)
				current_page = total_page;

			int offset = (current_page - 1) * size;
			if (offset < 0)
				offset = 0;

			map.put("start", offset + 1);
			map.put("end", offset + size);

			List<ReviewDTO> list = reviewService.listReviewAdmin(map);

			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			mav.addObject("page", current_page);
			mav.addObject("total_page", total_page);
			mav.addObject("sort", sort);
			mav.addObject("keyword", keyword);
			mav.addObject("score", score);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	@ResponseBody
	@GetMapping("review_detail")
	public void reviewDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setContentType("application/json; charset=utf-8");
		JSONObject jobj = new JSONObject();

		try {
			HttpSession session = req.getSession();
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if (info == null || info.getUserLevel() < 51) {
				jobj.put("status", "permission_denied");
				resp.getWriter().print(jobj.toString());
				return;
			}

			long reviewId = Long.parseLong(req.getParameter("reviewId"));

			ReviewDTO dto = reviewService.findById(reviewId);

			if (dto != null) {
				jobj.put("status", "success");
				jobj.put("reviewId", dto.getReviewId());
				jobj.put("productName", dto.getProductName());
				jobj.put("userName", dto.getWriterName());
				jobj.put("userId", dto.getWriterId());
				jobj.put("score", dto.getStarRating());
				jobj.put("content", dto.getContent());
				jobj.put("reg_date", dto.getRegDate());
				jobj.put("reviewImg", dto.getReviewImg() != null ? dto.getReviewImg() : "");
				jobj.put("optionValue", dto.getOptionValue());

			} else {
				jobj.put("status", "fail");
			}
		} catch (Exception e) {
			e.printStackTrace();
			jobj.put("status", "error");
		}
		resp.getWriter().print(jobj.toString());
	}

	@ResponseBody
	@PostMapping("review_reply")
	public void reviewReply(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		resp.setContentType("application/json; charset=utf-8");
		JSONObject jobj = new JSONObject();

		try {
			HttpSession session = req.getSession();
			SessionInfo info = (SessionInfo) session.getAttribute("member");

			if (info == null || info.getUserLevel() < 51) {
				jobj.put("status", "permission_denied");
				resp.getWriter().print(jobj.toString());
				return;
			}

			long reviewId = Long.parseLong(req.getParameter("reviewId"));
			String replyContent = req.getParameter("replyContent");

			reviewService.updateReply(reviewId, replyContent);

			jobj.put("status", "success");

		} catch (Exception e) {
			e.printStackTrace();
			jobj.put("status", "error");
		}
		resp.getWriter().print(jobj.toString());
	}

	@GetMapping("review_delete")
	public ModelAndView reviewDelete(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		try {
			HttpSession session = req.getSession();
			SessionInfo info = (SessionInfo) session.getAttribute("member");

			if (info == null || info.getUserLevel() < 51) {
				return new ModelAndView("redirect:/admin/login");
			}

			long reviewId = Long.parseLong(req.getParameter("reviewId"));
			reviewService.deleteReview(reviewId);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("redirect:/admin/cs/review_list");
	}

	@ResponseBody
	@PostMapping("review_status")
	public void reviewStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	    resp.setContentType("application/json; charset=utf-8");
	    JSONObject jobj = new JSONObject();

	    try {
	        HttpSession session = req.getSession();
	        SessionInfo info = (SessionInfo) session.getAttribute("member");
	        // 관리자 권한 체크
	        if (info == null || info.getUserLevel() < 51) {
	            jobj.put("status", "permission_denied");
	            resp.getWriter().print(jobj.toString());
	            return;
	        }

	        long reviewId = Long.parseLong(req.getParameter("reviewId"));
	        
	        int enabled = Integer.parseInt(req.getParameter("enabled"));

	        reviewService.updateReviewStatus(reviewId, enabled);

	        jobj.put("status", "success");
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        jobj.put("status", "error");
	    }
	    resp.getWriter().print(jobj.toString());
	}
}