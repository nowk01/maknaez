<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!-- 이미지 경로 변수 설정 -->
<jsp:include page="/WEB-INF/views/common/image_config.jsp" />

<c:forEach var="dto" items="${list}">
    <div class="col-6 col-md-4 col-lg-3 product-item-wrap">
        <!-- 클릭 시 상세 페이지 이동 -->
        <div class="product-card" onclick="location.href='${pageContext.request.contextPath}/product/detail?prod_id=${dto.prodId}'">
            
            <div class="product-img-box">
                <!-- 할인 뱃지 -->
                <c:if test="${dto.discountRate > 0}">
                    <span class="badge-new" style="background-color: #dc3545;">SALE ${dto.discountRate}%</span>
                </c:if>
                
                <!-- 신상품 뱃지 (예시: 필요 시 로직 추가) -->
                <!-- <span class="badge-new">NEW</span> -->
                
                <div class="placeholder-div" style="background: white; padding-bottom: 0; height: auto;">
                    <!-- 썸네일 이미지 -->
                    <img src="${uploadPath}/${dto.thumbnail}" 
                         alt="${dto.prodName}" 
                         style="width: 100%; aspect-ratio: 1/1; object-fit: cover; display: block;"
                         onerror="this.src='https://dummyimage.com/400x400/eee/999?text=No+Image';">
                </div>
            </div>
            
            <div class="product-info">
                <!-- 카테고리명 -->
                <div class="product-meta">${dto.cateName}</div> 
                
                <!-- 상품명 -->
                <h3 class="product-name">${dto.prodName}</h3>
                
                <!-- 가격 -->
                <div class="product-price">
                    <c:choose>
                        <c:when test="${dto.discountRate > 0}">
                            <span style="text-decoration: line-through; color: #999; margin-right: 5px; font-size: 0.9em;">
                                ₩<fmt:formatNumber value="${dto.originalPrice}" pattern="#,###" />
                            </span>
                            <span style="color: #dc3545; font-weight: bold;">
                                ₩<fmt:formatNumber value="${dto.salePrice}" pattern="#,###" />
                            </span>
                        </c:when>
                        <c:otherwise>
                            ₩<fmt:formatNumber value="${dto.price}" pattern="#,###" />
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</c:forEach>