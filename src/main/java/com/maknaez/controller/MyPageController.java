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
import com.maknaez.service.WishlistService;
import com.maknaez.service.WishlistServiceImpl;
import com.maknaez.util.MyUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/member/mypage")
public class MyPageController {

	// 서비스 객체 선언
	private MemberService service;
	private PointService pointService;
	private WishlistService wishlistService;

	// [중요] 생성자에서 모든 서비스 수동 초기화 (스프링이 아니므로 new 사용)
	public MyPageController() {
		this.service = new MemberServiceImpl();
		this.pointService = new PointServiceImpl();
		this.wishlistService = new WishlistServiceImpl();
	}

	// 1. 마이페이지 메인
	@GetMapping("main.do")
	public ModelAndView myPageMain(HttpServletRequest req, HttpServletResponse resp) {
		return new ModelAndView("mypage/myMain");
	}

	// 2. 주문 내역 조회
	@GetMapping("orderList")
	public ModelAndView orderList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
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

			Map<String, Object> map = new HashMap<>();
			map.put("memberIdx", info.getMemberIdx());

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
			String paging = util.paging(current_page, total_page, listUrl);

			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			mav.addObject("paging", paging);
			mav.addObject("paymentCount", paymentCount);
			mav.addObject("shippingCount", shippingCount);
			mav.addObject("completeCount", completeCount);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	// 3. 취소/반품 내역
	@GetMapping("cancelList")
	public ModelAndView cancelList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("mypage/cancelList");
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

			Map<String, Object> map = new HashMap<>();
			map.put("memberIdx", info.getMemberIdx());
			map.put("mode", "cancel");

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
			String paging = util.paging(current_page, total_page, listUrl);

			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			mav.addObject("paging", paging);
			mav.addObject("cancelCount", cancelCount);
			mav.addObject("returnCheckCount", returnCheckCount);
			mav.addObject("returnIngCount", returnIngCount);
			mav.addObject("returnDoneCount", returnDoneCount);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	// 4. 리뷰 작성 가능 목록
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
			map.put("start", 1);
			map.put("end", 100);

			List<OrderDTO> list = mapper.listOrder(map);
			int dataCount = mapper.dataCount(map);

			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	// [수정됨] 5. 관심 상품 (WishList) - DB 연동 및 RequestParam 제거
	@GetMapping("wishList")
	public ModelAndView wishList(HttpServletRequest req, HttpServletResponse resp) {
		ModelAndView mav = new ModelAndView("mypage/wishList");
		HttpSession session = req.getSession();
		SessionInfo info = (SessionInfo) session.getAttribute("member");

		if (info == null) {
			return new ModelAndView("redirect:/member/login");
		}

		MyUtil util = new MyUtil();

		// [수정] RequestParam 대신 req.getParameter로 페이지 번호 받기
		String pageStr = req.getParameter("page");
		int current_page = 1;
		try {
			if (pageStr != null) {
				current_page = Integer.parseInt(pageStr);
			}
		} catch (NumberFormatException e) {
			// 페이지 번호가 숫자가 아니면 1페이지로 유지
		}

		int rows = 10;
		int total_page = 0;
		int dataCount = 0;

		Map<String, Object> map = new HashMap<>();
		map.put("memberIdx", info.getMemberIdx());

		dataCount = wishlistService.dataCountWish(map);
		if (dataCount != 0) {
			total_page = util.pageCount(rows, dataCount);
		}

		if (current_page > total_page)
			current_page = total_page;

		int start = (current_page - 1) * rows + 1;
		int end = current_page * rows;
		map.put("start", start);
		map.put("end", end);

		List<WishlistDTO> list = wishlistService.listWish(map);

		String paging = util.paging(current_page, total_page, "wishList");

		mav.addObject("list", list);
		mav.addObject("page", current_page);
		mav.addObject("dataCount", dataCount);
		mav.addObject("total_page", total_page);
		mav.addObject("paging", paging);

		return mav;
	}

	// 6. 내 정보 관리
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

	// 7. 회원 정보 수정 처리
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

			// 회원 정보 업데이트 실행
			service.updateMember(dto);

			// 세션 정보 갱신
			info.setUserName(dto.getUserName());
			session.setAttribute("member", info);

			return new ModelAndView("redirect:/member/complete");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("redirect:/member/mypage/myInfo");
	}

	// 8. 배송지 관리 목록
	@GetMapping("addr")
    public ModelAndView addressList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) return new ModelAndView("redirect:/member/login");

        ModelAndView mav = new ModelAndView("mypage/addr");
        try {
            List<AddressDTO> list = service.listAddress(info.getMemberIdx());
            mav.addObject("list", list);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mav;
    }

	// 9. 배송지 추가
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

	// 10. 배송지 수정
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

	// 11. 배송지 삭제
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

	// 12. 포인트/멤버십
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
}