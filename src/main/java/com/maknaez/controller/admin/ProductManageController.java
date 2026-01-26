package com.maknaez.controller.admin;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.model.CategoryDTO;
import com.maknaez.model.ProductDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.JsonView;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.ProductService;
import com.maknaez.service.ProductServiceImpl;
import com.maknaez.util.FileManager;
import com.maknaez.util.MyMultipartFile;
import com.maknaez.util.MyUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@Controller
@RequestMapping("/admin/product/*")
public class ProductManageController {
	
	private ProductService service = new ProductServiceImpl();
	private FileManager fileManager = new FileManager();

	@GetMapping("category_manage")
    public ModelAndView categoryManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        return new ModelAndView("admin/product/category_manage");
    }

	@GetMapping("category_list")
    public ModelAndView listCategoryApi(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        List<CategoryDTO> list = service.listCategory();

        ModelAndView mav = new ModelAndView(new JsonView());
        mav.addObject("list", list);

        return mav;
    }
	
	@PostMapping("category_insert")
    public ModelAndView insertCategoryApi(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        CategoryDTO dto = new CategoryDTO();
        dto.setCateName(req.getParameter("cateName"));
        dto.setDepth(Integer.parseInt(req.getParameter("depth")));
        dto.setStatus(Integer.parseInt(req.getParameter("status")));
        dto.setOrderNo(Integer.parseInt(req.getParameter("orderNo")));
        
        String parent = req.getParameter("cateParent");
        if(parent != null && !parent.isEmpty() && !parent.equals("null")) {
            dto.setCateParent(parent);
        }

        service.insertCategory(dto);
        
        ModelAndView mav = new ModelAndView(new JsonView());
        mav.addObject("state", "true");
        
        return mav;
    }
	
	@PostMapping("category_update")
    public ModelAndView updateCategoryApi(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        CategoryDTO dto = new CategoryDTO();
        dto.setOriginCateCode(req.getParameter("originCateCode"));
        dto.setCateCode(req.getParameter("cateCode"));
        dto.setCateName(req.getParameter("cateName"));
        dto.setStatus(Integer.parseInt(req.getParameter("status")));
        dto.setOrderNo(Integer.parseInt(req.getParameter("orderNo")));

        service.updateCategory(dto);

        ModelAndView mav = new ModelAndView(new JsonView());
        mav.addObject("state", "true");
        
        return mav;
    }
	
	@PostMapping("category_delete")
    public ModelAndView deleteCategoryApi(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String cateCode = req.getParameter("cateCode");
        
        ModelAndView mav = new ModelAndView(new JsonView());
        try {
            service.deleteCategory(cateCode);
            mav.addObject("state", "true");
        } catch (Exception e) {
            mav.addObject("state", "false");
            mav.addObject("message", "하위 카테고리가 있거나 삭제할 수 없는 상태입니다.");
        }
        return mav;
    }
	
	@GetMapping("stock_list")
    public String stockList(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		MyUtil myUtil = new MyUtil();
        try {
            String page = req.getParameter("page");
            int current_page = 1;
            if (page != null) current_page = Integer.parseInt(page);

            String cateCode = req.getParameter("cateCode");
            String keyword = req.getParameter("keyword");
            if (cateCode == null) cateCode = "";
            if (keyword == null) keyword = "";

            Map<String, Object> map = new HashMap<>();
            map.put("cateCode", cateCode);
            map.put("keyword", keyword);

            int size = 10;
            int dataCount = service.dataCountStock(map);
            int total_page = myUtil.pageCount(dataCount, size);
            if (current_page > total_page) current_page = total_page;

            int offset = (current_page - 1) * size;
            if(offset < 0) offset = 0;

            map.put("offset", offset);
            map.put("size", size);

            List<ProductDTO> list = service.listStock(map); 
            List<CategoryDTO> categoryList = service.listCategory();

            String cp = req.getContextPath();
            String listUrl = cp + "/admin/product/stock_list";
            
            if (keyword.length() != 0 || cateCode.length() != 0) {
            	String qs = "cateCode=" + cateCode + "&keyword=" + URLEncoder.encode(keyword, "utf-8");
                listUrl += "?" + qs;
            }
            
            String paging = myUtil.paging(current_page, total_page, listUrl);

            req.setAttribute("list", list);
            req.setAttribute("categoryList", categoryList); 
            req.setAttribute("page", current_page);
            req.setAttribute("dataCount", dataCount);
            req.setAttribute("total_page", total_page);
            req.setAttribute("paging", paging);
            req.setAttribute("cateCode", cateCode);
            req.setAttribute("keyword", keyword);

            return "admin/product/stock_list";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/home/main";
        }
    }
	
	@PostMapping("updateStock")
    public void updateStock(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try {
            String[] sOptIds = req.getParameterValues("optIds");
            String[] sProdIds = req.getParameterValues("prodIds");
            String sQty = req.getParameter("qty");
            String reason = req.getParameter("reason");
            
            int qty = Integer.parseInt(sQty);
            
            if(sOptIds != null && sOptIds.length > 0 && sProdIds != null && sProdIds.length == sOptIds.length) {
                long[] optIds = new long[sOptIds.length];
                long[] prodIds = new long[sOptIds.length];
                for(int i=0; i<sOptIds.length; i++) {
                    optIds[i] = Long.parseLong(sOptIds[i]);
                    prodIds[i] = Long.parseLong(sProdIds[i]);
                }
                
                service.updateStock(prodIds, optIds, qty, reason);
            }
            
            resp.setContentType("application/json; charset=utf-8");
            resp.getWriter().print("{\"state\": \"true\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500);
        }
    }
	
	@GetMapping("product_list")
	public String list(HttpServletRequest req, HttpServletResponse resp) throws Exception {
	    MyUtil myUtil = new MyUtil();
	    String cp = req.getContextPath();
	    
	    String page = req.getParameter("page");
	    int current_page = 1;
	    if(page != null) current_page = Integer.parseInt(page);

	    String schType = req.getParameter("schType");
	    String kwd = req.getParameter("kwd");
	    String category = req.getParameter("category");

	    if(schType == null) schType = "all";
	    if(kwd == null) kwd = "";
	    if(category == null) category = "";

	    if(req.getMethod().equalsIgnoreCase("GET")) {
	        kwd = URLDecoder.decode(kwd, "UTF-8");
	    }

	    Map<String, Object> map = new HashMap<>();
	    map.put("schType", schType);
	    map.put("kwd", kwd);
	    map.put("category", category);

	    int dataCount = service.dataCountManage(map);

	    int rows = 10;
	    
	    int total_page = myUtil.pageCount(dataCount, rows);
	    
	    if(current_page > total_page) current_page = total_page;

	    if(current_page < 1) current_page = 1;

	    int start = (current_page - 1) * rows + 1;
	    int end = current_page * rows;
	    map.put("start", start);
	    map.put("end", end);

	    List<ProductDTO> list = service.listProductManage(map);
	    List<CategoryDTO> categoryList = service.listCategory();

	    String query = "schType=" + schType + "&kwd=" + URLEncoder.encode(kwd, "UTF-8") + "&category=" + category;
	    String listUrl = cp + "/admin/product/product_list";
	    
	    if(!query.equals("")) {
	        listUrl += "?" + query;
	    }
	    
	    String paging = myUtil.paging(current_page, total_page, listUrl);

	    req.setAttribute("list", list);
	    req.setAttribute("categoryList", categoryList);
	    req.setAttribute("page", current_page);
	    req.setAttribute("dataCount", dataCount);
	    req.setAttribute("total_page", total_page);
	    req.setAttribute("paging", paging); 
	    req.setAttribute("schType", schType);
	    req.setAttribute("kwd", kwd);
	    req.setAttribute("category", category);

	    return "admin/product/product_list";
	}
	    
	   
	@GetMapping("product_write")
    public String writeForm(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        List<CategoryDTO> categoryList = service.listCategory();
        req.setAttribute("categoryList", categoryList);
        req.setAttribute("mode", "write");
        return "admin/product/product_write";
    }
	
	
	@PostMapping("writeSubmit")
	public String writeSubmit(HttpServletRequest req, HttpServletResponse resp) { 
	    try {
	        HttpSession session = req.getSession(); 
	        ProductDTO dto = new ProductDTO();

	        dto.setCateCode(req.getParameter("cateCode"));
	        dto.setProdName(req.getParameter("prodName"));
	        dto.setColorCode(req.getParameter("colorCode"));
	        dto.setDescription(req.getParameter("prodDesc")); 
	        
	        String priceStr = req.getParameter("base_price");
	        if(priceStr != null && !priceStr.isEmpty()) {
	            dto.setPrice(Integer.parseInt(priceStr));
	        }

	        String[] sizes = req.getParameterValues("sizes");
	        String[] stocks = req.getParameterValues("stocks");
	        
	        List<String> sizeList = new ArrayList<>();
	        List<Integer> stockList = new ArrayList<>();

	        if(sizes != null && stocks != null) {
	            for(int i=0; i<sizes.length; i++) {
	                sizeList.add(sizes[i]);
	                try {
	                    stockList.add(Integer.parseInt(stocks[i]));
	                } catch (NumberFormatException e) {
	                    stockList.add(0);
	                }
	            }
	            dto.setSizes(sizeList);
	            dto.setStocks(stockList);
	        }
	        
	        dto.setIsDisplayed(1);

	        String root = session.getServletContext().getRealPath("/");
	        String pathname = root + "uploads" + File.separator + "product";

	        Part thumbPart = req.getPart("thumbnailFile");
	        if (thumbPart != null && thumbPart.getSize() > 0) {
	            MyMultipartFile mf = fileManager.doFileUpload(thumbPart, pathname);
	            dto.setThumbnailImg(mf);
	        }

	        Collection<Part> parts = req.getParts();
	        List<Part> imgParts = new ArrayList<>();
	        for(Part p : parts) {
	            if("imgs".equals(p.getName()) && p.getSize() > 0) {
	                imgParts.add(p);
	            }
	        }
	        
	        if(!imgParts.isEmpty()) {
	            List<MyMultipartFile> uploadedFiles = fileManager.doFileUpload(imgParts, pathname);
	            dto.setListFile(uploadedFiles);
	        }
	        
	        String gender = req.getParameter("gender");
            if(gender == null) gender = "M";

	        String fullName = gender + "_" + dto.getProdName() + "_" + dto.getColorCode();
	        dto.setProdName(fullName);

	        service.insertProduct(dto);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "redirect:/admin/product/product_write"; 
	    }
	    return "redirect:/admin/product/product_list";
	}
	
	@GetMapping("update")
	public String updateForm(HttpServletRequest req, HttpServletResponse resp) throws Exception {
	    try {
	        long prodId = Long.parseLong(req.getParameter("prodId"));
	        String page = req.getParameter("page");

	        ProductDTO dto = service.readProduct(prodId);
	        
	        if(dto == null) {
	            return "redirect:/admin/product/product_list?page=" + page;
	        }

	        String fullName = dto.getProdName();
	        String gender = "M";
	        String pureName = fullName;
	        String colorCode = "";
	        List<ProductDTO> listImg = service.listProductImg(prodId);
	        
	        String[] tokens = fullName.split("_");
	        if(tokens.length >= 3) {
	            gender = tokens[0]; 
	            colorCode = tokens[tokens.length-1];
	            
	            int start = fullName.indexOf("_") + 1;
	            int end = fullName.lastIndexOf("_");
	            if(end > start) {
	                pureName = fullName.substring(start, end);
	            }
	        } else if (tokens.length == 2) {
	             gender = tokens[0];
	             pureName = tokens[1];
	        }

	        dto.setProdName(pureName); 
	        dto.setColorCode(colorCode);
	        req.setAttribute("genderVal", gender); 

	        List<CategoryDTO> categoryList = service.listCategory();

	        req.setAttribute("mode", "update");
	        req.setAttribute("listImg", listImg);
	        req.setAttribute("dto", dto);
	        req.setAttribute("categoryList", categoryList);
	        req.setAttribute("page", page);

	        return "admin/product/product_write";

	    } catch (Exception e) {
	        e.printStackTrace();
	        return "redirect:/admin/product/product_list";
	    }
	}
	
	@PostMapping("updateSubmit")
	public String updateSubmit(HttpServletRequest req, HttpServletResponse resp) throws Exception {
	    try {
	        HttpSession session = req.getSession();
	        ProductDTO dto = new ProductDTO();
	        
	        long prodId = Long.parseLong(req.getParameter("prodId"));
	        dto.setProdId(prodId);
	        dto.setCateCode(req.getParameter("cateCode"));
	        dto.setPrice(Integer.parseInt(req.getParameter("base_price")));
	        dto.setDescription(req.getParameter("prodDesc"));
	        
	        String isDisplayedStr = req.getParameter("isDisplayed");
	        dto.setIsDisplayed(isDisplayedStr == null ? 1 : Integer.parseInt(isDisplayedStr));

	        String gender = req.getParameter("gender");
	        String pureName = req.getParameter("prodName");
	        String colorCode = req.getParameter("colorCode");
	        
	        if(gender == null) gender = "U";
	        if(colorCode == null) colorCode = "";
	        
	        String fullName = gender + "_" + pureName + "_" + colorCode;
	        dto.setProdName(fullName);

	        String[] sizes = req.getParameterValues("sizes");
	        String[] stocks = req.getParameterValues("stocks");
	        
	        List<String> sizeList = new ArrayList<>();
	        List<Integer> stockList = new ArrayList<>();

	        if(sizes != null && stocks != null) {
	            for(int i=0; i<sizes.length; i++) {
	                sizeList.add(sizes[i]);
	                try {
	                    stockList.add(Integer.parseInt(stocks[i]));
	                } catch (NumberFormatException e) {
	                    stockList.add(0);
	                }
	            }
	            dto.setSizes(sizeList);
	            dto.setStocks(stockList);
	        }

	        String root = session.getServletContext().getRealPath("/");
	        String pathname = root + "uploads" + File.separator + "product";

	        Part thumbPart = req.getPart("thumbnailFile");
	        if (thumbPart != null && thumbPart.getSize() > 0) {
	            MyMultipartFile mf = fileManager.doFileUpload(thumbPart, pathname);
	            dto.setThumbnailImg(mf);
	        }

	        Collection<Part> parts = req.getParts();
	        List<Part> imgParts = new ArrayList<>();
	        for(Part p : parts) {
	            if("imgs".equals(p.getName()) && p.getSize() > 0) {
	                imgParts.add(p);
	            }
	        }
	        
	        if(!imgParts.isEmpty()) {
	            List<MyMultipartFile> uploadedFiles = fileManager.doFileUpload(imgParts, pathname);
	            dto.setListFile(uploadedFiles);
	        }

	        service.updateProduct(dto);
	        
	        String page = req.getParameter("page");
	        return "redirect:/admin/product/product_list?page=" + page;
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "redirect:/admin/product/product_list";
	    }
	}
	
	
	
	@PostMapping("delete")
    public void delete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try {
            String[] sParams = req.getParameterValues("prodIds");
            
            if(sParams != null && sParams.length > 0) {
                long[] prodIds = new long[sParams.length];
                for(int i=0; i<sParams.length; i++) {
                    prodIds[i] = Long.parseLong(sParams[i]);
                }
                
                service.deleteProductList(prodIds);
            }
            
            resp.sendError(200); 
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500);
        }
    }
	
	@PostMapping("deleteFile")
	public void deleteFile(HttpServletRequest req, HttpServletResponse resp) throws Exception {
	    try {
	        long fileId = Long.parseLong(req.getParameter("fileId"));
	        
	        HttpSession session = req.getSession();
	        String root = session.getServletContext().getRealPath("/");
	        String pathname = root + "uploads" + File.separator + "product";
	        
	        service.deleteProductImg(fileId, pathname);
	        
	        resp.setContentType("application/json; charset=utf-8");
	        resp.getWriter().print("{\"state\": \"true\"}");
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        resp.sendError(500);
	    }
	}
}
