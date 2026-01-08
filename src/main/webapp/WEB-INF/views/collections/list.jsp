<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${categoryName} 신발 | Salomon</title>

    <!-- Header Resources -->
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
    
    <!-- Sidebar CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/list-sidebar.css">
    
    <!-- Vue 3 & jQuery -->
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        // 전역 설정 (JS에서 ContextPath 및 초기값 사용)
        window.ezConfig = {
            categoryCode: "${categoryCode}"
        };
    </script>
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <div id="app" class="main-container">
        
        <!-- Top Area (Dynamic Title) -->
        <div class="page-header">
            <nav class="breadcrumbs" role="navigation" aria-label="breadcrumbs">
                <ol class="breadcrumbs__list">
                    <li class="breadcrumbs__item"><a class="breadcrumbs__link" href="#">Home / </a></li>
                    <li class="breadcrumbs__item"><a class="breadcrumbs__link" href="#" aria-current="page">${categoryName}</a></li>
                </ol>
            </nav>

            <div class="as-collection__titleWrap">
                <h3 class="as-collection__title">
                    ${categoryName}<span class="as-collection__count">[{{ totalCount }}]</span>
                </h3>
            </div>
        </div>

        <div class="row">
            <!-- Left Sidebar -->
            <aside class="col-lg-2 d-none d-lg-block sidebar">
                
                <!-- Reset Button -->
                <div class="reset-btn-wrapper">
                    <button class="reset-btn" @click.prevent="resetFilters">
                        <svg class="reset-icon" width="14" height="14" viewBox="0 0 14 14" fill="none">
                            <path d="M4.33317 2.33341C2.72384 3.25141 1.6665 5.01475 1.6665 7.00008C1.6665 8.05491 1.9793 9.08606 2.56533 9.96312C3.15137 10.8402 3.98432 11.5238 4.95886 11.9274C5.9334 12.3311 7.00575 12.4367 8.04032 12.2309C9.07488 12.0251 10.0252 11.5172 10.7711 10.7713C11.517 10.0254 12.0249 9.07513 12.2307 8.04056C12.4365 7.006 12.3309 5.93364 11.9272 4.9591C11.5235 3.98456 10.8399 3.15161 9.96288 2.56558C9.08582 1.97954 8.05467 1.66675 6.99984 1.66675" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                            <path d="M4.33317 5.00016V2.3335H1.6665" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                        </svg>
                        필터 초기화
                    </button>
                </div>

                <!-- 1. 스포츠 -->
                <details class="cc-accordion-item" open>
                    <summary class="cc-accordion-item__title">스포츠</summary>
                    <div class="cc-accordion-item__content">
                        <label class="cc-checkbox" v-for="sport in ['로드러닝', '아웃도어', '트레일러닝', '스포츠스타일', '하이킹']" :key="sport">
                            <input class="cc-checkbox__input" type="checkbox" :value="sport" v-model="filters.sports">
                            <span class="cc-checkbox__label">{{ sport }}</span>
                        </label>
                    </div>
                </details>

                <!-- 2. 판매 상태 -->
                <details class="cc-accordion-item" open>
                    <summary class="cc-accordion-item__title">판매 상태</summary>
                    <div class="cc-accordion-item__content">
                        <label class="cc-checkbox">
                            <input class="cc-checkbox__input" type="checkbox" v-model="filters.excludeSoldOut">
                            <span class="cc-checkbox__label">품절 상품 제외</span>
                        </label>
                    </div>
                </details>

                <!-- 3. 성별 -->
                <details class="cc-accordion-item" open>
                    <summary class="cc-accordion-item__title">성별</summary>
                    <div class="cc-accordion-item__content">
                        <label class="cc-checkbox" v-for="gender in ['남성', '여성', 'Unisex']" :key="gender">
                            <input class="cc-checkbox__input" type="checkbox" :value="gender" v-model="filters.gender">
                            <span class="cc-checkbox__label">{{ gender }}</span>
                        </label>
                    </div>
                </details>

                <!-- 4. 사이즈 -->
                <details class="cc-accordion-item" open>
                    <summary class="cc-accordion-item__title">사이즈</summary>
                    <div class="cc-accordion-item__content">
                        <div class="size-grid">
                            <div v-for="size in sizes" :key="size">
                                <input type="checkbox" :id="'size-' + size" :value="size" v-model="filters.sizes" class="size-checkbox-input">
                                <label :for="'size-' + size" class="size-label">{{ size }}</label>
                            </div>
                        </div>
                    </div>
                </details>

                <!-- 5. 가격 -->
                <details class="cc-accordion-item" open>
                    <summary class="cc-accordion-item__title">가격</summary>
                    <div class="cc-accordion-item__content">
                        <div class="price-slider-wrapper">
                            <div class="slider-container">
                                <div class="slider-track"></div>
                                <div class="slider-range" :style="rangeStyle"></div>
                                <input type="range" class="range-input" :min="minLimit" :max="maxLimit" :step="step" v-model.number="filters.minPrice" @input="onSliderInput('min')">
                                <input type="range" class="range-input" :min="minLimit" :max="maxLimit" :step="step" v-model.number="filters.maxPrice" @input="onSliderInput('max')">
                            </div>
                            <div class="cc-price-range__input-row">
                                <div class="cc-price-range__input-container">
                                    <span class="cc-price-range__input-currency-symbol">₩</span>
                                    <input class="cc-price-range__input" type="number" v-model.number="filters.minPrice" @input="onTextInput('min')" placeholder="0">
                                </div>
                                <span class="range-dash">-</span>
                                <div class="cc-price-range__input-container">
                                    <span class="cc-price-range__input-currency-symbol">₩</span>
                                    <input class="cc-price-range__input" type="number" v-model.number="filters.maxPrice" @input="onTextInput('max')" placeholder="1000000">
                                </div>
                            </div>
                        </div>
                    </div>
                </details>

                <!-- 6. 색상 -->
                <details class="cc-accordion-item">
                    <summary class="cc-accordion-item__title">색상</summary>
                    <div class="cc-accordion-item__content">
                        <ul class="cc-swatches">
                            <li v-for="color in colors" :key="color.name" :title="color.name">
                                <label class="cc-checkbox">
                                    <input class="cc-checkbox__input" type="checkbox" :value="color.name" v-model="filters.colors">
                                    <span class="swatch-sample" :style="{ backgroundColor: color.hex }"></span>
                                </label>
                            </li>
                        </ul>
                    </div>
                </details>
            </aside>

            <!-- Right Product List Area -->
            <!-- 
            <main class="col-12 col-lg-10">
                <!-- Sorting -->
                <div class="d-flex justify-content-end mb-3">
                    <select class="form-select w-auto" v-model="filters.sort" @change="fetchProducts">
                        <option value="new">신상품순</option>
                        <option value="price_asc">가격 낮은순</option>
                        <option value="price_desc">가격 높은순</option>
                    </select>
                </div>

                <div v-if="loading" class="d-flex justify-content-center align-items-center" style="min-height: 400px;">
                    <div class="spinner-border text-dark" role="status"></div>
                </div>

                <div v-else class="row gx-3 gx-md-4">
                    <div v-for="product in products" :key="product.id" class="col-6 col-md-4 col-lg-3">
                        <div class="product-card">
                            <div class="product-img-wrapper">
                                <!-- imageFile이 있으면 사용, 없으면 placeholder -->
                                <img :src="product.imageUrl || 'https://via.placeholder.com/400x400/f6f6f6/000000?text=NO+IMAGE'" :alt="product.name" class="product-img">
                                <span v-if="product.isNew" class="position-absolute top-0 start-0 bg-dark text-white px-2 py-1 m-2" style="font-size: 0.7rem; font-weight:700;">NEW</span>
                            </div>
                            <div class="product-info">
                                <span class="product-tag">{{ product.category }}</span>
                                <h3 class="product-name">{{ product.name }}</h3>
                                <div class="product-price">{{ formatPrice(product.price) }}원</div>
                            </div>
                        </div>
                    </div>
                </div>
       
                
                
                <!-- 상품 없음 -->
                <div v-if="!loading && products.length === 0" class="text-center py-5">
                    <p class="text-muted">검색 결과가 없습니다.</p>
                </div>
            </main>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

    <script>
        const { createApp } = Vue;

        createApp({
            data() {
                return {
                    products: [],      // 상품 데이터
                    loading: true,
                    totalCount: 0,
                    
                    // Slider Constants
                    minLimit: 0,
                    maxLimit: 1000000,
                    step: 1000,
                    minGap: 0,
                    
                    // Filter Options
                    sizes: [220, 225, 230, 235, 240, 245, 250, 255, 260, 265, 270, 275, 280, 285, 290, 300],
                    colors: [
                        { name: "블랙", hex: "#000000" },
                        { name: "그레이", hex: "#9E9E9E" },
                        { name: "화이트", hex: "#FFFFFF" },
                        { name: "블루", hex: "#0000FF" },
                        { name: "베이지", hex: "#E7D6B9" },
                        { name: "브라운", hex: "#9E7650" },
                        { name: "레드", hex: "#D1180B" },
                        { name: "그린", hex: "#98C264" },
                        { name: "옐로우", hex: "#FDEB4C" }
                    ],
                    
                    // Active Filters
                    filters: {
                        sort: 'new',
                        excludeSoldOut: false,
                        gender: [],
                        sports: [],
                        sizes: [],
                        minPrice: 0,
                        maxPrice: 1000000,
                        colors: []
                    },
                    
                    // Category from JSP
                    categoryCode: window.ezConfig.categoryCode
                };
            },
            computed: {
                rangeStyle() {
                    const minPercent = ((this.filters.minPrice - this.minLimit) / (this.maxLimit - this.minLimit)) * 100;
                    const maxPercent = ((this.filters.maxPrice - this.minLimit) / (this.maxLimit - this.minLimit)) * 100;
                    return {
                        left: minPercent + '%',
                        right: (100 - maxPercent) + '%'
                    };
                }
            },
            watch: {
                // 필터 변경 시 자동 fetch (debounce 필요하지만 여기선 단순화)
                filters: {
                    handler() {
                        this.fetchProducts();
                    },
                    deep: true
                }
            },
            mounted() {
                this.fetchProducts();
            },
            methods: {
                fetchProducts() {
                    const vm = this;
                    vm.loading = true;
                    
                    // 파라미터 구성
                    const params = {
                        categoryCode: vm.categoryCode,
                        minPrice: vm.filters.minPrice,
                        maxPrice: vm.filters.maxPrice,
                        sort: vm.filters.sort,
                        excludeSoldOut: vm.filters.excludeSoldOut,
                        sizes: vm.filters.sizes,
                        genders: vm.filters.gender,
                        sports: vm.filters.sports,
                        colors: vm.filters.colors
                    };

                    $.ajax({
                        url: '${pageContext.request.contextPath}/api/products',
                        method: 'GET',
                        data: params, 
                        dataType: 'json',
                        traditional: true, // 배열 파라미터 직렬화 (sizes[] 등)
                        success: function(response) {
                            if(response.status === 'success') {
                                vm.products = response.products;
                                vm.totalCount = response.count;
                            }
                        },
                        complete: function() {
                            vm.loading = false;
                        }
                    });
                },
                
                onSliderInput(type) {
                    let min = this.filters.minPrice;
                    let max = this.filters.maxPrice;
                    if (type === 'min') {
                        if (min > max - this.minGap) this.filters.minPrice = max - this.minGap;
                    } else {
                        if (max < min + this.minGap) this.filters.maxPrice = min + this.minGap;
                    }
                },
                
                onTextInput(type) {
                    // 입력값 검증 로직 (생략 가능)
                },
                
                formatPrice(price) {
                    return price ? price.toLocaleString() : '0';
                },
                
                resetFilters() {
                    this.filters = {
                        sort: 'new',
                        excludeSoldOut: false,
                        gender: [],
                        sports: [],
                        sizes: [],
                        minPrice: 0,
                        maxPrice: 1000000,
                        colors: []
                    };
                    this.fetchProducts();
                }
            }
        }).mount('#app');
    </script>
</body>
</html>