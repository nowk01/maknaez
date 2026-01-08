<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<jsp:include page="/WEB-INF/views/common/image_config.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>MAKNAEZ - FUTURE ARCHIVE</title>
    
    <jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Archivo:ital,wght@0,900;1,900&family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    
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
            <div class="hero-title-wrap">
                <div class="hero-title font-brand">FUTURE<br>ARCHIVE</div>
                <div class="hero-sub">ENGINEERED FOR MODERN LIFE</div>
            </div>
            <div class="hero-slide active"><img src="${img_hero_1}" alt="Hero 1"></div>
            <div class="hero-slide"><img src="${img_hero_2}" alt="Hero 2"></div>
            <div class="hero-slide"><img src="${img_hero_3}" alt="Hero 3"></div>
        </section>

        <section class="category-nav">
            <div class="cat-item">
                <img src="${img_cat_running}" alt="Running">
                <span class="cat-label font-brand">RUNNING</span>
            </div>
            <div class="cat-item">
                <img src="${img_cat_outdoor}" alt="Outdoor">
                <span class="cat-label font-brand">OUTDOOR</span>
            </div>
            <div class="cat-item">
                <img src="${img_cat_sportstyle}" alt="Sportstyle">
                <span class="cat-label font-brand">SPORTSTYLE</span>
            </div>
            <div class="cat-item">
                <img src="${img_cat_slab}" alt="S/LAB">
                <span class="cat-label font-brand">S/LAB</span>
            </div>
        </section>

        <div class="marquee-bar">
            <div class="marquee-text font-brand">
                NEW SEASON DROP /// FREE SHIPPING WORLDWIDE /// TECHWEAR COLLECTION /// NEW SEASON DROP ///
            </div>
        </div>

        <section class="wide-feature reveal">
            <img src="${img_wide_banner}" alt="Sportstyle">
            <div class="wide-txt">
                <h2 class="wide-title font-brand">SPORTSTYLE<br>EVOLVED</h2>
                <button class="btn-white">DISCOVER COLLECTION</button>
            </div>
        </section>

        <section class="container">
            <div class="section-head reveal">
                <h2 class="head-title font-brand">LATEST<br>DROPS</h2>
                <a href="#" class="head-link">VIEW ALL</a>
            </div>

            <div class="grid-layout">
                <div class="card reveal">
                    <div class="card-img"><img src="${img_prod_xt6}" alt="Shoe"></div>
                    <div class="card-txt">
                        <span class="c-title">MKZ-6 GORE-TEX</span>
                        <span class="c-cat">Sportstyle</span>
                        <span class="c-price">280,000</span>
                    </div>
                </div>
                <div class="card reveal">
                    <div class="card-img"><img src="${img_prod_speedcross}" alt="Shoe"></div>
                    <div class="card-txt">
                        <span class="c-title">SPEEDCROSS 6</span>
                        <span class="c-cat">Trail Running</span>
                        <span class="c-price">190,000</span>
                    </div>
                </div>
                <div class="card reveal">
                    <div class="card-img"><img src="${img_prod_acs}" alt="Shoe"></div>
                    <div class="card-txt">
                        <span class="c-title">ACS PRO</span>
                        <span class="c-cat">Advanced</span>
                        <span class="c-price">265,000</span>
                    </div>
                </div>
                <div class="card reveal">
                    <div class="card-img"><img src="${img_prod_women}" alt="Shoe"></div>
                    <div class="card-txt">
                        <span class="c-title">HYPULSE</span>
                        <span class="c-cat">Trail Running</span>
                        <span class="c-price">145,000</span>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/layout/footer.jsp" />

    <script>
        const slides = document.querySelectorAll('.hero-slide');
        let currentSlide = 0;
        setInterval(() => {
            slides[currentSlide].classList.remove('active');
            currentSlide = (currentSlide + 1) % slides.length;
            slides[currentSlide].classList.add('active');
        }, 4000);

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if(entry.isIntersecting) entry.target.classList.add('active');
            });
        }, { threshold: 0.1 });
        document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
        
        document.querySelectorAll('img').forEach(img => {
            img.onerror = function() {
                this.onerror = null;
                this.src = 'data:image/svg+xml;charset=UTF-8,%3Csvg%20width%3D%22800%22%20height%3D%22600%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22%23eee%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%2250%25%22%20fill%3D%22%23999%22%20font-family%3D%22sans-serif%22%20font-weight%3D%22bold%22%20font-size%3D%2224%22%20text-anchor%3D%22middle%22%20dy%3D%22.3em%22%3EMAKNAEZ%3C%2Ftext%3E%3C%2Fsvg%3E';
            };
        });
    </script>
</body>
</html>