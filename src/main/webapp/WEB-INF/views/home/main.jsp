<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<jsp:include page="/WEB-INF/views/common/image_config.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>MAKNAEZ - NOCTURNE VISION</title>
    
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Archivo:ital,wght@0,800;0,900;1,800;1,900&family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/footer.css">
</head>
<body>

    <div class="intro-curtain">
        <div class="intro-logo font-brand">MAKNAEZ</div>
    </div>

    <jsp:include page="/WEB-INF/views/layout/header.jsp" />

    <main>
        <section class="hero-section">
            <div class="hero-slide active"><img src="${img_hero_1}" alt="Hero 1"></div>
            <div class="hero-slide"><img src="${img_hero_2}" alt="Hero 2"></div>
            <div class="hero-slide"><img src="${img_hero_3}" alt="Hero 3"></div>

            <div class="hero-overlay">
                <h2 class="overlay-title font-brand">
                    EMBRACE THE NIGHT<br>NOCTURNE VISION CAPSULE
                </h2>
                <a href="${pageContext.request.contextPath}/collections/list" class="overlay-btn">
                    바로 가기
                </a>
            </div>

            <div class="hero-dots">
                <button class="dot-btn active" onclick="goToSlide(0)">
                    <svg viewBox="0 0 30 30">
                        <circle class="circle-bg" cx="15" cy="15" r="13"></circle>
                        <circle class="circle-progress" cx="15" cy="15" r="13"></circle>
                    </svg>
                </button>
                <button class="dot-btn" onclick="goToSlide(1)">
                    <svg viewBox="0 0 30 30">
                        <circle class="circle-bg" cx="15" cy="15" r="13"></circle>
                        <circle class="circle-progress" cx="15" cy="15" r="13"></circle>
                    </svg>
                </button>
                <button class="dot-btn" onclick="goToSlide(2)">
                    <svg viewBox="0 0 30 30">
                        <circle class="circle-bg" cx="15" cy="15" r="13"></circle>
                        <circle class="circle-progress" cx="15" cy="15" r="13"></circle>
                    </svg>
                </button>
            </div>
        </section>

        <section class="category-nav">
            <div class="cat-item reveal" onclick="location.href='${pageContext.request.contextPath}/collections/list?category=men'">
                <img src="${img_cat_men}" alt="Men">
                <span class="cat-label font-brand">MEN</span>
            </div>
            <div class="cat-item reveal" onclick="location.href='${pageContext.request.contextPath}/collections/list?category=women'">
                <img src="${img_cat_women}" alt="Women">
                <span class="cat-label font-brand">WOMEN</span>
            </div>
            <div class="cat-item reveal" onclick="location.href='${pageContext.request.contextPath}/collections/list?category=sportstyle'">
                <img src="${img_cat_sportstyle}" alt="Sportstyle">
                <span class="cat-label font-brand">SPORTSSTYLE</span>
            </div>
            <div class="cat-item reveal" onclick="location.href='${pageContext.request.contextPath}/collections/list?category=sale'">
                <img src="${img_cat_sale}" alt="Sale">
                <span class="cat-label font-brand" style="color: var(--accent);">SALE</span>
            </div>
        </section>

        <section class="wide-feature reveal" style="margin-top: 80px;">
            <img src="${img_wide_banner}" alt="Feature Banner">
            <div class="wide-txt">
                <h2 class="wide-title font-brand">THE NEW<br>STANDARD</h2>
                <button class="btn-white" onclick="location.href='${pageContext.request.contextPath}/collections/list'">EXPLORE COLLECTION</button>
            </div>
        </section>

        <section class="latest-drops-section">
            <div class="section-header">
                <h2 class="header-title">LATEST<br>DROPS</h2>
                <a href="${pageContext.request.contextPath}/collections/list" class="view-all-btn">VIEW ALL</a>
            </div>

            <div class="tech-grid">
                <div class="tech-card" onclick="location.href='${pageContext.request.contextPath}/product/detail?prod_id=1'">
                    <div class="card-image-box">
                        <img src="${img_prod_xt6}" alt="XT-6">
                    </div>
                    <div class="card-info">
                        <span class="prod-name">MKZ-6 GORE-TEX</span>
                        <span class="prod-cat">Sportstyle</span>
                        <span class="prod-price">280,000</span>
                    </div>
                </div>
                <div class="tech-card" onclick="location.href='${pageContext.request.contextPath}/product/detail?prod_id=2'">
                    <div class="card-image-box">
                        <img src="${img_prod_speedcross}" alt="Speedcross">
                    </div>
                    <div class="card-info">
                        <span class="prod-name">SPEEDCROSS 6</span>
                        <span class="prod-cat">Trail Running</span>
                        <span class="prod-price">190,000</span>
                    </div>
                </div>
                <div class="tech-card" onclick="location.href='${pageContext.request.contextPath}/product/detail?prod_id=3'">
                    <div class="card-image-box">
                        <img src="${img_prod_acs}" alt="ACS Pro">
                    </div>
                    <div class="card-info">
                        <span class="prod-name">ACS PRO</span>
                        <span class="prod-cat">Advanced</span>
                        <span class="prod-price">265,000</span>
                    </div>
                </div>
                <div class="tech-card" onclick="location.href='${pageContext.request.contextPath}/product/detail?prod_id=4'">
                    <div class="card-image-box">
                        <img src="${img_prod_women}" alt="Hypulse">
                    </div>
                    <div class="card-info">
                        <span class="prod-name">HYPULSE</span>
                        <span class="prod-cat">Trail Running</span>
                        <span class="prod-price">145,000</span>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />
    <jsp:include page="/WEB-INF/views/layout/footerResources.jsp" />

    <script>
        const slides = document.querySelectorAll('.hero-slide');
        const dots = document.querySelectorAll('.dot-btn');
        let currentSlide = 0;
        let slideInterval;

        function updateSlide() {
            // 모든 슬라이드 및 도트 초기화
            slides.forEach(s => s.classList.remove('active'));
            dots.forEach(d => d.classList.remove('active'));
            
            // 현재 슬라이드 및 도트 활성화
            slides[currentSlide].classList.add('active');
            dots[currentSlide].classList.add('active');
        }

        function nextSlide() {
            currentSlide = (currentSlide + 1) % slides.length;
            updateSlide();
        }

        function goToSlide(index) {
            currentSlide = index;
            updateSlide();
            resetTimer(); // 클릭 시 타이머 리셋
        }

        function resetTimer() {
            clearInterval(slideInterval);
            slideInterval = setInterval(nextSlide, 5000); // 5초마다 자동 슬라이드
        }

        // 초기 실행
        resetTimer();

        // 스크롤 애니메이션 옵저버
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => { 
                if(entry.isIntersecting) {
                    entry.target.classList.add('active');
                }
            });
        }, { threshold: 0.1 });
        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
    </script>
</body>
</html>