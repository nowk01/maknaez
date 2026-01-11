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
    <title> ${categoryName} | MAKNAEZ</title>

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
        
        /* 슬라이더 스타일 */
        .price-slider {
            background-color: #e0e0e0;
        }
        .slider-fill {
            background-color: #111;
        }
        
        /* 로딩 중일 때 리스트 영역 흐리게 처리 (선택사항) */
        .loading-overlay {
            opacity: 0.5;
            pointer-events: none;
            transition: opacity 0.2s;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div class="container-fluid" style="max-width: 1600px; padding: 0 40px; margin-top: 100px;">
        <div class="page-header">
            <div class="breadcrumbs">
                <a href="${pageContext.request.contextPath}/">Home</a> / <span style="color:#1a1a1a">${categoryName}</span>
            </div>
            <div class="d-flex justify-content-between align-items-end">
                <h1 class="collection-title">
                    ${categoryName} <span class="collection-count">[12]</span> <!-- 더미 개수 -->
                </h1>
                <div class="sort-wrapper" style="margin-bottom:0;">
                    <select id="sortSelect" class="sort-select" onchange="changeSort(this.value)">
                        <option value="new" ${param.sort == 'new' ? 'selected' : ''}>신상품순</option>
                        <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>낮은가격순</option>
                        <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>높은가격순</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Left Sidebar-->
            <aside class="col-lg-2 d-none d-lg-block sidebar-container">
                <form name="searchForm" action="${pageContext.request.contextPath}/collections/list" method="get">
                    <input type="hidden" name="page" value="1">
                    <input type="hidden" name="category" value="${categoryCode}">

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

                    <!-- 1. 컬렉션 -->
                    <details class="filter-group" open>
                        <summary class="filter-title">카테고리</summary>
                        <div class="filter-content">
                            <c:forEach var="sport" items="${['로드러닝', '트레일러닝', '하이킹', '스포츠스타일', '샌들/워터슈즈']}">
                                <c:set var="isSportChecked" value="false"/>
                                <c:if test="${not empty paramValues.sports}">
                                    <c:forEach var="val" items="${paramValues.sports}">
                                        <c:if test="${val eq sport}">
                                            <c:set var="isSportChecked" value="true"/>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                <label class="custom-check">
                                    <input type="checkbox" name="sports" value="${sport}" onchange="searchList()" ${isSportChecked ? 'checked' : ''}>
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
                                <c:set var="isGenderChecked" value="false"/>
                                <c:if test="${not empty paramValues.genders}">
                                    <c:forEach var="val" items="${paramValues.genders}">
                                        <c:if test="${val eq g}">
                                            <c:set var="isGenderChecked" value="true"/>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                <label class="custom-check">
                                    <input type="checkbox" name="genders" value="${g}" onchange="searchList()" ${isGenderChecked ? 'checked' : ''}>
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
                                    <c:set var="sizeStr" value="${String.valueOf(i)}"/>
                                    <c:set var="isSizeChecked" value="false"/>
                                    <c:if test="${not empty paramValues.sizes}">
                                        <c:forEach var="val" items="${paramValues.sizes}">
                                            <c:if test="${val eq sizeStr}">
                                                <c:set var="isSizeChecked" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                    <label class="size-btn">
                                        <input type="checkbox" name="sizes" value="${i}" onchange="searchList()" ${isSizeChecked ? 'checked' : ''}>
                                        <span>${i}</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </details>

                    <!-- 5. 가격 슬라이더 -->
                    <details class="filter-group" open>
                        <summary class="filter-title">가격</summary>
                        <div class="filter-content">
                            <div class="price-slider">
                                <div class="slider-track"></div>
                                <div id="sliderFill" class="slider-fill" style="left:0%; width:100%;"></div>
                                <input type="range" id="rangeMin" name="minPrice" min="0" max="1000000" step="1000" 
                                       value="${param.minPrice != null ? param.minPrice : 0}" 
                                       onchange="searchList()">
                                <input type="range" id="rangeMax" name="maxPrice" min="0" max="1000000" step="1000" 
                                       value="${param.maxPrice != null ? param.maxPrice : 1000000}" 
                                       onchange="searchList()">
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
                                <%-- [수정됨] c:set 태그 삭제. 컨트롤러에서 colorList를 전달받아 바로 사용 --%>
                                <c:forEach var="color" items="${colorList}">
                                    <c:set var="isColorChecked" value="false"/>
                                    <c:if test="${not empty paramValues.colors}">
                                        <c:forEach var="val" items="${paramValues.colors}">
                                            <c:if test="${val eq color.name}">
                                                <c:set var="isColorChecked" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                    <label class="color-swatch" title="${color.name}">
                                        <input type="checkbox" name="colors" value="${color.name}" onchange="searchList()" ${isColorChecked ? 'checked' : ''}>
                                        <span style="background-color: ${color.hex}; ${color.name eq '화이트' ? 'border:1px solid #ddd;' : ''}"></span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </details>

                    <input type="hidden" name="sort" id="hiddenSort" value="${param.sort}">
                </form>
            </aside>

            <!-- Main Content -->
            <main class="col-12 col-lg-10">
                <!-- Sorting -->
                <div class="sort-wrapper">
                    <select id="sortSelect" class="sort-select" onchange="changeSort(this.value)">
                        <option value="new" ${param.sort == 'new' ? 'selected' : ''}>신상품순</option>
                        <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>낮은가격순</option>
                        <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>높은가격순</option>
                    </select>
                </div>

                <!-- 상품 목록 영역 (Ajax로 교체될 영역) -->
                <div id="productList" class="row gx-4 gy-5">
                    
                    <%-- 백단 작업 전 가라 데이터 --%>
                    <c:forEach var="i" begin="1" end="12">
                        <div class="col-6 col-md-4 col-lg-3">
                            <div class="product-card" onclick="location.href='${pageContext.request.contextPath}/product/detail?productNo=${i}'">
                                <div class="product-img-box">
                                    <c:if test="${i % 3 == 0}">
                                        <span class="badge-new">NEW</span>    
                                    </c:if>
                                    <div class="placeholder-div">
                                        <span class="placeholder-text">${categoryName} ${i}</span>
                                    </div>
                                </div>
                                <div class="product-info">
                                    <div class="product-meta">${categoryName} 라이프스타일</div>
                                    <h3 class="product-name">나이키 에어 포스 1 '07 (${i}번)</h3>
                                    <div class="product-price">₩<fmt:formatNumber value="${139000 + (i * 1000)}" pattern="#,###" /></div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <%-- 실제 데이터 처리단 (추후 활성화) --%>
                    <%--
                    <c:choose>
                        <c:when test="${not empty list}">
                            <c:forEach var="dto" items="${list}">
                                ...
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            ...
                        </c:otherwise>
                    </c:choose>
                    --%>
                </div>

                <!-- Paging (Mock) -->
                <div id="pagingArea" class="d-flex justify-content-center mt-5">
                    ${paging}
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 가격 슬라이더 기능 초기화
            initPriceSlider();
            
            // 기존 스크롤 위치 복원 로직은 Ajax 방식에서는 '뒤로가기' 등에서만 유효
            const savedScrollPos = sessionStorage.getItem('listScrollPos');
            if (savedScrollPos) {
                window.scrollTo(0, parseInt(savedScrollPos));
                sessionStorage.removeItem('listScrollPos');
            }
        });

        // 정렬 변경 함수
        function changeSort(val) {
            document.getElementById('hiddenSort').value = val;
            searchList(); // Ajax 검색 호출
        }

        // 필터 초기화 함수
        function resetFilters() {
            location.href = '${pageContext.request.contextPath}/collections/list?category=${categoryCode}';
        }
        
        // [핵심] Ajax 상품 검색 함수 (화면 깜빡임 없이 리스트만 교체)
        function searchList() {
            const f = document.searchForm;
            const formData = new FormData(f);
            const params = new URLSearchParams(formData);
            
            // 1. 현재 URL을 변경하여 필터 상태를 히스토리에 저장 (새로고침 시 유지)
            const url = '${pageContext.request.contextPath}/collections/list?' + params.toString();
            window.history.pushState({path: url}, '', url);

            // 2. 리스트 영역에 로딩 효과 (선택 사항)
            const productListEl = document.getElementById('productList');
            if(productListEl) productListEl.classList.add('loading-overlay');

            // 3. 비동기 요청 (Ajax)
            fetch(url, {
                method: 'GET',
                headers: {
                    'AJAX': 'true' // 서버/필터에 Ajax 요청임을 알림
                }
            })
            .then(response => response.text())
            .then(html => {
                // 4. 받아온 전체 HTML 텍스트를 파싱
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                
                // 5. 상품 리스트 영역(#productList)만 추출하여 교체
                const newProductList = doc.getElementById('productList');
                if (newProductList && productListEl) {
                    productListEl.innerHTML = newProductList.innerHTML;
                    productListEl.classList.remove('loading-overlay');
                }
                
                // 6. 페이징 영역 교체
                const newPaging = doc.getElementById('pagingArea'); // 페이징 영역에 id 추가함
                const oldPaging = document.getElementById('pagingArea');
                if (newPaging && oldPaging) {
                    oldPaging.innerHTML = newPaging.innerHTML;
                }
                
                // 7. 총 개수([12]) 업데이트
                const newCount = doc.querySelector('.collection-count');
                const oldCount = document.querySelector('.collection-count');
                if(newCount && oldCount) {
                    oldCount.textContent = newCount.textContent;
                }
            })
            .catch(err => {
                console.error('Filter Error:', err);
                if(productListEl) productListEl.classList.remove('loading-overlay');
            });
        }

        // 가격 슬라이더 동작 로직 (유지)
        function initPriceSlider() {
            const rangeMin = document.getElementById('rangeMin');
            const rangeMax = document.getElementById('rangeMax');
            const inputMin = document.getElementById('inputMin');
            const inputMax = document.getElementById('inputMax');
            const sliderFill = document.getElementById('sliderFill');
            const minGap = 50000; 

            function updateSlider(e) {
                let minVal = parseInt(rangeMin.value);
                let maxVal = parseInt(rangeMax.value);
                const max = parseInt(rangeMax.max);

                if (maxVal - minVal < minGap) {
                    if (e && e.target.id === "rangeMin") {
                        rangeMin.value = maxVal - minGap;
                        minVal = parseInt(rangeMin.value);
                    } else {
                        rangeMax.value = minVal + minGap;
                        maxVal = parseInt(rangeMax.value);
                    }
                }

                inputMin.value = minVal.toLocaleString();
                inputMax.value = maxVal.toLocaleString();

                const percentMin = (minVal / max) * 100;
                const percentMax = (maxVal / max) * 100;

                sliderFill.style.left = percentMin + "%";
                sliderFill.style.width = (percentMax - percentMin) + "%";
            }

            rangeMin.addEventListener('input', updateSlider);
            rangeMax.addEventListener('input', updateSlider);

            updateSlider();
        }
    </script>
</body>
</html>