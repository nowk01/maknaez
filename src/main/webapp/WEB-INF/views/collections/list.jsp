<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ page import="java.util.*" %>

<jsp:include page="/WEB-INF/views/common/image_config.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>남성 신발 | MAKNAEZ</title>

    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/list-sidebar.css">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Oswald:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        /* 임시 이미지 플레이스홀더 스타일 */
        .placeholder-div {
            background-color: #f8f9fa; /* 밝은 회색 배경 */
            width: 100%;
            padding-bottom: 100%; /* 1:1 비율 유지 */
            position: relative;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .placeholder-text {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 1.2rem;
            font-weight: 700;
            color: #adb5bd;
        }
        .product-card {
            cursor: pointer;
            transition: transform 0.2s;
        }
        .product-card:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="container-fluid" style="max-width: 1600px; padding: 0 40px; margin-top: 100px;">
        <div class="page-header">
            <div class="breadcrumbs">
                <a href="${pageContext.request.contextPath}/">Home</a> / <span style="color:#1a1a1a">남성 신발</span>
            </div>
            <div class="d-flex justify-content-between align-items-end">
                <h1 class="collection-title">
                    남성 신발 <span class="collection-count">[12]</span> <!-- 더미 개수 -->
                </h1>
                <div class="sort-wrapper" style="margin-bottom:0;">
                    <select id="sortSelect" class="sort-select" onchange="changeSort(this.value)">
                        <option value="new" ${sort == 'new' ? 'selected' : ''}>신상품순</option>
                        <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>낮은가격순</option>
                        <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>높은가격순</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Left Sidebar-->
            <aside class="col-lg-2 d-none d-lg-block sidebar-container">
                <form name="searchForm" action="${pageContext.request.contextPath}/collections/list.jsp" method="post">
                    <input type="hidden" name="page" value="1">

                    <div class="sidebar-header">
                        <span class="sidebar-title">필터</span>
                        <button type="button" class="btn-reset-large" onclick="resetFilters()">
                            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" style="margin-right:8px;">
                                <path d="M4.33317 2.33341C2.72384 3.25141 1.6665 5.01475 1.6665 7.00008C1.6665 8.05491 1.9793 9.08606 2.56533 9.96312C3.15137 10.8402 3.98432 11.5238 4.95886 11.9274C5.9334 12.3311 7.00575 12.4367 8.04032 12.2309C9.07488 12.0251 10.0252 11.5172 10.7711 10.7713C11.517 10.0254 12.0249 9.07513 12.2307 8.04056C12.4365 7.006 12.3309 5.93364 11.9272 4.9591C11.5235 3.98456 10.8399 3.15161 9.96288 2.56558C9.08582 1.97954 8.05467 1.66675 6.99984 1.66675" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                                <path d="M4.33317 5.00016V2.3335H1.6665" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                            </svg>
                            필터 초기화
                        </button>
                    </div>

                    <!-- 1. 컬렉션-->
                    <details class="filter-group" open>
                        <summary class="filter-title">카테고리</summary>
                        <div class="filter-content">
                            <c:forEach var="sport" items="${['로드러닝', '트레일러닝', '하이킹', '스포츠스타일', '샌들/워터슈즈']}">
                                <label class="custom-check">
                                    <input type="checkbox" name="sports" value="${sport}" onchange="searchList()">
                                    <span>${sport}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </details>

                    <!-- 2. 판매 상태 -->
                    <details class="filter-group" open>
                        <summary class="filter-title">판매 상태</summary>
                        <div class="filter-content">
                            <label class="custom-check">
                                <input type="checkbox" name="excludeSoldOut" value="true" onchange="searchList()" ${param.excludeSoldOut == 'true' ? 'checked' : ''}>
                                <span>품절 상품 제외</span>
                            </label>
                        </div>
                    </details>

                    <!-- 3. 성별 -->
                    <details class="filter-group" open>
                        <summary class="filter-title">성별</summary>
                        <div class="filter-content">
                            <c:forEach var="g" items="${['남성', '여성', 'Unisex']}">
                                <label class="custom-check">
                                    <input type="checkbox" name="genders" value="${g}" onchange="searchList()">
                                    <span>${g}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </details>

                    <!-- 4. 사이즈 -->
                    <details class="filter-group" open>
                        <summary class="filter-title">사이즈</summary>
                        <div class="filter-content">
                            <div class="size-grid">
                                <c:forEach var="i" begin="220" end="320" step="5">
                                    <label class="size-btn">
                                        <input type="checkbox" name="sizes" value="${i}" onchange="searchList()">
                                        <span>${i}</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </details>

                    <!-- 5. 가격 -->
                    <details class="filter-group" open>
                        <summary class="filter-title">가격</summary>
                        <div class="filter-content">
                            <div class="price-slider">
                                <div class="slider-track"></div>
                                <div id="sliderFill" class="slider-fill" style="left:0%; width:100%;"></div>
                                <input type="range" id="rangeMin" name="minPrice" min="0" max="1000000" step="1000" value="${param.minPrice != null ? param.minPrice : 0}" onchange="searchList()">
                                <input type="range" id="rangeMax" name="maxPrice" min="0" max="1000000" step="1000" value="${param.maxPrice != null ? param.maxPrice : 1000000}" onchange="searchList()">
                            </div>
                            <div class="price-inputs">
                                <div class="price-input-group">
                                    <span>₩</span>
                                    <input type="text" id="inputMin" value="0" readonly>
                                </div>
                                <div class="price-input-group">
                                    <span>₩</span>
                                    <input type="text" id="inputMax" value="1,000,000" readonly>
                                </div>
                            </div>
                        </div>
                    </details>

                    <!-- 6. 색상 -->
                    <details class="filter-group" open>
                        <summary class="filter-title">색상</summary>
                        <div class="filter-content">
                            <div class="color-list">
                                <c:set var="colorList" value="${[{'name':'블랙','hex':'#000000'}, {'name':'화이트','hex':'#FFFFFF'}, {'name':'그레이','hex':'#808080'}, {'name':'레드','hex':'#E32526'}, {'name':'블루','hex':'#0057B8'}, {'name':'그린','hex':'#006F44'}, {'name':'베이지','hex':'#DBCFB6'}, {'name':'브라운','hex':'#6E4E37'}, {'name':'옐로우','hex':'#FFD100'}]}" />
                                <c:forEach var="color" items="${colorList}">
                                    <label class="color-swatch" title="${color.name}">
                                        <input type="checkbox" name="colors" value="${color.name}" onchange="searchList()">
                                        <span style="background-color: ${color.hex}; ${color.name eq '화이트' ? 'border:1px solid #ddd;' : ''}"></span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </details>

                    <input type="hidden" name="sort" id="hiddenSort" value="${sort}">
                </form>
            </aside>

            <!-- Main Content -->
            <main class="col-12 col-lg-10">
                <!-- Sorting -->
                <div class="sort-wrapper">
                    <select id="sortSelect" class="sort-select" onchange="changeSort(this.value)">
                        <option value="new" ${sort == 'new' ? 'selected' : ''}>신상품순</option>
                        <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>낮은가격순</option>
                        <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>높은가격순</option>
                    </select>
                </div>

                <!-- 상품 목록 영역 -->
                <div id="productList" class="row gx-4 gy-5">
                    
                    <%-- 백단 작업 전 가라 데이터 --%>
                    <c:forEach var="i" begin="1" end="12">
                        <div class="col-6 col-md-4 col-lg-3">
                            <!-- 링크 연결: productNo=${i} 로 더미 파라미터 전달 -->
                            <div class="product-card" onclick="location.href='${pageContext.request.contextPath}/product/detail?productNo=${i}'">
                                <div class="product-img-box">
                                    <c:if test="${i % 3 == 0}">
                                        <span class="badge-new">NEW</span>    
                                    </c:if>
                                    <!-- 이미지 대신 텍스트로 위치 잡기 --> 
                                    <div class="placeholder-div">
                                        <span class="placeholder-text">신발 ${i}</span>
                                    </div>
                                </div>
                                <div class="product-info">
                                    <div class="product-meta">남성 라이프스타일</div>
                                    <h3 class="product-name">나이키 에어 포스 1 '07 (${i}번)</h3>
                                    <div class="product-price">₩<fmt:formatNumber value="${139000 + (i * 1000)}" pattern="#,###" /></div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <%-- 실제 데이터 처리단 --%>
                    <%--
                    <c:choose>
                        <c:when test="${not empty list}">
                            <c:forEach var="dto" items="${list}">
                                <div class="col-6 col-md-4 col-lg-3">
                                    <div class="product-card" onclick="location.href='${pageContext.request.contextPath}/product/detail?productNo=${dto.productNo}'">
                                        <div class="product-img-box">
                                            <c:if test="${dto.isNew}">
                                                <span class="badge-new">NEW</span>	
                                            </c:if>
                                            <div class="placeholder-div">
                                                상품 이미지 
                                            </div>
                                        </div>
                                        <div class="product-info">
                                            <div class="product-meta">${dto.category}</div>
                                            <h3 class="product-name">${dto.name}</h3>
                                            <div class="product-price">₩<fmt:formatNumber value="${dto.price}" pattern="#,###" /></div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col-12 text-center py-5">
                                <h4>조건에 맞는 상품이 없습니다.</h4>
                                <p class="text-muted">필터를 변경하거나 초기화해보세요.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    --%>
                </div>

                <!-- Paging (Mock) -->
                <div class="d-flex justify-content-center mt-5">
                    ${paging}
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
    
    <script>
        function changeSort(val) {
            location.href = '?sort=' + val;
        }
        function resetFilters() {
            location.href = 'list.jsp';
        }
        
        // 간단한 검색용 JS 함수 (실제 구현 시 form submit으로 변경)
        function searchList() {
            // document.searchForm.submit(); // DB 연동 시 주석 해제
            console.log("필터 변경됨");
        }
    </script>
</body>
</html>