package com.maknaez.controller.admin;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.maknaez.mapper.OrderMapper;
import com.maknaez.model.OrderDTO;
import com.maknaez.mvc.annotation.Controller;
import com.maknaez.mvc.annotation.GetMapping;
import com.maknaez.mvc.annotation.RequestMapping;
import com.maknaez.mvc.view.ModelAndView;
import com.maknaez.mybatis.support.MapperContainer;
import com.maknaez.util.MyUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/admin/order/*")
public class OrderManageController {

	@GetMapping("order_list")
	public ModelAndView orderList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/order/order_list");
		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		MyUtil util = new MyUtil();

		try {
			String page = req.getParameter("page");
			int current_page = (page != null && !page.isEmpty()) ? Integer.parseInt(page) : 1;

			Map<String, Object> map = new HashMap<>();
			// 검색 로직이 필요하다면 여기에 추가 (claim_list 참고)

			int dataCount = mapper.dataCount(map);
			int size = 10;
			int total_page = util.pageCount(dataCount, size);
			if (current_page > total_page)
				current_page = total_page;

			int start = (current_page - 1) * size + 1;
			int end = current_page * size;
			map.put("start", start);
			map.put("end", end);

			// 실제 주문 데이터 리스트 가져오기
			List<OrderDTO> list = mapper.listOrder(map);

			String cp = req.getContextPath();
			String listUrl = cp + "/admin/order/order_list";
			String paging = util.paging(current_page, total_page, listUrl);

			mav.addObject("list", list);
			mav.addObject("dataCount", dataCount);
			mav.addObject("paging", paging);
			mav.addObject("page", current_page);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	@GetMapping("claim_list")
	public ModelAndView claimList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/order/claim_list");
		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		MyUtil util = new MyUtil();

		try {
			String page = req.getParameter("page");
			int current_page = (page != null && !page.isEmpty()) ? Integer.parseInt(page) : 1;

			String searchKey = req.getParameter("searchKey");
			String searchValue = req.getParameter("searchValue");

			Map<String, Object> map = new HashMap<>();
			map.put("mode", "claim");

			if (searchValue != null && !searchValue.isEmpty()) {
				map.put("searchKey", searchKey);
				map.put("searchValue", searchValue);
			}

			int dataCount = mapper.dataCount(map);
			int size = 10;
			int total_page = util.pageCount(dataCount, size);
			if (current_page > total_page)
				current_page = total_page;

			int start = (current_page - 1) * size + 1;
			int end = current_page * size;
			map.put("start", start);
			map.put("end", end);

			List<OrderDTO> list = mapper.listOrder(map);
			String cp = req.getContextPath();
			String listUrl = cp + "/admin/order/claim_list";

			if (searchValue != null && !searchValue.isEmpty()) {
				listUrl += "?searchKey=" + searchKey + "&searchValue=" + URLEncoder.encode(searchValue, "UTF-8");
			}

			String paging = util.paging(current_page, total_page, listUrl);

			mav.addObject("list", list);
			mav.addObject("page", current_page);
			mav.addObject("dataCount", dataCount);
			mav.addObject("paging", paging);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	// 거래명세서(내역서) 리스트
	@GetMapping("estimate_list")
	public ModelAndView estimateList(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/order/estimate_list");
		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		MyUtil util = new MyUtil();

		try {
			String page = req.getParameter("page");
			int current_page = (page != null) ? Integer.parseInt(page) : 1;

			Map<String, Object> map = new HashMap<>();
			int dataCount = mapper.estimateCount(map);
			int size = 10;
			int total_page = util.pageCount(dataCount, size);
			if (current_page > total_page)
				current_page = total_page;

			int start = (current_page - 1) * size + 1;
			int end = current_page * size;
			map.put("start", start);
			map.put("end", end);

			List<Map<String, Object>> list = mapper.listEstimate(map);

			String cp = req.getContextPath();
			String listUrl = cp + "/admin/order/estimate_list";
			String paging = util.paging(current_page, total_page, listUrl);

			mav.addObject("list", list);
			mav.addObject("page", current_page);
			mav.addObject("dataCount", dataCount);
			mav.addObject("paging", paging);
			mav.addObject("waitingCount", mapper.waitingEstimateCount());

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	// 거래명세서(내역서) 작성/상세
	@GetMapping("estimate_write")
	public ModelAndView estimateWrite(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		ModelAndView mav = new ModelAndView("admin/order/estimate_write");
		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		String orderNum = req.getParameter("orderNum");

		try {
			if (orderNum != null && !orderNum.isEmpty()) {
				List<Map<String, Object>> list = mapper.getOrderDetailsForEstimate(orderNum);
				if (list != null && !list.isEmpty()) {
					mav.addObject("list", list);
					mav.addObject("orderInfo", list.get(0));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mav;
	}

	@GetMapping("estimate_download")
	public void estimateDownload(HttpServletRequest req, HttpServletResponse resp) throws Exception {
		String orderNum = req.getParameter("orderNum");
		OrderMapper mapper = MapperContainer.get(OrderMapper.class);
		List<Map<String, Object>> list = mapper.getOrderDetailsForEstimate(orderNum);

		if (list == null || list.isEmpty()) {
			resp.sendError(404, "Order not found");
			return;
		}

		Map<String, Object> orderInfo = list.get(0);

		resp.reset();
		resp.setContentType("application/pdf");

		String fileName = URLEncoder.encode("거래명세서_" + orderNum, "UTF-8").replaceAll("\\+", "%20");
		resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + ".pdf\"");
		resp.setHeader("Content-Transfer-Encoding", "binary");
		resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

		Document document = new Document(PageSize.A4, 50, 50, 50, 50);
		OutputStream out = resp.getOutputStream();
		PdfWriter.getInstance(document, out);

		document.open();

		// 폰트는 에러 안 나는 기본 폰트로 유지
		Font fontTitle = new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD);
		Font fontNormal = new Font(Font.FontFamily.HELVETICA, 10);

		// 1. 제목을 영어로 (영문 폰트에서 한글은 깨지기 때문)
		Paragraph title = new Paragraph("TRANSACTION STATEMENT", fontTitle);
		title.setAlignment(Element.ALIGN_CENTER);
		title.setSpacingAfter(30);
		document.add(title);

		// 2. 기본 정보 영문 표기
		document.add(new Paragraph("Order No : " + orderNum, fontNormal));
		document.add(new Paragraph("Customer : " + orderInfo.get("userName"), fontNormal));
		document.add(new Paragraph("Date : " + orderInfo.get("orderDate"), fontNormal));
		document.add(new Paragraph(" ", fontNormal));

		// 3. 테이블 헤더 영문 표기 (이래야 안 깨지고 정렬이 맞습니다)
		PdfPTable table = new PdfPTable(4);
		table.setWidthPercentage(100);
		String[] headers = { "Product", "Size", "Qty", "Price" };
		for (String h : headers) {
			PdfPCell cell = new PdfPCell(new Phrase(h, fontNormal));
			cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
			cell.setHorizontalAlignment(Element.ALIGN_CENTER);
			table.addCell(cell);
		}

		// 4. 내용 (한글 데이터인 ProductName만 깨질 수 있는데, 이건 어쩔 수 없습니다 ㅠㅠ)
		for (Map<String, Object> item : list) {
			table.addCell(new Phrase(String.valueOf(item.get("productName")), fontNormal));
			table.addCell(new Phrase(String.valueOf(item.get("pdSize")), fontNormal));
			table.addCell(new Phrase(String.valueOf(item.get("qty")), fontNormal));
			table.addCell(new Phrase(String.valueOf(item.get("price")), fontNormal));
		}
		document.add(table);

		document.close();
		out.flush();
		out.close();
	}
	
	@GetMapping("approve")
	public ModelAndView approve(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			OrderMapper mapper = MapperContainer.get(OrderMapper.class);
			String orderNum = req.getParameter("orderNum");
			String claimType = req.getParameter("claimType");
			String productNum = req.getParameter("productNum");
			String pdSize = req.getParameter("pdSize");
			String qtyStr = req.getParameter("qty");

			int qty = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 0;

			Map<String, Object> map = new HashMap<>();
			map.put("orderNum", orderNum);
			map.put("productNum", productNum);
			map.put("pdSize", pdSize);
			map.put("qty", qty);
			map.put("status", "취소".equals(claimType) ? "취소완료" : "반품완료");

			mapper.updateOrderState(map);
			mapper.updateStockIncrease(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new ModelAndView("redirect:/admin/order/claim_list");
	}

}