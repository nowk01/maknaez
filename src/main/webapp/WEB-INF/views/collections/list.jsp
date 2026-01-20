<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/list.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/list-sidebar.css">
    
    <style>
        .loading-spinner { display: none; width: 100%; text-align: center; padding: 20px; }
        /* 체크박스 디자인 */
        .sidebar-menu input[type="checkbox"] { margin-right: 8px; vertical-align: middle; }
        .sidebar-menu label { cursor: pointer; display: block; margin-bottom: 5px; }
        
        /* 색상 칩 스타일 */
        .color-list { display: flex; flex-wrap: wrap; gap: 8px; }
        .color-swatch { position: relative; width: 24px; height: 24px; border-radius: 50%; border: 1px solid #ddd; cursor: pointer; }
        .color-swatch input { position: absolute; opacity: 0; width: 0; height: 0; }
        .color-swatch span { display: block; width: 100%; height: 100%; border-radius: 50%; }
        .color-swatch input:checked + span { box-shadow: 0 0 0 2px #fff, 0 0 0 4px #000; }
        
        /* 로딩 오버레이 (필터링 시 깜빡임 방지) */
        .loading-overlay { opacity: 0.5; pointer-events: none; transition: opacity 0.2s; }
        
        /* [추가] 하트 아이콘 호버 효과 */
        .wish-icon-btn:hover { transform: scale(1.1); }
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
            <aside class="col-lg-2 d-none d-lg-block sidebar-container">
                <form name="searchForm" id="searchForm">
                    <input type="hidden" name="page" id="page" value="1">
                    <input type="hidden" name="category" value="${categoryCode}">

                    <div class="sidebar-header">
                        <span class="sidebar-title">필터</span>
                        <button type="button" class="btn-reset-large" onclick="resetFilters()">
                            <i class="fas fa-redo-alt" style="margin-right:8px;"></i> 필터 초기화
                        </button>
                    </div>

                    <details class="filter-group" open>
                        <summary class="filter-title">카테고리</summary>
                        <div class="filter-content">
                            <c:forEach var="sport" items="${sportList}">
                                <c:set var="isSportChecked" value="false"/>
                                <c:if test="${not empty paramValues.sports}">
                                    <c:forEach var="val" items="${paramValues.sports}">
                                        <c:if test="${val eq sport}">
                                            <c:set var="isSportChecked" value="true"/>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                <div class="sidebar-menu">
                                    <label>
                                        <input type="checkbox" name="sports" value="${sport}" onchange="searchList()" ${isSportChecked ? 'checked' : ''}>
                                        ${sport}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </details>

                    <details class="filter-group" open>
                        <summary class="filter-title">판매 상태</summary>
                        <div class="filter-content">
                            <div class="sidebar-menu">
                                <label>
                                    <input type="checkbox" name="excludeSoldOut" value="true" onchange="searchList()" ${param.excludeSoldOut == 'true' ? 'checked' : ''}>
                                    품절 상품 제외
                                </label>
                            </div>
                        </div>
                    </details>

                    <details class="filter-group" open>
                        <summary class="filter-title">성별</summary>
                        <div class="filter-content">
                            <c:forEach var="g" items="${genderList}">
                                <c:set var="isGenderChecked" value="false"/>
                                <c:if test="${not empty paramValues.genders}">
                                    <c:forEach var="val" items="${paramValues.genders}">
                                        <c:if test="${val eq g.code}">
                                            <c:set var="isGenderChecked" value="true"/>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                <div class="sidebar-menu">
                                    <label>
                                        <input type="checkbox" name="genders" value="${g.code}" onchange="searchList()" ${isGenderChecked ? 'checked' : ''}>
                                        ${g.name}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </details>

                    <details class="filter-group" open>
                        <summary class="filter-title">가격</summary>
                        <div class="filter-content">
                            <div class="price-slider">
                                <div class="slider-track"></div>
                                <div id="sliderFill" class="slider-fill" style="left:0%; width:100%;"></div>
                                <input type="range" id="rangeMin" min="0" max="500000" step="5000" 
                                       value="${empty minPrice ? 0 : minPrice}" 
                                       oninput="updateSliderUI(event)" 
                                       onchange="updatePriceAndSearch()">
                                <input type="range" id="rangeMax" min="0" max="500000" step="5000" 
                                       value="${empty maxPrice ? 500000 : maxPrice}" 
                                       oninput="updateSliderUI(event)" 
                                       onchange="updatePriceAndSearch()">
                            </div>
                            <div class="price-inputs">
                                <div class="price-input-group">
                                    <span>₩</span>
                                    <input type="text" id="inputMin" value="0" readonly>
                                </div>
                                <div class="price-input-group">
                                    <span>₩</span>
                                    <input type="text" id="inputMax" value="500,000" readonly>
                                </div>
                            </div>
                            
                            <input type="hidden" name="minPrice" id="hiddenMinPrice" value="${empty minPrice ? 0 : minPrice}">
                            <input type="hidden" name="maxPrice" id="hiddenMaxPrice" value="${empty maxPrice ? 500000 : maxPrice}">
                        </div>
                    </details>

                    <details class="filter-group" open>
                        <summary class="filter-title">색상</summary>
                        <div class="filter-content">
                            <div class="color-list">
                                <c:forEach var="color" items="${colorList}">
                                    <c:set var="isColorChecked" value="false"/>
                                    <c:if test="${not empty paramValues.colors}">
                                        <c:forEach var="val" items="${paramValues.colors}">
                                            <c:if test="${val eq color.code}">
                                                <c:set var="isColorChecked" value="true"/>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>
                                    <label class="color-swatch" title="${color.name}">
                                        <input type="checkbox" name="colors" value="${color.code}" onchange="searchList()" ${isColorChecked ? 'checked' : ''}>
                                        <span style="background-color: ${color.hex}; ${color.name eq '화이트' ? 'border:1px solid #ddd;' : ''}"></span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </details>

                    <input type="hidden" name="sort" id="hiddenSort" value="${param.sort}">
                </form>
            </aside>

            <main class="col-12 col-lg-10">
                <div id="productList" class="row gx-4 gy-5">
                    
                    <c:if test="${empty list}">
                        <div class="col-12 text-center py-5">
                            <h4>해당하는 상품이 없습니다.</h4>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty list}">
                        <jsp:include page="/WEB-INF/views/collections/list_more.jsp" />
                    </c:if>
                    
                </div>

                <div class="loading-spinner">
                    <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
                </div>
            </main>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 초기 슬라이더 UI 설정
            updateSliderUI();
        });

        // 정렬 변경
        function changeSort(val) {
            document.getElementById('hiddenSort').value = val;
            searchList();
        }

        // 초기화
        function resetFilters() {
            location.href = '${pageContext.request.contextPath}/collections/list?category=${categoryCode}';
        }
        
        // 슬라이더 값 변경 완료 시 (onchange) 호출
        function updatePriceAndSearch() {
            document.getElementById('hiddenMinPrice').value = document.getElementById('rangeMin').value;
            document.getElementById('hiddenMaxPrice').value = document.getElementById('rangeMax').value;
            searchList();
        }
        
        // 검색 실행 (AJAX로 부드럽게 처리)
        function searchList() {
            // 페이지를 1로 리셋
            document.getElementById('page').value = 1;
            
            // 폼 데이터 직렬화
            const f = document.getElementById('searchForm');
            const formData = new FormData(f);
            const params = new URLSearchParams(formData);
            
            // URL 업데이트 (뒤로가기 지원을 위해)
            const newUrl = '${pageContext.request.contextPath}/collections/list?' + params.toString();
            window.history.pushState({path: newUrl}, '', newUrl);

            // 로딩 효과
            const productListEl = document.getElementById('productList');
            if(productListEl) productListEl.classList.add('loading-overlay');

            // AJAX 요청 (listMore 컨트롤러 재사용하여 HTML 조각만 받아옴)
            $.ajax({
                url: "${pageContext.request.contextPath}/collections/listMore",
                type: "GET",
                data: params.toString(),
                success: function(html) {
                    if(productListEl) {
                        if($.trim(html) === "") {
                            productListEl.innerHTML = '<div class="col-12 text-center py-5"><h4>해당하는 상품이 없습니다.</h4></div>';
                        } else {
                            productListEl.innerHTML = html;
                        }
                        productListEl.classList.remove('loading-overlay');
                    }
                    
                    // 무한 스크롤 상태 초기화
                    currentPage = 1;
                    isEnd = false;
                },
                error: function(err) {
                    console.error("검색 실패", err);
                    if(productListEl) productListEl.classList.remove('loading-overlay');
                }
            });
        }

        // 가격 슬라이더 UI 업데이트 (드래그 시 시각적 효과만 담당)
        function updateSliderUI(e) {
            const rangeMin = document.getElementById('rangeMin');
            const rangeMax = document.getElementById('rangeMax');
            const inputMin = document.getElementById('inputMin');
            const inputMax = document.getElementById('inputMax');
            const sliderFill = document.getElementById('sliderFill');
            const minGap = 50000; 
            const maxValLimit = 500000;

            let minVal = parseInt(rangeMin.value);
            let maxVal = parseInt(rangeMax.value);

            // 교차 방지 로직
            if (maxVal - minVal < minGap) {
                if (e && e.target.id === "rangeMin") {
                    rangeMin.value = maxVal - minGap;
                    minVal = parseInt(rangeMin.value);
                } else {
                    rangeMax.value = minVal + minGap;
                    maxVal = parseInt(rangeMax.value);
                }
            }

            // 텍스트 및 게이지 업데이트
            inputMin.value = minVal.toLocaleString();
            inputMax.value = maxVal.toLocaleString();

            const percentMin = (minVal / maxValLimit) * 100;
            const percentMax = (maxVal / maxValLimit) * 100;

            sliderFill.style.left = percentMin + "%";
            sliderFill.style.width = (percentMax - percentMin) + "%";
            
            // z-index 조절 (겹칠 때 선택 용이하게)
            if (minVal > parseInt(rangeMax.max) - 100) {
                rangeMin.style.zIndex = "2";
            } else {
                rangeMin.style.zIndex = "1";
            }
        }
        
        // [무한 스크롤]
        let currentPage = 1;
        let isLoading = false;
        let isEnd = false;
        
        const totalPage = ${totalPage != null ? totalPage : 1};

        if (currentPage >= totalPage) {
            isEnd = true;
        }

        $(window).scroll(function() {
            if ($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
                if (!isLoading && !isEnd) {
                    loadMore();
                }
            }
        });

        function loadMore() {
            if (currentPage >= totalPage) {
                isEnd = true;
                return;
            }

            isLoading = true;
            $(".loading-spinner").show();
            currentPage++;
            
            const f = document.getElementById('searchForm');
            const formData = new FormData(f);
            formData.set('page', currentPage);
            const params = new URLSearchParams(formData);

            $.ajax({
                url: "${pageContext.request.contextPath}/collections/listMore",
                type: "GET",
                data: params.toString(),
                success: function(html) {
                    if ($.trim(html) !== "") {
                         $("#productList").append(html);
                    }
                    if (currentPage >= totalPage) {
                        isEnd = true;
                    }
                },
                error: function() {
                    isEnd = true; 
                },
                complete: function() {
                    isLoading = false;
                    $(".loading-spinner").hide();
                }
            });
        }
        
        // [추가] 하트 토글 함수
        function toggleWish(prodId, event, element) {
            // 부모 클릭(상세페이지 이동) 방지
            event.stopPropagation();
            event.preventDefault();

            $.ajax({
                url: "${pageContext.request.contextPath}/collections/wishlist/toggle",
                type: "POST",
                data: { prodId: prodId },
                dataType: "json",
                success: function(data) {
                    if (data.status === "login_required") {
                        if(confirm("로그인이 필요한 서비스입니다.\n로그인 페이지로 이동하시겠습니까?")) {
                            location.href = "${pageContext.request.contextPath}/member/login";
                        }
                    } else if (data.status === "success") {
                        const icon = $(element).find("i");
                        if (data.liked) {
                            // 찜 등록됨: 빨간 하트
                            icon.removeClass("fa-heart-broken").addClass("fa-heart").css("color", "#dc3545");
                        } else {
                            // 찜 해제됨: 흰색 하트
                            icon.css("color", "#ffffff");
                        }
                    } else {
                        alert("오류가 발생했습니다.");
                    }
                },
                error: function(e) {
                    console.error(e);
                    alert("서버 통신 오류");
                }
            });
        }
    </script>
</body>
</html>