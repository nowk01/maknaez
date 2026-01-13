<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!-- 이미지 경로 변수 설정 -->
<jsp:include page="/WEB-INF/views/common/image_config.jsp" />

<c:forEach var="dto" items="${list}">
    <div class="col-lg-4 col-md-6 col-sm-12 pb-1 product-item-wrap">
        <div class="card product-item border-0 mb-4">
            <div class="card-header product-img position-relative overflow-hidden bg-transparent border p-0">
                
                <!-- 할인 뱃지 -->
                <c:if test="${dto.discountRate > 0}">
                    <div class="position-absolute top-0 end-0 bg-danger text-white px-2 py-1 m-2 rounded" style="z-index: 10; font-weight: bold; font-size: 0.8rem;">
                        -${dto.discountRate}%
                    </div>
                </c:if>
                
                <!-- 썸네일 이미지 -->
                <a href="${pageContext.request.contextPath}/product/detail?prod_id=${dto.prodId}">
                    <img class="img-fluid w-100" 
                         src="${uploadPath}/${dto.thumbnail}" 
                         alt="${dto.prodName}"
                         style="height: 300px; object-fit: cover;"
                         onerror="this.src='https://dummyimage.com/450x300/dee2e6/6c757d.jpg&text=No+Image';">
                </a>
            </div>
            
            <div class="card-body border-left border-right text-center p-0 pt-4 pb-3">
                <h6 class="text-truncate mb-3">${dto.prodName}</h6>
                <div class="d-flex justify-content-center align-items-center">
                    <c:choose>
                        <c:when test="${dto.discountRate > 0}">
                            <!-- 할인 시: 원가(취소선) + 할인가 -->
                            <h6 class="text-muted ml-2" style="text-decoration: line-through; margin-right:10px;">
                                <fmt:formatNumber value="${dto.price}" pattern="#,###"/>
                            </h6>
                            <h6 class="text-danger mb-0"><fmt:formatNumber value="${dto.salePrice}" pattern="#,###"/>원</h6>
                        </c:when>
                        <c:otherwise>
                            <!-- 정가 -->
                            <h6 class="mb-0"><fmt:formatNumber value="${dto.price}" pattern="#,###"/>원</h6>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="card-footer d-flex justify-content-between bg-light border">
                <a href="${pageContext.request.contextPath}/product/detail?prod_id=${dto.prodId}" class="btn btn-sm text-dark p-0">
                    <i class="fas fa-eye text-primary mr-1"></i>상세보기
                </a>
                <a href="#" class="btn btn-sm text-dark p-0">
                    <i class="fas fa-shopping-cart text-primary mr-1"></i>담기
                </a>
            </div>
        </div>
    </div>
</c:forEach>