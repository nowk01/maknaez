package com.maknaez.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.maknaez.model.AddressDTO;
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
        
        // 파라미터 수신 (장바구니 vs 바로구매)
        String[] cartIds = req.getParameterValues("cartIds");
        String prodIdParam = req.getParameter("prod_id");
        String quantityParam = req.getParameter("quantity");
        String optIdParam = req.getParameter("opt_id"); // 옵션 추가

        try {
            // 1. 회원 정보 조회
            MemberDTO member = memberService.findById(info.getUserId());
            if (member == null) {
                return new ModelAndView("redirect:/member/login");
            }

            List<Map<String, Object>> orderList = new ArrayList<>();
            long totalPrice = 0;
            int totalQuantity = 0;

            // 2. 상품 정보 조회 로직 (분기 처리)
            if (cartIds != null && cartIds.length > 0) {
                // [CASE 1] 장바구니에서 진입 (여러 상품)
                System.out.println(">>> [Debug] 장바구니 결제 진입: " + cartIds.length + "건");
                orderList = paymentService.getOrderListByCart(cartIds);

            } else if (prodIdParam != null && quantityParam != null) {
                // [CASE 2] 상세페이지에서 바로 구매 (단일 상품)
                System.out.println(">>> [Debug] 바로 구매 진입");
                long prodId = Long.parseLong(prodIdParam);
                int quantity = Integer.parseInt(quantityParam);
                long optId = (optIdParam != null && !optIdParam.isEmpty()) ? Long.parseLong(optIdParam) : 0;

                Map<String, Object> item = paymentService.getProductDetailForOrder(prodId, quantity, optId);
                if (item != null) {
                    orderList.add(item);
                }
            } else {
                // [Error] 파라미터 없음
                System.out.println(">>> [Error] 유효한 결제 파라미터가 없습니다.");
                return new ModelAndView("redirect:/home/main");
            }

            // 3. 상품 정보가 없는 경우 처리
            if (orderList == null || orderList.isEmpty()) {
                System.out.println(">>> [Error] 주문할 상품 목록이 비어있습니다.");
                return new ModelAndView("redirect:/home/main");
            }

            // 4. 총 가격 및 수량 계산
            for (Map<String, Object> item : orderList) {
                // Map의 키값(Alias)은 Service/Mapper와 일치해야 함 (대소문자 주의)
                long price = Long.parseLong(String.valueOf(item.get("PRICE")));
                
                // 주의: SQL Alias가 'QUANTITY'로 유지되었다고 가정. 'COUNT'라면 변경 필요.
                int qty = Integer.parseInt(String.valueOf(item.get("QUANTITY"))); 
                
                totalPrice += (price * qty);
                totalQuantity += qty;
            }

            mav.addObject("member", member);
            mav.addObject("orderList", orderList); // 리스트 전달
            mav.addObject("totalPrice", totalPrice);
            mav.addObject("totalQuantity", totalQuantity);

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
            String[] prodIds = req.getParameterValues("prod_id");
            String[] quantities = req.getParameterValues("quantity");
            String[] optIds = req.getParameterValues("opt_id");
            
            String[] cartIds = req.getParameterValues("cart_id");
            
            if (prodIds == null || prodIds.length == 0) {
                result.put("status", "fail");
                result.put("message", "주문할 상품 정보가 없습니다.");
                return result;
            }

            long totalAmount = Long.parseLong(req.getParameter("total_amount"));

            OrderDTO order = new OrderDTO();
            order.setMemberIdx(info.getMemberIdx());
            order.setOrderState("결제완료");
            order.setTotalAmount((int)totalAmount); 
            ProductDTO firstProd = paymentService.getProduct(Long.parseLong(prodIds[0]));
            String orderName = firstProd.getProdName();
            if (prodIds.length > 1) {
                orderName += " 외 " + (prodIds.length - 1) + "건";
            }
            order.setProductName(orderName);
            order.setThumbNail(firstProd.getThumbnail());
            
            List<OrderItemDTO> orderItems = new ArrayList<>();
            
            for (int i = 0; i < prodIds.length; i++) {
                OrderItemDTO item = new OrderItemDTO();
                
                long prodId = Long.parseLong(prodIds[i]);
                int count = Integer.parseInt(quantities[i]);
                long optId = (optIds != null && i < optIds.length && optIds[i] != null && !optIds[i].isEmpty()) 
                            ? Long.parseLong(optIds[i]) : 0;

                item.setProd_id(prodId);
                item.setCount(count);
                item.setOpt_id(optId);
                
                String addrIdParam = req.getParameter("address_id");
                item.setReceiver_name(req.getParameter("receiver_name"));
                item.setReceiver_tel(req.getParameter("receiver_tel"));
                item.setZip_code(req.getParameter("zip_code"));
                
                item.setAddr1(req.getParameter("addr1"));
                item.setAddr2(req.getParameter("addr2"));
                item.setMemo(req.getParameter("memo"));
                
                // 가격 정보 재조회 (보안)
                Map<String, Object> productInfo = paymentService.getProductDetailForOrder(prodId, count, optId);
                if (productInfo != null && productInfo.containsKey("PRICE")) {
                    long unitPrice = Long.parseLong(String.valueOf(productInfo.get("PRICE")));
                    item.setPrice(unitPrice);
                } else {
                    item.setPrice(0); 
                }
                
                orderItems.add(item); // 리스트에 추가
            }

            // 3. 결제 처리 요청 (수정완료: items -> orderItems 로 변경!)
            // [수정] cartIds 파라미터 전달
            String orderId = paymentService.processPayment(order, orderItems, cartIds);

            result.put("status", "success");
            result.put("redirect", "/order/complete?order_id=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            result.put("status", "fail");
            result.put("message", "결제 처리 중 오류가 발생했습니다: " + e.getMessage());
        }

        return result;
    }
    
    @GetMapping("/address/list")
    public ModelAndView addressList(HttpServletRequest req, HttpServletResponse resp) {
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");

        // 로그인 상태가 아니면 빈 팝업을 띄우거나 로그인 유도 (여기선 빈 목록 처리)
        if (info == null) {
            return new ModelAndView("order/address_list");
        }

        ModelAndView mav = new ModelAndView("order/address_list");

        try {
            // Service 호출 -> Mapper -> DB 조회
            List<AddressDTO> list = paymentService.getAddressList(info.getMemberIdx());
            mav.addObject("list", list);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return mav;
    }

    /**
     * [추가] 결제 완료 페이지
     * URL: /order/complete
     */
    @GetMapping("/complete")
    public ModelAndView paymentComplete(HttpServletRequest req, HttpServletResponse resp) {
        // 로그인 체크
        HttpSession session = req.getSession();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            return new ModelAndView("redirect:/member/login");
        }

        String orderId = req.getParameter("order_id");
        
        ModelAndView mav = new ModelAndView("order/complete");
        mav.addObject("orderId", orderId);

        return mav;
    }
    
}