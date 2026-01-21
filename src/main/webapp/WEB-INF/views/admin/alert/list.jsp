<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<style>
    /* 안 읽은 알림: 주황색 포인트 + 밝은 배경 + 선명함 */
    .noti-item.unread {
        background-color: #fff9f5 !important;
        border-left: 4px solid #ff4e00 !important;
        opacity: 1 !important; /* 무조건 선명하게 */
    }
    .noti-item.unread .msg {
        color: #000 !important;
        font-weight: 700 !important;
    }
    
    /* 기본(읽은) 알림: 흐리게 처리 */
    .noti-item {
        padding: 16px 20px;
        display: flex;
        align-items: center;
        gap: 15px;
        border-bottom: 1px solid #f0f0f0;
        cursor: pointer;
        transition: all 0.2s;
        background: #fff;
        opacity: 0.5; /* 읽은 건 기본적으로 흐림 */
    }
    .noti-item:hover {
        background-color: #f8f9fa !important;
        opacity: 1;
    }
</style>

<c:choose>
    <c:when test="${empty list}">
        <div class="empty-noti" style="padding: 40px 0; text-align: center; color: #ccc;">
            <i class="fas fa-bell-slash" style="font-size: 30px; margin-bottom: 10px;"></i>
            <p>새로운 알림이 없습니다.</p>
        </div>
        <input type="hidden" id="ajaxAlertCount" value="0">
    </c:when>
    <c:otherwise>
        <input type="hidden" id="ajaxAlertCount" value="${list.size()}">
        <c:forEach var="dto" items="${list}">
            <c:set var="idx" value="${not empty dto.ALERTIDX ? dto.ALERTIDX : dto.alertIdx}" />
            <c:set var="isRead" value="${not empty dto.ISREAD ? dto.ISREAD : (not empty dto.isRead ? dto.isRead : 0)}" />
            <c:set var="type" value="${not empty dto.TYPE ? dto.TYPE : dto.type}" />
            <c:set var="dataIdx" value="${not empty dto.DATAIDX ? dto.DATAIDX : dto.dataIdx}" />
            
            <c:set var="moveUrl" value="${pageContext.request.contextPath}/admin/cs/inquiry_list?num=${dataIdx}" />
            <c:if test="${type == 'order'}">
                <c:set var="moveUrl" value="${pageContext.request.contextPath}/admin/order/order_list?orderNum=${dataIdx}" />
            </c:if>

            <div class="noti-item ${isRead == 0 ? 'unread' : ''}" 
                 data-alert-idx="${idx}" 
                 data-url="${moveUrl}">      
                <div class="noti-icon ${type == 'order' ? 'bg-order' : 'bg-inquiry'}" 
                     style="width:40px; height:40px; border-radius:12px; display:flex; align-items:center; justify-content:center; color:#fff; flex-shrink:0;">
                    <i class="fas ${type == 'order' ? 'fa-shopping-cart' : 'fa-comment-dots'}"></i>
                </div>
                <div class="noti-text" style="flex:1; overflow:hidden;">
                    <p class="msg" style="margin:0 0 3px 0; font-size:13px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                        ${not empty dto.CONTENT ? dto.CONTENT : dto.content}
                    </p>
                    <span class="time" style="font-size:11px; color:#999;">
                        ${not empty dto.REG_DATE ? dto.REG_DATE : dto.regDate}
                    </span>
                </div>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>