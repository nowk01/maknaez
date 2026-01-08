<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ page import="java.util.*" %>

<%
    request.setCharacterEncoding("utf-8");
    String sort = request.getParameter("sort");
    if(sort == null) sort = "new";

    // [임시 데이터] 이미지 변수 없이 기본 정보만 생성
    List<Map<String, Object>> mockList = new ArrayList<>();
    String[] names = {"XT-6", "ACS PRO", "SPEEDCROSS 6", "XA PRO 3D", "RX SLIDE 3.0", "SENSE RIDE 5", "QUEST 4 GTX", "PHANTASM", "SUPERCROSS 4", "PULSAR TRAIL"};
    String[] cats = {"스포츠스타일", "스포츠스타일", "트레일러닝", "하이킹", "샌들", "트레일러닝", "하이킹", "로드러닝", "트레일러닝", "트레일러닝"};
    int[] prices = {260000, 280000, 190000, 210000, 98000, 170000, 310000, 220000, 150000, 180000};
    
    for(int i=0; i<names.length; i++) {
        Map<String, Object> map = new HashMap<>();
        map.put("productNo", i+1);
        map.put("name", names[i]);
        map.put("category", cats[i]);
        map.put("price", prices[i]);
        map.put("isNew", i % 3 == 0); 
        mockList.add(map);
    }
    
    request.setAttribute("list", mockList);
    request.setAttribute("dataCount", mockList.size());
    request.setAttribute("sort", sort);
    String paging = "<ul class='pagination justify-content-center'><li class='page-item active'><a class='page-link'>1</a></li></ul>"; 
    request.setAttribute("paging", paging);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>남성 신발 | MAKNAEZ</title>

    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/list-sidebar.css">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Oswald:wght@400;500;600&display=swap" rel="stylesheet">
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="container-fluid" style="max-width: 1600px; padding: 0 40px; margin-top: 100px;">
        
        <header class="page-header">
            <div class="breadcrumbs">
                <a href="${pageContext.request.contextPath}/">Home</a> / <span style="color:#1a1a1a">남성 신발</span>
            </div>
            <div class="d-flex justify-content-between align-items-end">
                <h1 class="collection-title">
                    남성 신발 <span class="collection-count">[${dataCount}]</span>
                </h1>
                <div class="sort-wrapper" style="margin-bottom:0;">
                    <select id="sortSelect" class="sort-select" onchange="changeSort(this.value)">
                        <option value="new" ${sort == 'new' ? 'selected' : ''}>신상품순</option>
                        <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>낮은가격순</option>
                        <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>높은가격순</option>
                    </select>
                </div>
            </div>
        </header>

        <div class="row">
            <aside class="col-lg-2 d-none d-lg-block sidebar-container">
                <form name="searchForm" action="${pageContext.request.contextPath}/collections/list.jsp" method="post">
                    <input type="hidden" name="page" value="1">
                    <div class="sidebar-header">
                        <span class="sidebar-title">필터</span>
                        <button type="button" class="btn-reset-large" onclick="resetFilters()">
                            <i class="ph ph-arrow-counter-clockwise" style="margin-right:5px;"></i> 필터 초기화
                        </button>
                    </div>
                    
                    <details class="filter-group" open><summary class="filter-title">컬렉션</summary>
                        <div class="filter-content">
                            <c:forEach var="sport" items="${['로드러닝', '트레일러닝', '하이킹', '스포츠스타일', '샌들/워터슈즈']}">
                                <label class="custom-check"><input type="checkbox" name="sports" value="${sport}" onchange="searchList()"><span>${sport}</span></label>
                            </c:forEach>
                        </div>
                    </details>
                    
                    <details class="filter-group" open><summary class="filter-title">사이즈</summary>
                        <div class="filter-content">
                            <div class="size-grid">
                                <c:forEach var="i" begin="220" end="320" step="5">
                                    <label class="size-btn"><input type="checkbox" name="sizes" value="${i}" onchange="searchList()"><span>${i}</span></label>
                                </c:forEach>
                            </div>
                        </div>
                    </details>
                    
                    <details class="filter-group" open><summary class="filter-title">가격</summary>
                        <div class="filter-content">
                            <div class="price-slider">
                                <div class="slider-track"></div>
                                <div id="sliderFill" class="slider-fill" style="left:0%; width:100%;"></div>
                                <input type="range" id="rangeMin" name="minPrice" min="0" max="1000000" step="1000" value="${param.minPrice != null ? param.minPrice : 0}" onchange="searchList()">
                                <input type="range" id="rangeMax" name="maxPrice" min="0" max="1000000" step="1000" value="${param.maxPrice != null ? param.maxPrice : 1000000}" onchange="searchList()">
                            </div>
                            <div class="price-inputs">
                                <div class="price-input-group"><span>₩</span><input type="text" id="inputMin" value="0" readonly></div>
                                <div class="price-input-group"><span>₩</span><input type="text" id="inputMax" value="1,000,000" readonly></div>
                            </div>
                        </div>
                    </details>

                    <details class="filter-group" open><summary class="filter-title">색상</summary>
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

            <main class="col-12 col-lg-10">
                <div id="productList" class="row gx-3 gy-5">
                    <c:choose>
                        <c:when test="${not empty list}">
                            <c:forEach var="dto" items="${list}">
                                <div class="col-6 col-md-4 col-lg-3">
                                    <div class="product-card" onclick="location.href='${pageContext.request.contextPath}/product/detail?productNo=${dto.productNo}'">
                                        <div class="placeholder-div">
                                            <c:if test="${dto.isNew}">
                                                <span class="badge-new">NEW</span>
                                            </c:if>
                                            <span class="placeholder-text">상품 이미지</span>
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
                            <div class="col-12 text-center py-5"><h4>조건에 맞는 상품이 없습니다.</h4></div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="d-flex justify-content-center mt-5">${paging}</div>
            </main>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
    
    <script src="${pageContext.request.contextPath}/resources/js/list.js"></script>
</body>
</html>