package com.maknaez.controller.admin;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

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
	
	@GetMapping("product_list")
	public ModelAndView productList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/product/product_list");
		
		return mav;
	}
	
	@GetMapping("category_manage")
    public ModelAndView categoryManage(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        return new ModelAndView("admin/product/category_manage");
    }

	@GetMapping("category_list")
    public ModelAndView listCategoryApi(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        List<CategoryDTO> list = service.listCategory();

        // JSON으로 데이터 반환
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
        
        // 수정: 생성자 대신 addObject 사용
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

        // 수정: 생성자 대신 addObject 사용
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
	public ModelAndView stockList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/product/stock_list");
		
		return mav;
	}
	
	@GetMapping("product_write")
	public ModelAndView productWriteForm(HttpServletRequest req, HttpServletResponse resp) throws Exception {
	    List<CategoryDTO> list = service.listCategorySelect();
	    
	    ModelAndView mav = new ModelAndView("admin/product/product_write");
	    mav.addObject("categoryList", list);
	    return mav;
	}
	
	@PostMapping("write_ok")
    public String writeSubmit(ProductDTO dto, HttpServletRequest req, HttpSession session) {
        try {
            // 1. 파일 저장 경로 설정 (GuestController 방식)
            String root = session.getServletContext().getRealPath("/");
            String pathname = root + "uploads" + File.separator + "guest"; // 요청하신 경로

            // 2. 썸네일 이미지 처리 (thumbnailFile)
            Part thumbPart = req.getPart("thumbnailFile");
            if (thumbPart != null && thumbPart.getSize() > 0) {
                // FileManager가 업로드 수행 후 결과 객체 리턴
                MyMultipartFile mf = fileManager.doFileUpload(thumbPart, pathname);
                dto.setThumbnailImg(mf); // DTO에 결과 담기
            }

            // 3. 추가 이미지 처리 (imgs) - 여러개
            Collection<Part> parts = req.getParts();
            List<Part> imgParts = new ArrayList<>();
            for(Part p : parts) {
                // name="imgs" 이고 파일이 있는 경우만 골라내기
                if("imgs".equals(p.getName()) && p.getSize() > 0) {
                    imgParts.add(p);
                }
            }
            
            if(!imgParts.isEmpty()) {
                // FileManager가 리스트 통째로 업로드 수행
                List<MyMultipartFile> uploadedFiles = fileManager.doFileUpload(imgParts, pathname);
                dto.setListFile(uploadedFiles); // DTO에 결과 리스트 담기
            }

            // 4. 제품명 완성 (기존 로직)
            String fullName = dto.getProdName() + dto.getColorCode();
            dto.setProdName(fullName);

            // 5. Service 호출 (DTO만 넘김)
            service.insertProduct(dto); // 경로(pathname)를 넘길 필요가 없어짐!
            
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/product/write"; 
        }
        return "redirect:/admin/product/product_list";
    }
}
