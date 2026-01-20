<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<jsp:include page="/WEB-INF/views/common/image_config.jsp" />

<c:forEach var="dto" items="${list}">
    <div class="col-6 col-md-4 col-lg-3 product-item-wrap">
        <div class="product-card" onclick="location.href='${pageContext.request.contextPath}/product/detail?prod_id=${dto.prodId}'">
            
            <div class="product-img-box" style="position: relative;">
                
                <div class="wish-icon-btn" onclick="toggleWish('${dto.prodId}', event, this)" 
                     style="position: absolute; top: 10px; right: 10px; z-index: 10; cursor: pointer; font-size: 22px; filter: drop-shadow(0 0 2px rgba(0,0,0,0.3)); transition: transform 0.2s;">
                    <c:choose>
                        <c:when test="${dto.liked}">
                            <i class="fas fa-heart" style="color: #dc3545;"></i> </c:when>
                        <c:otherwise>
                            <i class="fas fa-heart" style="color: #ffffff;"></i> </c:otherwise>
                    </c:choose>
                </div>
            
                <c:if test="${dto.discountRate > 0}">
                    <span class="badge-new" style="background-color: #dc3545;">SALE ${dto.discountRate}%</span>
                </c:if>
                
                <div class="placeholder-div" style="background: white; padding-bottom: 0; height: auto;">
                    <img src="${uploadPath}/${dto.thumbnail}" 
                         alt="${dto.prodName}" 
                         style="width: 100%; aspect-ratio: 1/1; object-fit: cover; display: block;"
                         onerror="this.src='https://dummyimage.com/400x400/eee/999?text=No+Image';">
                </div>
            </div>
            
            <div class="product-info">
                <div class="product-meta">${dto.cateName}</div> 
                
                <h3 class="product-name">${dto.prodName}</h3>
                
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