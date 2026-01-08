<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>Shopping Mall Main</title>
    
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
</head>
<body>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main>
        <section id="mainCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="0" class="active"></button>
                <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="1"></button>
                <button type="button" data-bs-target="#mainCarousel" data-bs-slide-to="2"></button>
            </div>
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img src="https://placehold.co/1920x600/333/fff?text=SEASON+OFF+SALE" class="d-block w-100" alt="Banner 1">
                    <div class="carousel-caption d-none d-md-block">
                        <h5>2024 S/S SEASON OFF</h5>
                        <p>최대 50% 할인 혜택을 만나보세요.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="https://placehold.co/1920x600/555/fff?text=NEW+COLLECTION" class="d-block w-100" alt="Banner 2">
                    <div class="carousel-caption d-none d-md-block">
                        <h5>NEW ARRIVALS</h5>
                        <p>이번 주 신상품을 확인해보세요.</p>
                    </div>
                </div>
                <div class="carousel-item">
                    <img src="https://placehold.co/1920x600/777/fff?text=WEEKLY+BEST" class="d-block w-100" alt="Banner 3">
                    <div class="carousel-caption d-none d-md-block">
                        <h5>WEEKLY BEST</h5>
                        <p>가장 사랑받는 아이템.</p>
                    </div>
                </div>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#mainCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#mainCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
            </button>
        </section>

        <section class="container">
            <h2 class="section-title">BEST ITEMS</h2>
            <p class="text-center text-secondary mb-5">이번 주 가장 많이 판매된 상품입니다.</p>
            
            <div class="row">
                <div class="col-6 col-md-4">
                    <div class="product-card">
                        <div class="product-img-wrapper">
                            <span class="badge-new">BEST</span>
                            <a href="#"><img src="https://placehold.co/400x400/ddd/333?text=Slacks" alt="Product"></a>
                        </div>
                        <div class="product-info">
                            <a href="#"><div class="product-name">와이드 핏 슬랙스</div><div class="product-price">45,000원</div></a>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-4">
                    <div class="product-card">
                        <div class="product-img-wrapper">
                            <a href="#"><img src="https://placehold.co/400x400/ccc/333?text=Knit" alt="Product"></a>
                        </div>
                        <div class="product-info">
                            <a href="#"><div class="product-name">라운드넥 니트</div><div class="product-price">32,000원</div></a>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-4">
                    <div class="product-card">
                        <div class="product-img-wrapper">
                            <span class="badge-new">HOT</span>
                            <a href="#"><img src="https://placehold.co/400x400/bbb/333?text=Dress" alt="Product"></a>
                        </div>
                        <div class="product-info">
                            <a href="#"><div class="product-name">코튼 롱 원피스</div><div class="product-price">58,000원</div></a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="container pb-5">
            <h2 class="section-title">NEW ARRIVALS</h2>
            <div class="row">
                <div class="col-6 col-md-3">
                    <div class="product-card">
                        <div class="product-img-wrapper">
                            <span class="badge-new">NEW</span>
                            <a href="#">
                                <img src="https://placehold.co/400x400/e0e0e0/333?text=Jacket" alt="New Product">
                            </a>
                        </div>
                        <div class="product-info">
                            <a href="#">
                                <div class="product-name">린넨 자켓</div>
                                <div class="product-price">89,000원</div>
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="product-card">
                        <div class="product-img-wrapper">
                            <span class="badge-new">NEW</span>
                            <a href="#"><img src="https://placehold.co/400x400/d0d0d0/333?text=Sandals" alt="Product"></a>
                        </div>
                        <div class="product-info">
                            <a href="#"><div class="product-name">썸머 샌들</div><div class="product-price">35,000원</div></a>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="product-card">
                        <div class="product-img-wrapper">
                            <span class="badge-new">NEW</span>
                            <a href="#"><img src="https://placehold.co/400x400/c0c0c0/333?text=T-shirt" alt="Product"></a>
                        </div>
                        <div class="product-info">
                            <a href="#"><div class="product-name">스트라이프 티셔츠</div><div class="product-price">19,000원</div></a>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="product-card">
                        <div class="product-img-wrapper">
                            <span class="badge-new">NEW</span>
                            <a href="#"><img src="https://placehold.co/400x400/b0b0b0/333?text=Shorts" alt="Product"></a>
                        </div>
                        <div class="product-info">
                            <a href="#"><div class="product-name">데님 쇼츠</div><div class="product-price">25,000원</div></a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        
        <section class="container-fluid py-5 bg-light mt-5">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6 mb-3 mb-md-0">
                        <img src="https://placehold.co/800x400/ccc/333?text=LOOK+BOOK" class="img-fluid rounded" alt="Promo">
                    </div>
                    <div class="col-md-6 text-center text-md-start ps-md-5">
                        <span class="text-primary fw-bold">PROMOTION</span>
                        <h2 class="fw-bold mt-2">멤버십 혜택 안내</h2>
                        <p class="text-muted mt-3">
                            신규 가입 시 10% 할인 쿠폰 즉시 지급!<br>
                            매월 다양한 등급별 혜택을 놓치지 마세요.
                        </p>
                        <a href="#" class="btn btn-dark mt-3 px-4 py-2">자세히 보기</a>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />
    
</body>
</html>