<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ page import="java.util.*" %>

<%
    // [임시 데이터 생성] DB 연동 전 UI 확인용 Mock Data
    request.setCharacterEncoding("utf-8");
    
    // 파라미터 수신 (페이지, 정렬 등)
    String pageNum = request.getParameter("page");
    int current_page = 1;
    if(pageNum != null) current_page = Integer.parseInt(pageNum);
    
    String sort = request.getParameter("sort");
    if(sort == null) sort = "new";

    // 상품 리스트 생성
    List<Map<String, Object>> mockList = new ArrayList<>();
    String[] names = {"XT-6", "ACS PRO", "SPEEDCROSS 6", "XA PRO 3D", "RX SLIDE 3.0", "SENSE RIDE 5", "QUEST 4 GORE-TEX", "PHANTASM", "SUPERCROSS 4", "PULSAR TRAIL"};
    String[] cats = {"스포츠스타일", "스포츠스타일", "트레일러닝", "하이킹", "샌들/워터슈즈", "트레일러닝", "하이킹", "로드러닝", "트레일러닝", "트레일러닝"};
    int[] prices = {260000, 280000, 190000, 210000, 98000, 170000, 310000, 220000, 150000, 180000};
    
    for(int i=0; i<names.length; i++) {
        Map<String, Object> map = new HashMap<>();
        // [수정] id -> productNo로 변경하여 DTO와 변수명 일치시킴
        map.put("productNo", i+1);
        map.put("name", names[i]);
        map.put("category", cats[i]);
        map.put("price", prices[i]);
        map.put("isNew", i % 3 == 0); // 3번째마다 NEW 뱃지
        map.put("soldOut", false);
        mockList.add(map);
    }
    
    int dataCount = mockList.size();
    int total_page = 1;
    String paging = "<ul class='pagination justify-content-center'><li class='page-item active'><a class='page-link'>1</a></li></ul>"; // 임시 페이징
    
    // request 영역에 저장
    request.setAttribute("list", mockList);
    request.setAttribute("dataCount", dataCount);
    request.setAttribute("page", current_page);
    request.setAttribute("total_page", total_page);
    request.setAttribute("paging", paging);
    request.setAttribute("sort", sort);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>남성 신발 | Salomon</title>

    <!-- Header Resources -->
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    <link rel="/WEB-INF/views/layout/header.css">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Oswald:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
       
    </style>
</head>
<body>

    <!-- Header -->
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="container-fluid" style="max-width: 1600px; padding: 0 40px;">
        
        <!-- Top Area -->
        <header class="page-header">
            <div class="breadcrumbs">
                <a href="${pageContext.request.contextPath}/">Home</a> / <span style="color:#1a1a1a">남성 신발</span>
            </div>
            <h1 class="collection-title">
                남성 신발 <span class="collection-count">[${dataCount}]</span>
            </h1>
        </header>

        <div class="row">
            <!-- Left Sidebar (Filter Form) -->
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
                    
                    <!-- 1. 컬렉션 (스포츠/용도) -->
                    <details class="filter-group" open>
                        <summary class="filter-title">컬렉션</summary>
                        <div class="filter-content">
                            <c:forEach var="sport" items="${['로드러닝', '트레일러닝', '하이킹', '스포츠스타일', '샌들/워터슈즈']}">
                                <label class="custom-check">
                                    <input type="checkbox" name="sports" value="${sport}" onchange="searchList()">
                                    <span>${sport}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </details>
                    
                    <!-- 2. 판매 상태 (품절 제외) -->
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
                                    <!-- JSTL로 param.genders 배열 체크 로직은 복잡하므로 여기선 생략하고 UI만 표시 -->
                                    <input type="checkbox" name="genders" value="${g}" onchange="searchList()">
                                    <span>${g}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </details>

                    <!-- 4. 사이즈 (220~320, 5단위, 둥근 사각형) -->
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

                    <!-- 5. 가격 (0 ~ 1,000,000, 1000단위) -->
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

                    
                    
                    <!-- 정렬 값 유지를 위한 hidden input -->
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

                <!-- 상품 for:each 사용 -->
                <div id="productList" class="row gx-4 gy-5">
                    <c:choose>
                        <c:when test="${not empty list}">
                            <c:forEach var="dto" items="${list}">
                                <div class="col-6 col-md-4 col-lg-3">
                                    <!-- [수정] productNum -> productNo 로 파라미터명 변경 -->
                                    <div class="product-card" onclick="${pageContext.request.contextPath}/product/detail?productNo=${dto.productNo}">
                                        <div class="product-img-box">
                                            <c:if test="${dto.isNew}">
                                                <span class="badge-new">NEW</span>
                                            </c:if>
                                            <!-- 이미지 Placeholder (DB 연동 전 자리잡기용) 여기 빽단 연결하기 --> 
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
                </div>

                <!-- Paging (Mock) -->
                <div class="d-flex justify-content-center mt-5">
                    ${paging}
                </div>
            </main>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

    <script>
    $(document).ready(function() {
        const minGap = 10000;
        const maxPriceLimit = 1000000;
        
        // --- Slider UI Logic ---
        function updateSlider() {
            let minVal = parseInt($('#rangeMin').val());
            let maxVal = parseInt($('#rangeMax').val());

            // Prevent crossing
            if (maxVal - minVal < minGap) {
                if ($(this).attr('id') === 'rangeMin') {
                    $('#rangeMin').val(maxVal - minGap);
                    minVal = maxVal - minGap;
                } else {
                    $('#rangeMax').val(minVal + minGap);
                    maxVal = minVal + minGap;
                }
            }

            // Update UI Bars
            let leftPercent = (minVal / maxPriceLimit) * 100;
            let widthPercent = ((maxVal - minVal) / maxPriceLimit) * 100;

            $('#sliderFill').css('left', leftPercent + '%');
            $('#sliderFill').css('width', widthPercent + '%');

            $('#inputMin').val(minVal.toLocaleString());
            $('#inputMax').val(maxVal.toLocaleString());
        }

        // Bind events
        $('#rangeMin, #rangeMax').on('input', updateSlider);
        
        // Initialize
        updateSlider();
    });

    // --- 필터 로직/ 검색에서도 사용하기  ---
    function searchList() {
        const f = document.searchForm;
        f.submit();
    }

    function changeSort(value) {
        const f = document.searchForm;
        document.getElementById('hiddenSort').value = value;
        f.submit();
    }

    function resetFilters() {
        const f = document.searchForm;
        // Reset Inputs
        const checkboxes = f.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(cb => cb.checked = false);
        
        // Reset Slider
        f.minPrice.value = 0;
        f.maxPrice.value = 1000000;
        
        // Reset Sort
        document.getElementById('hiddenSort').value = 'new';
        
        f.submit();
    }
    </script>
</body>
</html>