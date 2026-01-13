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
    <!-- list.css로 통합된 파일 사용 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/list.css">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&family=Oswald:wght@400;500;600&display=swap" rel="stylesheet">
    
    <style>
        /* 추가적인 커스텀 스타일 (필요 시) */
        .loading-spinner { display: none; width: 100%; text-align: center; padding: 20px; }
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
                    ${categoryName} <span class="collection-count">[${dataCount}]</span>
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
                            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" style="margin-right:8px;"><path d="M4.33317 2.33341C2.72384 3.25141 1.6665 5.01475 1.6665 7.00008C1.6665 8.05491 1.9793 9.08606 2.56533 9.96312C3.15137 10.8402 3.98432 11.5238 4.95886 11.9274C5.9334 12.3311 7.00575 12.4367 8.04032 12.2309C9.07488 12.0251 10.0252 11.5172 10.7711 10.7713C11.517 10.0254 12.0249 9.07513 12.2307 8.04056C12.4365 7.006 12.3309 5.93364 11.9272 4.9591C11.5235 3.98456 10.8399 3.15161 9.96288 2.56558C9.08582 1.97954 8.05467 1.66675 6.99984 1.66675" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path d="M4.33317 5.00016V2.3335H1.6665" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path></svg>
                            필터 초기화
                        </button>
                    </div>

                    <!-- 1. 카테고리 -->
                    <details class="filter-group" open>
                        <summary class="filter-title">카테고리</summary>
                        <div class="filter-content">
                            <c:forEach var="sport" items="${sportList}">
                                <c:set var="isSportChecked" value="false"/>
                                <!-- 기존 선택값 확인 -->
                                <c:if test="${not empty paramValues.sports}">
                                    <c:forEach var="val" items="${paramValues.sports}">
                                        <c:if test="${val eq sport}">
                                            <c:set var="isSportChecked" value="true"/>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                <!-- 체크박스 -->
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
                            <c:forEach var="g" items="${genderList}">
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

                    <!-- 4. 가격 슬라이더 -->
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

                    <!-- 5. 색상 -->
                    <details class="filter-group" open>
                        <summary class="filter-title">색상</summary>
                        <div class="filter-content">
                            <div class="color-list">
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
                <!-- 상품 목록 영역 (Ajax 교체 대상) -->
                <div id="productList" class="row gx-4 gy-5">
                    
                    <!-- 1. 데이터 없음 -->
                    <c:if test="${empty list}">
                        <div class="col-12 text-center py-5">
                            <h4>등록된 상품이 없습니다.</h4>
                        </div>
                    </c:if>
                    
                    <!-- 2. 실제 데이터 출력 -->
                    <c:if test="${not empty list}">
                        <jsp:include page="/WEB-INF/views/collections/list_more.jsp" />
                    </c:if>
                    
                </div>

                <!-- 로딩 스피너 -->
                <div class="loading-spinner">
                    <div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div>
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            initPriceSlider();
        });

        function changeSort(val) {
            document.getElementById('hiddenSort').value = val;
            searchList();
        }

        function resetFilters() {
            location.href = '${pageContext.request.contextPath}/collections/list?category=${categoryCode}';
        }
        
        // [Ajax 검색 함수]
        function searchList() {
            const f = document.searchForm;
            const formData = new FormData(f);
            formData.set('page', 1); // 검색 시 1페이지로 리셋
            const params = new URLSearchParams(formData);
            
            const url = '${pageContext.request.contextPath}/collections/list?' + params.toString();
            window.history.pushState({path: url}, '', url);

            const productListEl = document.getElementById('productList');
            if(productListEl) productListEl.classList.add('loading-overlay');

            fetch(url, { method: 'GET' })
            .then(response => response.text())
            .then(html => {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                
                // 상품 리스트 교체
                const newProductList = doc.getElementById('productList');
                if (newProductList && productListEl) {
                    productListEl.innerHTML = newProductList.innerHTML;
                    productListEl.classList.remove('loading-overlay');
                }
                
                // 총 개수 업데이트
                const newCount = doc.querySelector('.collection-count');
                const oldCount = document.querySelector('.collection-count');
                if(newCount && oldCount) oldCount.textContent = newCount.textContent;
                
                // 무한 스크롤 상태 리셋
                currentPage = 1;
                isEnd = false;
            })
            .catch(err => {
                console.error('Filter Error:', err);
                if(productListEl) productListEl.classList.remove('loading-overlay');
            });
        }

        // [가격 슬라이더]
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
        
        // [무한 스크롤]
        let currentPage = 1;
        let isLoading = false;
        let isEnd = false;

        $(window).scroll(function() {
            if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
                if (!isLoading && !isEnd) loadMore();
            }
        });

        function loadMore() {
            isLoading = true;
            $(".loading-spinner").show();
            currentPage++;
            
            const f = document.searchForm;
            const formData = new FormData(f);
            formData.set('page', currentPage);
            const params = new URLSearchParams(formData);

            // [중요] listMore URL 호출
            $.ajax({
                url: "${pageContext.request.contextPath}/collections/listMore",
                type: "GET",
                data: params.toString(),
                success: function(html) {
                    if ($.trim(html) === "") {
                        isEnd = true;
                    } else {
                        $("#productList").append(html);
                    }
                },
                complete: function() {
                    isLoading = false;
                    $(".loading-spinner").hide();
                }
            });
        }
    </script>
</body>
</html>