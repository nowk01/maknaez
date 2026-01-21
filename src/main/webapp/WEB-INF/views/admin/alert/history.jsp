<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Alert History - Admin System</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />

<style>
body { background-color: #f5f6f8; color: #222; }

.content-container {
    padding: 50px 60px;
    min-height: 100vh;
    animation: fadeIn 0.5s ease-out;
}

@keyframes fadeIn {from { opacity:0;
	transform: translateY(10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}
}

.history-header {
    margin-bottom: 40px;
    padding-bottom: 25px;
    border-bottom: 1px solid #dee2e6;
}

.history-title {
    font-size: 28px;
    font-weight: 900;
    color: #1a1a1a;
    display: flex;
    align-items: center;
    gap: 12px;
}

.title-icon {
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, #ff4e00, #ff8c00);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #fff;
    font-size: 18px;
    box-shadow: 0 4px 10px rgba(255, 78, 0, 0.2);
}

.history-title span {
    font-size: 15px;
    color: #888;
    font-weight: 500;
    margin-left: 5px;
}

.history-list { display: flex; flex-direction: column; gap: 15px; }

.history-item {
    background: #fff;
    border-radius: 16px;
    padding: 25px;
    display: flex;
    align-items: center;
    gap: 20px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.03);
    border: 1px solid #ebebeb;
    transition: all 0.2s cubic-bezier(0.25, 0.8, 0.25, 1);
    cursor: pointer;
    position: relative;
    overflow: hidden;
}

.history-item:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.06);
    border-color: #ff4e00;
}

.h-icon {
    width: 52px; height: 52px;
    border-radius: 14px;
    display: flex; align-items: center; justify-content: center;
    font-size: 20px; color: #fff;
    flex-shrink: 0;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}
.type-order .h-icon { background: linear-gradient(135deg, #3b82f6, #2563eb); }
.type-inquiry .h-icon { background: linear-gradient(135deg, #f97316, #ea580c); }

.h-content { flex-grow: 1; }
.h-top { display: flex; justify-content: space-between; margin-bottom: 6px; }
.h-type { font-size: 12px; font-weight: 800; color: #999; text-transform: uppercase; }
.h-date { font-size: 13px; color: #bbb; font-family: 'Consolas', monospace; }
.h-msg { font-size: 16px; font-weight: 700; color: #333; }

.no-data { padding: 100px 0; text-align: center; color: #ccc; }
</style>
</head>
<body>

    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <div class="history-header">
                    <div class="history-title">
                        <div class="title-icon">
                            <i class="fas fa-bell"></i>
                        </div>
                        Alert Center <span>(${list.size()} Logs)</span>
                    </div>
                </div>

                <div class="history-list">
                    <c:choose>
                        <c:when test="${empty list}">
                            <div class="no-data">
                                <i class="fas fa-bell-slash" style="font-size: 40px; margin-bottom: 10px;"></i>
                                <p>수신된 알림 로그가 없습니다.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="dto" items="${list}">
                                <div class="history-item ${dto.TYPE == 'order' ? 'type-order' : 'type-inquiry'}" 
                                     onclick="location.href='${pageContext.request.contextPath}${dto.URL}'">
                                    
                                    <div class="h-icon">
                                        <i class="fas ${dto.TYPE == 'order' ? 'fa-shopping-bag' : 'fa-comment-dots'}"></i>
                                    </div>
                                    
                                    <div class="h-content">
                                        <div class="h-top">
                                            <span class="h-type">${dto.TYPE == 'order' ? '주문 발생' : '문의 접수'}</span>
                                            <span class="h-date">${dto.REG_DATE}</span>
                                        </div>
                                        <div class="h-msg">${dto.CONTENT}</div>
                                    </div>
                                    
                                    <div style="color:#eee;"><i class="fas fa-chevron-right"></i></div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
    <jsp:include page="/WEB-INF/views/admin/layout/footer.jsp" />

</body>
</html>