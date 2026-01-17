<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head><title>배송조회</title></head>
<body style="text-align:center; padding:50px; font-family:sans-serif;">
    <h2 style="border-bottom:2px solid #000; padding-bottom:10px;">DELIVERY TRACKING</h2>
    <div style="border:1px solid #eee; padding:30px; margin:20px 0;">
        <p>주문번호: ${param.orderNum}</p>
        <h3 style="color:#ff4d4d;">상품 준비 중</h3>
        <p>고객님의 상품을 안전하게 배송하기 위해 준비 중입니다.</p>
    </div>
    <button onclick="window.close()" style="background:#000; color:#fff; padding:10px 30px; border:none; cursor:pointer;">닫기</button>
</body>
</html>