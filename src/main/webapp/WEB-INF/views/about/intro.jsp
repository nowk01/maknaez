<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MAKNAEZ - IDENTITY</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,300;0,500;0,700;0,900;1,900&family=Syncopate:wght@400;700&display=swap');

    :root {
        --bg-color: #050505;
        --text-white: #ffffff;
        --text-gray: #888888;
        --accent-orange: #FF3B00;
    }

    body {
        background-color: var(--bg-color);
        color: var(--text-white);
        font-family: 'Montserrat', sans-serif;
        overflow-x: hidden;
        margin: 0; padding: 0;
    }

    #preloader {
        position: fixed; inset: 0;
        background: #000; z-index: 9999;
        display: flex; justify-content: center; align-items: center;
        flex-direction: column;
        transition: transform 0.8s cubic-bezier(0.77, 0, 0.175, 1);
    }
    .loader-text {
        font-family: 'Syncopate', sans-serif;
        font-weight: 700; font-size: 2rem; letter-spacing: 5px;
        color: #fff; margin-bottom: 20px;
    }
    .loader-bar-bg {
        width: 250px; height: 3px; background: #222;
        position: relative; overflow: hidden;
    }
    .loader-bar-fill {
        position: absolute; left: 0; top: 0; bottom: 0;
        width: 0%; background: var(--accent-orange);
        box-shadow: 0 0 15px var(--accent-orange);
        transition: width 1.3s ease-in-out;
    }
    body.loaded #preloader { transform: translateY(-100%); }

    .fade-up { opacity: 0; transform: translateY(50px); transition: all 1s ease; }
    .fade-up.active { opacity: 1; transform: translateY(0); }

    .hero-wrap {
        height: 100vh; width: 100%;
        position: relative; overflow: hidden;
        display: flex; justify-content: center; align-items: center;
    }
    .hero-bg {
        position: absolute; inset: -20px;
        background: url('https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=2670&auto=format&fit=crop') no-repeat center center/cover;
        filter: grayscale(100%) brightness(0.5);
        transition: transform 0.5s ease-out;
        z-index: 1;
    }
    .hero-title {
        position: relative; z-index: 2;
        font-family: 'Syncopate', sans-serif;
        font-weight: 900; font-size: 10vw;
        color: transparent;
        -webkit-text-stroke: 2px #fff;
        text-transform: uppercase;
        letter-spacing: -5px;
        mix-blend-mode: difference;
    }
    .hero-title span {
        display: block; color: var(--accent-orange); -webkit-text-stroke: 0;
        font-size: 2.5vw; letter-spacing: 10px; margin-top: -20px;
        font-family: 'Montserrat', sans-serif; font-weight: 400;
        text-align: right; 
    }

    .marquee-rail {
        background: var(--accent-orange); 
        color: #000;
        padding: 20px 0;
        overflow: hidden;
        transform: rotate(-2deg) scale(1.05);
        border-top: 2px solid #fff; border-bottom: 2px solid #fff;
        margin: 80px 0;
    }
    .marquee-content {
        white-space: nowrap;
        font-size: 3rem; font-weight: 900; font-style: italic;
        animation: scroll 15s linear infinite;
    }
    @keyframes scroll { 0% { transform: translateX(0); } 100% { transform: translateX(-50%); } }

    .brand-story {
        max-width: 1600px;
        margin: 0 auto;
        padding: 100px 5%;
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        align-items: center;
        border-top: 1px solid #333;
    }

    .story-text {
        flex: 1;
        min-width: 300px;
        padding-right: 80px; 
    }

    .story-text h2 {
        font-size: 4rem;
        font-weight: 800;
        line-height: 1;
        margin-bottom: 40px;
        text-transform: uppercase;
    }

    .story-text p {
        font-size: 1.1rem;
        line-height: 1.8;
        color: var(--text-gray);
        margin-bottom: 20px;
        word-break: keep-all;
    }

    .story-highlight {
        color: var(--accent-orange);
        font-weight: 700;
        font-size: 1.2rem;
        margin-top: 30px;
        display: inline-block;
        border-bottom: 2px solid var(--accent-orange);
        letter-spacing: 2px;
    }

    .story-img {
        flex: 1;
        min-width: 400px;
        height: 700px;
        background: url('https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=2670&auto=format&fit=crop') no-repeat center center/cover;
        filter: grayscale(100%) contrast(1.2);
        transition: filter 0.5s ease, transform 0.5s ease;
        border-radius: 4px;
    }
    .story-img:hover {
        filter: grayscale(0%) contrast(1);
        transform: scale(1.02);
    }

    .visual-full {
        height: 60vh;
        background: url('https://images.pexels.com/photos/433452/pexels-photo-433452.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1') center/cover no-repeat;
        background-color: #222;
        position: relative;
        display: flex; justify-content: center; align-items: center;
        background-attachment: fixed;
        filter: grayscale(100%) contrast(1.2);
        margin-top: 100px;
    }
    .visual-overlay { position: absolute; inset: 0; background: rgba(0,0,0,0.4); }
    
    .btn-action {
        position: relative; z-index: 10;
        padding: 20px 60px;
        border: 2px solid #fff;
        background: transparent; color: #fff;
        font-size: 1.5rem; font-weight: 700;
        cursor: pointer; overflow: hidden;
        transition: 0.3s;
    }
    .btn-action:hover {
        background: var(--accent-orange);
        border-color: var(--accent-orange);
    }
</style>
</head>
<body>

<div id="preloader">
    <div class="loader-text">MAKNAEZ SYSTEM</div>
    <div class="loader-bar-bg">
        <div class="loader-bar-fill" id="loaderBar"></div>
    </div>
</div>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
    <section class="hero-wrap" id="hero">
        <div class="hero-bg" id="heroBg"></div>
        <div class="hero-title fade-up">
            MAKNAEZ
            <span>UNLEASH YOUR POTENTIAL</span>
        </div>
    </section>

    <div class="marquee-rail">
        <div class="marquee-content">
            // URBAN UTILITY // ADVANCED PERFORMANCE // NO COMPROMISE // MAKNAEZ LAB // SEOUL //
            // URBAN UTILITY // ADVANCED PERFORMANCE // NO COMPROMISE // MAKNAEZ LAB // SEOUL //
        </div>
    </div>

    <section class="brand-story">
        <div class="story-text fade-up">
            <h2>DESIGNED<br>FOR<br>FREEDOM.</h2>
            <p>
                우리는 단순히 신발을 판매하는 것이 아닙니다.<br>
                도시의 아스팔트 위에서도, 거친 자연 속에서도<br>
                당신의 발걸음이 가장 자유로울 수 있도록 연구합니다.
            </p>
            <p>
                불필요한 장식은 덜어내고, 본질적인 기능에 집중한<br>
                MAKNAEZ만의 테크니컬 디자인을 경험해보세요.
            </p>
            <span class="story-highlight">#BEYOND_THE_LIMITS</span>
        </div>
        <div class="story-img fade-up"></div>
    </section>

    <section class="visual-full">
        <div class="visual-overlay"></div>
        <button class="btn-action" onclick="location.href='${pageContext.request.contextPath}/about/store'">MAKNAEZ STORE</button>
    </section>
</main>

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const loaderBar = document.getElementById('loaderBar');
        setTimeout(() => { loaderBar.style.width = '100%'; }, 100);
        
        setTimeout(() => {
            document.body.classList.add('loaded');
            setTimeout(() => {
                document.querySelector('.hero-title').classList.add('active');
            }, 500);
        }, 1300);

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('active');
                }
            });
        }, { threshold: 0.15 });

        document.querySelectorAll('.fade-up').forEach(el => observer.observe(el));

        const hero = document.getElementById('hero');
        const heroBg = document.getElementById('heroBg');
        hero.addEventListener('mousemove', (e) => {
            const x = (e.clientX / window.innerWidth) * 20;
            const y = (e.clientY / window.innerHeight) * 20;
            heroBg.style.transform = `translate(-${x}px, -${y}px) scale(1.05)`;
        });
    });
</script>

</body>
</html>