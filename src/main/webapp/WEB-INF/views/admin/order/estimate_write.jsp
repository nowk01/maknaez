<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>견적서 작성 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/admin_estimate_list.css">
    <style>
        .estimate-wrapper { padding: 30px; background: #f8f9fa; min-height: 100vh; }
        .estimate-paper {
            background: #fff; padding: 60px; border-radius: 4px;
            box-shadow: 0 0 30px rgba(0,0,0,0.08); max-width: 900px; margin: 0 auto;
            position: relative; border-top: 8px solid #ff4e00;
        }
        .estimate-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 50px; }
        .estimate-title { font-size: 38px; font-weight: 900; color: #1a1c1e; letter-spacing: -1px; }
        
        .info-section { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-bottom: 40px; }
        .info-title { font-size: 13px; font-weight: 800; color: #ff4e00; text-transform: uppercase; margin-bottom: 15px; border-bottom: 1px solid #eee; padding-bottom: 5px; }
        .info-table { width: 100%; }
        .info-table th { text-align: left; font-size: 13px; color: #888; padding: 6px 0; width: 80px; }
        .info-table td { font-size: 14px; font-weight: 600; color: #333; padding: 6px 0; }

        .prod-table { width: 100%; border-collapse: collapse; margin-bottom: 40px; }
        .prod-table th { background: #fbfbfb; border-bottom: 2px solid #1a1c1e; padding: 12px 10px; font-size: 12px; font-weight: 700; color: #555; text-align: center; }
        .prod-table td { padding: 15px 10px; border-bottom: 1px solid #eee; font-size: 14px; vertical-align: middle; }
        
        .total-banner {
            background: #1a1c1e; color: #fff; padding: 25px 35px;
            display: flex; justify-content: space-between; align-items: center; border-radius: 2px;
        }
        .total-banner .label { font-size: 16px; font-weight: 500; opacity: 0.8; }
        .total-banner .amount { font-size: 28px; font-weight: 900; color: #ff4e00; }

        .action-btns { margin-top: 50px; display: flex; justify-content: center; gap: 12px; }
        .btn-black { background: #1a1c1e; color: #fff; border: none; padding: 15px 45px; font-weight: 700; font-size: 14px; cursor: pointer; transition: 0.3s; }
        .btn-outline { background: #fff; color: #666; border: 1px solid #ddd; padding: 15px 45px; font-weight: 700; font-size: 14px; cursor: pointer; }
        .btn-black:hover { background: #ff4e00; }

        @media print {
            body { background: #fff; }
            .estimate-wrapper { padding: 0; }
            .estimate-paper { box-shadow: none; border: none; width: 100%; max-width: 100%; padding: 0; }
            .action-btns, #wrapper > .sidebar, #page-content-wrapper > header { display: none !important; }
        }
    </style>
</head>
<body>
    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="estimate-wrapper">
                <div class="estimate-paper">
                    <div class="estimate-header">
                        <div>
                            <div class="estimate-title">OFFICIAL QUOTE</div>
                            <p style="color:#888; font-size:13px; margin-top:5px;">Professional Footwear Solutions</p>
                        </div>
                        <div style="text-align:right;">
                            <p style="font-weight:800; font-size:15px;"># ${orderInfo.orderNum}</p>
                            <p style="color:#666; font-size:13px;">Issue Date: ${orderInfo.orderDate}</p>
                        </div>
                    </div>

                    <div class="info-section">
                        <div class="info-box">
                            <div class="info-title">Client Information</div>
                            <table class="info-table">
                                <tr><th>Customer</th><td>${orderInfo.userName} (${orderInfo.userId})</td></tr>
                                <tr><th>Contact</th><td>${orderInfo.tel}</td></tr>
                                <tr><th>Email</th><td>${orderInfo.email}</td></tr>
                            </table>
                        </div>
                        <div class="info-box">
                            <div class="info-title">MAKNAEZ Company</div>
                            <table class="info-table">
                                <tr><th>Business</th><td>(주) MAKNAEZ 슈즈</td></tr>
                                <tr><th>CEO</th><td>Jiyoung (지영)</td></tr>
                                <tr><th>Address</th><td>Seoul, Gangnam-gu, Teheran-ro 123</td></tr>
                            </table>
                        </div>
                    </div>

                    <table class="prod-table">
                        <thead>
                            <tr>
                                <th style="width:80px;">IMAGE</th>
                                <th>DESCRIPTION</th>
                                <th style="width:120px;">UNIT PRICE</th>
                                <th style="width:70px;">QTY</th>
                                <th style="width:140px;">TOTAL</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${list}">
                                <tr>
                                    <td style="text-align:center;">
                                        <img src="${pageContext.request.contextPath}/uploads/product/${item.thumbNail}" 
                                             style="width:55px; height:55px; object-fit:cover; border:1px solid #f0f0f0;"
                                             onerror="this.src='${pageContext.request.contextPath}/dist/images/no-image.png';">
                                    </td>
                                    <td>
                                        <div style="font-weight:700; color:#1a1c1e;">${item.productName}</div>
                                        <div style="font-size:12px; color:#999; margin-top:3px;">Option: ${item.pdSize}</div>
                                    </td>
                                    <td style="text-align:right; font-family: 'Montserrat';">
                                        <fmt:formatNumber value="${item.price}" pattern="#,###"/> 원
                                    </td>
                                    <td style="text-align:center; font-weight:700;">${item.qty}</td>
                                    <td style="text-align:right; font-weight:800; color:#1a1c1e; font-family: 'Montserrat';">
                                        <fmt:formatNumber value="${item.price * item.qty}" pattern="#,###"/> 원
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="total-banner">
                        <span class="label">FINAL ESTIMATED TOTAL (VAT Incl.)</span>
                        <span class="amount">
                            <fmt:formatNumber value="${orderInfo.totalAmount}" pattern="#,###"/> KRW
                        </span>
                    </div>

                    <div class="action-btns">
                        <button type="button" class="btn-black" onclick="window.print()">PRINT / DOWNLOAD PDF</button>
                        <button type="button" class="btn-outline" onclick="history.back()">BACK TO LIST</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
</body>
</html>