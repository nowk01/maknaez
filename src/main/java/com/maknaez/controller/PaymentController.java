package com.maknaez.controller;

import java.util.HashMap;
import java.util.Map;

import com.maknaez.model.MemberDTO;
import com.maknaez.model.OrderDTO;
import com.maknaez.model.OrderItemDTO;
import com.maknaez.model.ProductDTO;
import com.maknaez.model.SessionInfo;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.PostMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.annotation.ResponseBody;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.service.MemberService;
import com.maknaez.service.MemberServiceImpl;
import com.maknaez.service.PaymentService;
import com.maknaez.service.PaymentServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/order")
public class PaymentController {

    private PaymentService paymentService = new PaymentServiceImpl();
    private MemberService memberService = new MemberServiceImpl();

    /**
     * 결제 페이지 진입 (GET)
     * URL: /order/payment
     */
    @GetMapping("/payment")
    public ModelAndView paymentForm(HttpServletRequest req, HttpServletResponse resp) {
        System.out.println(">>> [PaymentController] 결제 페이지 진입");

        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        if (info == null) {
            return new ModelAndView("redirect:/member/login");
        }

        ModelAndView mav = new ModelAndView("order/payment");
        
        String prodIdParam = req.getParameter("prod_id");
        String quantityParam = req.getParameter("quantity");

        try {
            MemberDTO member = null;
            
            // 1. 회원 정보 조회 시도
            try {
                // [MemberDTO 복구] 기존 getUserId() 사용
                member = memberService.findById(info.getUserId()); 
            } catch (Exception e) {
                System.out.println(">>> [Warn] 회원 정보 조회 실패: " + e.getMessage());
                if(prodIdParam != null && quantityParam != null) throw e;
            }
            
            // 2. [테스트 모드] 파라미터가 없으면 '테스트용 가상 데이터'를 생성해서 보여줌
            if(prodIdParam == null || quantityParam == null) {
                 System.out.println(">>> [Debug] 파라미터 없음 -> 레이아웃 확인용 테스트 데이터 생성");
                 
                 if(member == null) {
                     // [MemberDTO 복구] 기존 메소드명(setUserName, setTel, setZip) 유지
                     member = new MemberDTO();
                     member.setUserName("테스트유저");
                     member.setTel("010-0000-0000");
                     member.setEmail("test@example.com");
                     member.setZip("12345");
                     member.setAddr1("서울시 마포구 월드컵북로");
                     member.setAddr2("101호");
                 }
                 
                 // [ProductDTO 변경 적용] prodId, prodName, thumbnail
                 ProductDTO dummyProd = new ProductDTO();
                 dummyProd.setProdId(999);
                 dummyProd.setProdName("[테스트] 레이아웃 확인용 상품");
                 dummyProd.setPrice(50000);
                 dummyProd.setThumbnail("no_image.jpg");
                 
                 mav.addObject("member", member);
                 mav.addObject("product", dummyProd);
                 mav.addObject("quantity", 1);
                 mav.addObject("totalPrice", 50000);
                 
                 return mav;
            }

            // 3. [실제 모드] 정상적인 파라미터가 있을 경우
            if(member == null) {
                throw new Exception("회원 정보를 불러올 수 없습니다.");
            }

            long prodId = Long.parseLong(prodIdParam);
            int quantity = Integer.parseInt(quantityParam);

            ProductDTO product = paymentService.getProduct(prodId);
            
            if (product == null) {
                System.out.println(">>> [Error] 상품 정보 없음 -> 메인 이동");
                return new ModelAndView("redirect:/home/main");
            }

            long totalPrice = (long)product.getPrice() * quantity;

            mav.addObject("member", member);
            mav.addObject("product", product);
            mav.addObject("quantity", quantity);
            mav.addObject("totalPrice", totalPrice);

        } catch (Exception e) {
            System.out.println(">>> [Fatal Error] 결제 페이지 처리 중 오류 발생");
            e.printStackTrace();
            return new ModelAndView("redirect:/home/main");
        }

        return mav;
    }

    /**
     * 결제 처리 (POST)
     * URL: /order/pay
     */
    @PostMapping("/pay")
    @ResponseBody
    public Map<String, Object> payProcess(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, Object> result = new HashMap<>();
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        if (info == null) {
            result.put("status", "fail");
            result.put("message", "로그인이 필요합니다.");
            return result;
        }

        try {
            if(req.getParameter("prod_id") == null) {
                result.put("status", "fail");
                result.put("message", "잘못된 접근입니다. (상품 정보 없음)");
                return result;
            }

            long prodId = Long.parseLong(req.getParameter("prod_id"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            int totalAmount = Integer.parseInt(req.getParameter("total_amount"));
            
            // 상품 정보 조회
            ProductDTO prodInfo = paymentService.getProduct(prodId);

            // 1. OrderDTO 객체 생성
            OrderDTO order = new OrderDTO();
            order.setMemberIdx(info.getMemberIdx());
            order.setOrderState("결제완료");
            
            // [ProductDTO 변경 적용] getProdName, getThumbnail
            order.setProductName(prodInfo.getProdName());
            order.setThumbNail(prodInfo.getThumbnail());
            
            order.setTotalAmount(totalAmount);
            order.setQty(quantity);
            order.setPrice(prodInfo.getPrice());
            
            // 2. OrderItemDTO 생성
            OrderItemDTO item = new OrderItemDTO();
            item.setProd_id(prodId);
            item.setQuantity(quantity);
            item.setPrice(prodInfo.getPrice());
            
            // 배송지 정보
            String addrIdParam = req.getParameter("address_id");
            if(addrIdParam != null && !addrIdParam.isEmpty()) {
                item.setAddressId(Long.parseLong(addrIdParam));
            }
            item.setReceiverName(req.getParameter("receiver_name"));
            item.setReceiverTel(req.getParameter("receiver_tel"));
            item.setZipCode(req.getParameter("zip_code"));
            item.setAddr1(req.getParameter("addr1"));
            item.setAddr2(req.getParameter("addr2"));
            item.setMemo(req.getParameter("memo"));

            // 3. 결제 처리 요청
            paymentService.processPayment(order, item);

            result.put("status", "success");
            result.put("redirect", "/mypage/myMain");

        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "fail");
            result.put("message", "결제 처리 중 오류가 발생했습니다.");
        }

        return result;
    }
}