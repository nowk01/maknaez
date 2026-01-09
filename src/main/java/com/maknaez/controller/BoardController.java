package com.maknaez.controller;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.model.BoardDTO;
import com.maknaez.model.FaqDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
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

    // ==========================================
    // 1:1 문의 (Inquiry)
    // ==========================================
    @GetMapping("list")
    public ModelAndView list(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if(info == null) {
            return new ModelAndView("redirect:/member/login");
        }

        ModelAndView mav = new ModelAndView("cs/inquiry_list");
        
        try {
            String page = req.getParameter("page");
            int current_page = 1;
            if(page != null) current_page = Integer.parseInt(page);
            
            String condition = "all";
            String keyword = req.getParameter("keyword");
            if(keyword == null) keyword = "";
            
            if(req.getMethod().equalsIgnoreCase("GET")) {
                keyword = URLDecoder.decode(keyword, "utf-8");
            }

            Map<String, Object> map = new HashMap<>();
            map.put("condition", condition);
            map.put("keyword", keyword);
            
            int dataCount = service.dataCount(map);
            
            int size = 10;
            int total_page = dataCount / size + (dataCount % size > 0 ? 1 : 0);
            if(current_page > total_page) current_page = total_page;
            
            int offset = (current_page - 1) * size;
            if(offset < 0) offset = 0;
            
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

    @GetMapping("write")
    public ModelAndView writeForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        
        if(info == null) {
            return new ModelAndView("redirect:/member/login");
        }

        return new ModelAndView("cs/inquiry_write");
    }

    @PostMapping("write")
    public ModelAndView writeSubmit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        
        if(info == null) {
            return new ModelAndView("redirect:/member/login");
        }

        String root = session.getServletContext().getRealPath("/");
        String pathname = root + "uploads" + File.separator + "cs";
        File f = new File(pathname);
        if(!f.exists()) f.mkdirs();

        try {
            BoardDTO dto = new BoardDTO();
            
            dto.setUserId(info.getUserId());
            dto.setUserName(info.getUserName());
            dto.setSubject(req.getParameter("subject"));
            dto.setContent(req.getParameter("content"));
            
            Part p = req.getPart("selectFile");
            if(p != null && p.getSize() > 0) {
                MyMultipartFile mp = fileManager.doFileUpload(p, pathname);
                if(mp != null) {
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
        if(info == null) {
            return new ModelAndView("redirect:/member/login");
        }

        String page = req.getParameter("page");
        String keyword = req.getParameter("keyword");
        
        if(page == null) page = "1";
        if(keyword == null) keyword = "";
        
        String query = "page=" + page;
        if(keyword.length() != 0) {
            query += "&keyword=" + URLEncoder.encode(keyword, "utf-8");
        }
        
        try {
            long num = Long.parseLong(req.getParameter("num"));
            
            service.updateHitCount(num);
            
            BoardDTO dto = service.findById(num);
            
            if(dto == null) {
                return new ModelAndView("redirect:/cs/list?" + query);
            }
            
            dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
            
            if(dto.getReplyContent() != null) {
                dto.setReplyContent(dto.getReplyContent().replaceAll("\n", "<br>"));
            }
            
            Map<String, Object> map = new HashMap<>();
            map.put("num", num);
            map.put("keyword", keyword);
            
            BoardDTO prevDto = service.findByPrev(map);
            BoardDTO nextDto = service.findByNext(map);
            
            ModelAndView mav = new ModelAndView("cs/inqurity_article");
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
    
    @GetMapping("download")
    public void download(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String root = session.getServletContext().getRealPath("/");
        String pathname = root + "uploads" + File.separator + "cs";
        
        try {
            long num = Long.parseLong(req.getParameter("num"));
            BoardDTO dto = service.findById(num);
            
            if(dto != null) {
                boolean b = fileManager.doFiledownload(dto.getSaveFilename(), dto.getOriginalFilename(), pathname, resp);
                if(!b) {
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
        if(info == null) {
            return new ModelAndView("redirect:/member/login");
        }
        
        String page = req.getParameter("page");
        String query = "page=" + page;
        
        try {
            long num = Long.parseLong(req.getParameter("num"));
            service.deleteBoard(num);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return new ModelAndView("redirect:/cs/list?" + query);
    }

    // ==========================================
    // 공지사항 (Notice) - [수정됨] 파라미터 resp 추가
    // ==========================================
    @GetMapping("notice")
    public ModelAndView notice(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ModelAndView mav = new ModelAndView("cs/notice_list");
        
        try {
            String page = req.getParameter("page");
            int current_page = 1;
            if(page != null) current_page = Integer.parseInt(page);
            
            String keyword = req.getParameter("keyword");
            if(keyword == null) keyword = "";

            Map<String, Object> map = new HashMap<>();
            map.put("keyword", keyword);
            map.put("isShow", 1); 
            
            int dataCount = service.dataCountNotice(map);
            
            int size = 10;
            int total_page = dataCount / size + (dataCount % size > 0 ? 1 : 0);
            if(current_page > total_page) current_page = total_page;
            int offset = (current_page - 1) * size;
            
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

    // [수정됨] 파라미터 resp 추가
    @GetMapping("notice/article")
    public ModelAndView noticeArticle(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ModelAndView mav = new ModelAndView("cs/notice_article");
        
        try {
            long num = Long.parseLong(req.getParameter("num"));
            String page = req.getParameter("page");
            
            BoardDTO dto = service.findByIdNotice(num);
            if(dto != null) {
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
    // FAQ - [수정됨] 파라미터 resp 추가
    // ==========================================
    @GetMapping("faq")
    public ModelAndView faq(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ModelAndView mav = new ModelAndView("cs/faq");
        
        try {
            String category = req.getParameter("category");
            if(category == null) category = "all";
            
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