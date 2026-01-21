<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<style>
    #alertListContainer {
        background: #fff;
    }

    .noti-item {
        padding: 16px 20px;
        display: flex;
        align-items: center;
        gap: 16px;
        border-bottom: 1px solid #f5f5f5;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.25, 0.8, 0.25, 1);
        position: relative;
        background: #fff;
    }
    
    .noti-item:hover {
        background: #f8f9fc;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        z-index: 10;
    }

    .noti-icon {
        width: 48px;
        height: 48px;
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #fff;
        font-size: 20px;
        flex-shrink: 0;
        box-shadow: 0 4px 10px rgba(0,0,0,0.15);
    }

    .bg-order {
        background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
    }
    
    .bg-inquiry {
        background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
    }

    .noti-text {
        flex-grow: 1;
        overflow: hidden;
    }
    
    .noti-text .msg {
        font-size: 14px;
        font-weight: 600;
        color: #333;
        margin: 0 0 5px 0;
        line-height: 1.4;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    
    .noti-text .time {
        font-size: 12px;
        color: #888;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 4px;
    }
    
    .noti-text .time::before {
        content: '';
        display: block;
        width: 4px;
        height: 4px;
        background-color: #ddd;
        border-radius: 50%;
    }

    .empty-noti {
        padding: 60px 0;
        text-align: center;
        color: #ccc;
    }
    .empty-noti i {
        font-size: 48px;
        margin-bottom: 12px;
        color: #e0e0e0;
    }
    .empty-noti p {
        font-size: 14px;
        margin: 0;
    }
</style>


<c:choose>
    <c:when test="${empty list}">
        <div class="empty-noti">
            <i class="fas fa-bell-slash"></i>
            <p>새로운 알림이 없습니다.</p>
        </div>
        <input type="hidden" id="ajaxAlertCount" value="0">
    </c:when>

    <c:otherwise>
        <input type="hidden" id="ajaxAlertCount" value="${list.size()}">

        <c:forEach var="dto" items="${list}">
            <div class="noti-item" onclick="location.href='${pageContext.request.contextPath}${dto.URL}'">
                
                <div class="noti-icon ${dto.TYPE == 'order' ? 'bg-order' : 'bg-inquiry'}">
                    <i class="fas ${dto.TYPE == 'order' ? 'fa-box' : 'fa-comment-dots'}"></i>
                </div>
                
                <div class="noti-text">
                    <p class="msg">${dto.CONTENT}</p>
                    <span class="time">${dto.REG_DATE}</span>
                </div>
            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>