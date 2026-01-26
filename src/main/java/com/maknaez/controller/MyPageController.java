package com.maknaez.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.mapper.OrderMapper;
import com.maknaez.model.AddressDTO;
import com.maknaez.model.MemberDTO;
import com.maknaez.model.OrderDTO;
import com.maknaez.model.PointDTO;
import com.maknaez.model.ProductDTO;
import com.maknaez.model.ReviewDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.model.WishlistDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.mybatis.support.MapperContainer;
import com.maknaez.service.MemberService;
import com.maknaez.service.MemberServiceImpl;
import com.maknaez.service.PointService;
import com.maknaez.service.PointServiceImpl;
import com.maknaez.service.ProductService;
import com.maknaez.service.ProductServiceImpl;
import com.maknaez.service.WishlistService;
import com.maknaez.service.WishlistServiceImpl;
import com.maknaez.service.ReviewService;      // 추가
import com.maknaez.service.ReviewServiceImpl;
import com.maknaez.util.MyUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.maknaez.util.FileManager;

@Controller
@RequestMapping("/member/mypage")
public class MyPageController {

	private MemberService service;
	private PointService pointService;
	private WishlistService wishlistService;
	private ProductService productService;
	private ReviewService reviewService; 

	public MyPageController() {
		this.service = new MemberServiceImpl();
		this.pointService = new PointServiceImpl();
		this.wishlistService = new WishlistServiceImpl();
		this.productService = new ProductServiceImpl();
		this.reviewService = new ReviewServiceImpl();
	}

	@GetMapping("main.do")
	public ModelAndView myPageMain(HttpServletRequest req, HttpServletResponse resp) {
		return new ModelAndView("mypage/myMain");
	}

	@GetMapping("orderList")
	public ModelAndView orderList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("mypage/orderList");
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");

		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		MyUtil util = new MyUtil();

		try {
			String page = req.getParameter("page");
			int current_page = 1;
			if (page != null)
				current_page = Integer.parseInt(page);

			String historyStartDate = req.getParameter("historyStartDate");
	        String historyEndDate = req.getParameter("historyEndDate");
	        
			Map<String, Object> map = new HashMap<>();
			
			map.put("memberIdx", info.getMemberIdx());
			map.put("historyStartDate", historyStartDate);
	        map.put("historyEndDate", historyEndDate);

			int dataCount = mapper.dataCount(map);
			
			map.put("orderState", "결제완료");
			int paymentCount = mapper.dataCount(map);
			map.put("orderState", "배송중");
			int shippingCount = mapper.dataCount(map);
			map.put("orderState", "배송완료");
			int completeCount = mapper.dataCount(map);
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
			String listUrl = req.getContextPath() + "/member/mypage/orderList";
			if (historyStartDate != null && !historyStartDate.isEmpty()) {
	            listUrl += "?historyStartDate=" + historyStartDate + "&historyEndDate=" + historyEndDate;
	        }
			
			String paging = util.paging(current_page, total_page, listUrl);
			
			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			mav.addObject("paging", paging);
			mav.addObject("paymentCount", paymentCount);
			mav.addObject("shippingCount", shippingCount);
			mav.addObject("completeCount", completeCount);
			mav.addObject("historyStartDate", historyStartDate);
	        mav.addObject("historyEndDate", historyEndDate);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	// 취소/반품 내역
	@GetMapping("cancelList")
	public ModelAndView cancelList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("mypage/cancelList");
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");

		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		MyUtil util = new MyUtil();

		try {
			String historyStartDate = req.getParameter("historyStartDate");
	        String historyEndDate = req.getParameter("historyEndDate");
			
			String page = req.getParameter("page");
			int current_page = 1;
			if (page != null)
				current_page = Integer.parseInt(page);

			Map<String, Object> map = new HashMap<>();
			map.put("memberIdx", info.getMemberIdx());
			map.put("mode", "cancel");
			
			map.put("historyStartDate", historyStartDate);
	        map.put("historyEndDate", historyEndDate);
	        
			int dataCount = mapper.dataCount(map);

			map.put("orderState", "취소완료");
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
			
			if (historyStartDate != null && !historyStartDate.isEmpty()) {
	            listUrl += "?historyStartDate=" + historyStartDate + "&historyEndDate=" + historyEndDate;
	        }
			
			String paging = util.paging(current_page, total_page, listUrl);

			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			mav.addObject("paging", paging);
			mav.addObject("cancelCount", cancelCount);
			mav.addObject("returnCheckCount", returnCheckCount);
			mav.addObject("returnIngCount", returnIngCount);
			mav.addObject("returnDoneCount", returnDoneCount);
			mav.addObject("historyStartDate", historyStartDate);
	        mav.addObject("historyEndDate", historyEndDate);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	// 리뷰 작성 가능 목록 및 작성한 리뷰 목록
	@GetMapping("review")
	public ModelAndView review(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("mypage/review");
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");

		OrderMapper mapper = MapperContainer.get(OrderMapper.class);

		try {
			Map<String, Object> map = new HashMap<>();
			map.put("memberIdx", info.getMemberIdx());
			map.put("orderState", "배송완료");
			map.put("mode", "writable");  
			map.put("start", 1);
			map.put("end", 100);

			List<OrderDTO> list = mapper.listOrder(map);
			int dataCount = mapper.dataCount(map);

			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			
			Map<String, Object> map2 = new HashMap<>();
			map2.put("memberIdx", info.getMemberIdx());
			map2.put("start", 1);
			map2.put("end", 100);
			
			
			int writtenDataCount = reviewService.dataCountMyReviews(info.getMemberIdx());
			List<ReviewDTO> writtenList = reviewService.listMyReviews(map2);
			
			mav.addObject("writtenList", writtenList);
			mav.addObject("writtenDataCount", writtenDataCount);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	@GetMapping("wishList")
	public ModelAndView wishList(HttpServletRequest req, HttpServletResponse resp) {
		ModelAndView mav = new ModelAndView("mypage/wishList");
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		MyUtil util = new MyUtil();

		String pageStr = req.getParameter("page");
		int current_page = 1;
		try {
			if (pageStr != null) {
				current_page = Integer.parseInt(pageStr);
			}
		} catch (NumberFormatException e) {
		}

		int rows = 20;
		int total_page = 0;
		int dataCount = 0;

		Map<String, Object> map = new HashMap<>();
		map.put("memberIdx", info.getMemberIdx());

		dataCount = wishlistService.dataCountWish(map);
		if (dataCount != 0) {
			total_page = util.pageCount(dataCount, rows);
		}

		if (current_page > total_page)
			current_page = total_page;

		int start = (current_page - 1) * rows + 1;
		int end = current_page * rows;
		map.put("start", start);
		map.put("end", end);

		List<WishlistDTO> list = wishlistService.listWish(map);

		String paging = util.pagingCustom(current_page, total_page, "wishList");

		mav.addObject("list", list);
		mav.addObject("page", current_page);
		mav.addObject("dataCount", dataCount);
		mav.addObject("total_page", total_page);
		mav.addObject("paging", paging);

		return mav;
	}

	// 내 정보 관리
	@GetMapping("myInfo")
	public ModelAndView myInfo(HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession(false);
		if (session == null)
			return new ModelAndView("redirect:/member/login");
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");

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
			mav.addObject("dto", dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	// 회원 정보 수정 처리
	@PostMapping("update")
	public ModelAndView updateSubmit(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");

		try {
			MemberDTO dto = service.findByIdx(info.getMemberIdx());
			if (dto == null) {
				session.invalidate();
				return new ModelAndView("redirect:/member/login");
			}

			dto.setUserPwd(req.getParameter("userPwd"));
			dto.setUserName(req.getParameter("userName"));
			String email1 = req.getParameter("email1");
			String email2 = req.getParameter("email2");
			if (email1 != null && email2 != null)
				dto.setEmail(email1 + "@" + email2);
			dto.setTel(req.getParameter("tel"));

			String genderStr = req.getParameter("gender");
			if (genderStr != null && !genderStr.isEmpty())
				dto.setGender(Integer.parseInt(genderStr));

			dto.setZip(req.getParameter("zip"));
			dto.setAddr1(req.getParameter("addr1"));
			dto.setAddr2(req.getParameter("addr2"));

			String receiveEmail = req.getParameter("receiveEmail");
			dto.setReceiveEmail(receiveEmail != null ? 1 : 0);

			service.updateMember(dto);

			info.setUserName(dto.getUserName());
			session.setAttribute("member", info);

			return new ModelAndView("redirect:/member/complete");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("redirect:/member/mypage/myInfo");
	}

	// 배송지 관리 목록
	@GetMapping("addr")
	public ModelAndView addressList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");

		ModelAndView mav = new ModelAndView("mypage/addr");
		try {
			List<AddressDTO> list = service.listAddress(info.getMemberIdx());
			mav.addObject("list", list);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	// 배송지 추가
	@PostMapping("addr/write")
	public ModelAndView addressWrite(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");

		try {
			AddressDTO dto = new AddressDTO();
			dto.setMemberIdx(info.getMemberIdx());
			dto.setReceiverName(req.getParameter("receiverName"));
			dto.setAddrName(req.getParameter("addrName"));
			dto.setReceiverTel(req.getParameter("receiverTel"));
			dto.setZipCode(req.getParameter("zipCode"));
			dto.setAddr1(req.getParameter("addr1"));
			dto.setAddr2(req.getParameter("addr2"));
			String isBasic = req.getParameter("isBasic");
			dto.setIsBasic(isBasic != null ? 1 : 0);

			service.insertAddress(dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("redirect:/member/mypage/addr");
	}

	// 배송지 수정
	@PostMapping("addr/update")
	public ModelAndView addressUpdate(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");

		try {
			AddressDTO dto = new AddressDTO();
			dto.setAddrId(Long.parseLong(req.getParameter("addrId")));
			dto.setMemberIdx(info.getMemberIdx());

			dto.setReceiverName(req.getParameter("receiverName"));
			dto.setAddrName(req.getParameter("addrName"));
			dto.setReceiverTel(req.getParameter("receiverTel"));
			dto.setZipCode(req.getParameter("zipCode"));
			dto.setAddr1(req.getParameter("addr1"));
			dto.setAddr2(req.getParameter("addr2"));

			String isBasic = req.getParameter("isBasic");
			dto.setIsBasic(isBasic != null ? 1 : 0);

			service.updateAddress(dto);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("redirect:/member/mypage/addr");
	}

	// 배송지 삭제
	@GetMapping("addr/delete")
	public ModelAndView addressDelete(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");

		try {
			long addrId = Long.parseLong(req.getParameter("addrId"));
			service.deleteAddress(addrId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("redirect:/member/mypage/addr");
	}

	// 포인트/멤버십
	@GetMapping("membership")
	public ModelAndView membership(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("mypage/membership");
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");
		MyUtil util = new MyUtil();
		try {
			String page = req.getParameter("page");
			int current_page = 1;
			if (page != null)
				current_page = Integer.parseInt(page);

			Map<String, Object> map = new HashMap<>();
			map.put("memberIdx", info.getMemberIdx());

			int dataCount = pointService.dataCountPointHistory(map);
			int size = 10;
			int total_page = util.pageCount(dataCount, size);
			if (current_page > total_page)
				current_page = total_page;

			int start = (current_page - 1) * size + 1;
			int end = current_page * size;
			map.put("start", start);
			map.put("end", end);

			List<PointDTO> list = pointService.listPointHistory(map);
			int currentPoint = pointService.findCurrentPoint(info.getMemberIdx());

			String listUrl = req.getContextPath() + "/member/mypage/membership";
			String mode = req.getParameter("mode");
			if (mode != null && !mode.isEmpty())
				listUrl += "?mode=" + mode;

			String paging = util.paging(current_page, total_page, listUrl);

			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			mav.addObject("currentPoint", currentPoint);
			mav.addObject("paging", paging);
			mav.addObject("page", current_page);
			mav.addObject("mode", mode);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	@GetMapping("/level_benefit")
	public ModelAndView levelBenefit(HttpServletRequest req, HttpServletResponse resp) {
		HttpSession session = req.getSession();
		if (session.getAttribute("member") == null) {
			return new ModelAndView("redirect:/member/login");
		}
		return new ModelAndView("mypage/level_benefit"); // 뷰 이름 추가
	}

	@GetMapping("claimForm")
	public ModelAndView claimForm(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if (info == null)
			return new ModelAndView("redirect:/member/login");

		ModelAndView mav = new ModelAndView("order/claimForm");
		String orderNum = req.getParameter("order_id");

		try {
			OrderMapper mapper = MapperContainer.get(OrderMapper.class);
			
			Map<String, Object> map = new HashMap<>();
			map.put("memberIdx", info.getMemberIdx());
			map.put("orderNum", orderNum);
			
			map.put("start", 1);
			map.put("end", 10); 

			List<OrderDTO> list = mapper.listOrder(map);
			
			if (!list.isEmpty()) {
				mav.addObject("dto", list.get(0));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mav;
	}

	// 취소/교환 신청 처리
	@PostMapping("claimRequest")
	public ModelAndView claimRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    HttpSession session = req.getSession();
	    SessionInfo info = (SessionInfo) session.getAttribute("member");
	    if (info == null) return new ModelAndView("redirect:/member/login");

	    try {
	        OrderMapper mapper = MapperContainer.get(OrderMapper.class);
	        
	        String orderNum = req.getParameter("orderNum");
	        String type = req.getParameter("type"); 
	        String reasonCategory = req.getParameter("reasonCategory");
	        String reasonDetail = req.getParameter("reason"); 
	        String fullReason = "[" + reasonCategory + "] " + reasonDetail;

	        Map<String, Object> claimMap = new HashMap<>();
	        claimMap.put("orderId", orderNum);
	        claimMap.put("claimType", type);
	        claimMap.put("reason", fullReason); 
	        claimMap.put("claimStatus", "접수완료"); 

	        mapper.insertClaim(claimMap);

	        Map<String, Object> stateMap = new HashMap<>();
	        stateMap.put("orderNum", orderNum); 
	        
	        String nextStatus = (type != null && type.equalsIgnoreCase("CANCEL")) ? "취소완료" : "반품신청";
	        stateMap.put("status", nextStatus);
	        
	        mapper.updateOrderState(stateMap);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return new ModelAndView("redirect:/member/mypage/cancelList");
	}

    @GetMapping("recent")
    public ModelAndView recentList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        ModelAndView mav = new ModelAndView("mypage/recentList");

        String recentProducts = "";
        jakarta.servlet.http.Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (jakarta.servlet.http.Cookie c : cookies) {
                if (c.getName().equals("recent_products")) {
                    try {
                        recentProducts = java.net.URLDecoder.decode(c.getValue(), "UTF-8");
                    } catch (Exception e) {
                    }
                    break;
                }
            }
        }

        List<ProductDTO> list = new java.util.ArrayList<>();
        
        final List<String> idList = new java.util.ArrayList<>();
        
        if (!recentProducts.isEmpty()) {
            String[] ids = recentProducts.split(",");
            for (String id : ids) {
                if (!id.trim().isEmpty()) {
                    idList.add(id.trim());
                }
            }

            if (!idList.isEmpty()) {
                list = productService.listProductByIds(idList);
                
                list.sort((p1, p2) -> {
                    String id1 = String.valueOf(p1.getProdId());
                    String id2 = String.valueOf(p2.getProdId());
                    return Integer.compare(idList.indexOf(id1), idList.indexOf(id2));
                });
            }
        }

        mav.addObject("list", list);
        mav.addObject("menuIndex", 99);

        return mav;
    }

	@GetMapping("orderDetail")
	public ModelAndView orderDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    ModelAndView mav = new ModelAndView("mypage/orderDetail");
	    String orderNum = req.getParameter("orderNum");
	    
	    HttpSession session = req.getSession();
	    SessionInfo info = (SessionInfo) session.getAttribute("member");
	    if (info == null) return new ModelAndView("redirect:/member/login");

	    try {
	        OrderMapper mapper = MapperContainer.get(OrderMapper.class);
	        Map<String, Object> map = new HashMap<>();
	        map.put("memberIdx", info.getMemberIdx());
	        map.put("orderNum", orderNum);
	        
	        map.put("start", 1);
	        map.put("end", 1); 

	        List<OrderDTO> list = mapper.listOrder(map);
	        if (list.isEmpty()) {
	            return new ModelAndView("redirect:/member/mypage/orderList");
	        }
	        
	        OrderDTO dto = list.get(0);
	        
	        mav.addObject("dto", dto);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ModelAndView("redirect:/member/mypage/orderList");
	    }
	    return mav; 
	}
	
	// 구매확정
	@GetMapping("confirmOrder")
	public String confirmOrder(HttpServletRequest req, HttpServletResponse resp) {
	    String orderNum = req.getParameter("orderNum");
	    
	    try {
	        OrderMapper mapper = MapperContainer.get(OrderMapper.class);
	        Map<String, Object> map = new HashMap<>();
	        map.put("orderNum", orderNum);
	        map.put("status", "구매확정");
	        
	        mapper.updateOrderState(map);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    return "redirect:/member/mypage/orderList";
	}    

	@GetMapping("deliveryInfo")
	public ModelAndView deliveryInfo(HttpServletRequest req, HttpServletResponse resp) {
		return new ModelAndView("mypage/deliveryInfo");
	}
	
	@PostMapping("review/write")
    public String reviewWrite(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            return "redirect:/member/login";
        }

        FileManager fileManager = new FileManager();
        
        String root = session.getServletContext().getRealPath("/");
        String pathname = root + "uploads" + java.io.File.separator + "review";

        try {
            Part part = req.getPart("selectFile");
            String saveFilename = null;
            if(part != null && part.getSize() > 0) {
                com.maknaez.util.MyMultipartFile myFile = fileManager.doFileUpload(part, pathname);
                if(myFile != null) {
                    saveFilename = myFile.getSaveFilename();
                }
            }

            com.maknaez.model.ReviewDTO dto = new com.maknaez.model.ReviewDTO();
            dto.setMemberIdx(info.getMemberIdx());
            dto.setOrderNum(req.getParameter("orderNum"));
            dto.setProdId(Long.parseLong(req.getParameter("productNum")));
            dto.setContent(req.getParameter("content"));
            dto.setStarRating(Integer.parseInt(req.getParameter("rating")));
            dto.setReviewImg(saveFilename);

            reviewService.insertReview(dto, pathname);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/member/mypage/review";
    }
	
	
}
