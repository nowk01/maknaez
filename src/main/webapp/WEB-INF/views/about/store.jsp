<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MAKNAEZ - HQ LOCATION</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=본인카카오api주소"></script>

<style>
    /* =========================================
       MAKNAEZ TECH THEME - STORE (Orange Ver.)
       ========================================= */
    @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@300;500;700;900&family=Syncopate:wght@700&display=swap');

    :root {
        --bg-color: #050505;
        --text-white: #ffffff;
        --text-gray: #888888;
        --line-color: #333333;
        --accent-color: #FF3B00; /* 인트로와 동일한 주황색 */
    }

    body {
        background-color: var(--bg-color);
        color: var(--text-white);
        font-family: 'Montserrat', sans-serif;
        overflow-x: hidden;
        margin: 0; padding: 0;
    }

    /* 레이아웃 */
    .store-container {
        display: flex;
        flex-wrap: wrap;
        min-height: 100vh;
        padding-top: 60px; /* 헤더 공간 */
    }

    /* [LEFT] 정보 영역 */
    .info-section {
        flex: 1;
        min-width: 450px;
        background: var(--bg-color);
        padding: 80px 60px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        border-right: 1px solid var(--line-color);
        position: relative;
    }

    /* 타이틀 디자인 */
    .page-header {
        margin-bottom: 60px;
    }
    .page-subtitle {
        font-size: 1rem;
        color: var(--accent-color);
        letter-spacing: 5px;
        font-weight: 700;
        margin-bottom: 10px;
        display: block;
    }
    .page-title {
        font-family: 'Syncopate', sans-serif;
        font-size: 4.5rem;
        line-height: 0.9;
        font-weight: 700;
        text-transform: uppercase;
        color: transparent;
        -webkit-text-stroke: 1px #fff;
    }
    .page-title span {
        display: block;
        color: #fff;
        -webkit-text-stroke: 0;
    }

    /* 정보 리스트 */
    .info-list {
        display: flex;
        flex-direction: column;
        gap: 50px;
    }

    .info-item {
        position: relative;
        padding-left: 20px;
        border-left: 2px solid #333;
        transition: 0.3s;
    }
    .info-item:hover {
        border-left-color: var(--accent-color);
    }

    .label {
        font-size: 0.85rem;
        color: var(--accent-color);
        font-weight: 700;
        letter-spacing: 2px;
        margin-bottom: 10px;
        display: block;
        text-transform: uppercase;
    }
    .value {
        font-size: 1.5rem;
        font-weight: 500;
        line-height: 1.4;
    }
    .sub-value {
        font-size: 1rem;
        color: var(--text-gray);
        margin-top: 5px;
    }

    /* 버튼 스타일 */
    .map-link-btn {
        margin-top: 40px;
        display: inline-block;
        padding: 18px 40px;
        border: 1px solid var(--text-white);
        color: var(--text-white);
        text-decoration: none;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.3s ease;
        background: transparent;
        cursor: pointer;
    }
    .map-link-btn:hover {
        background: var(--accent-color);
        border-color: var(--accent-color);
        color: #fff;
    }

    /* [RIGHT] 지도 영역 */
    .map-section {
        flex: 1.5;
        min-width: 500px;
        background: #1a1a1a;
        position: relative;
        overflow: hidden;
    }

    #map {
        width: 100%; height: 100%;
        /* ★ 핵심: 지도를 흑백 반전시켜 다크모드처럼 보이게 함 ★ */
        filter: grayscale(100%) invert(92%) contrast(1.1);
        opacity: 0.9;
    }

    /* 지도 로딩 실패 시 보여줄 대체 이미지 (폴백) */
    .map-fallback {
        position: absolute; inset: 0;
        /* 멋진 흑백 지도 이미지 */
        background: url('https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=2674&auto=format&fit=crop') center/cover;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1;
    }
    .map-fallback::after {
        content: ''; position: absolute; inset: 0;
        background: rgba(0,0,0,0.5); /* 어둡게 처리 */
    }

    .fallback-content {
        position: relative; z-index: 2;
        border: 1px solid var(--accent-color);
        padding: 20px 40px;
        text-align: center;
        background: rgba(0,0,0,0.8);
        backdrop-filter: blur(5px);
    }
    .fallback-content h3 {
        color: var(--accent-color);
        font-size: 1.5rem; margin: 0 0 10px 0;
        letter-spacing: 2px;
    }
    .fallback-content p {
        color: #fff; font-size: 0.9rem; margin: 0;
    }

    /* 장식 요소 (Crosshair) */
    .crosshair {
        position: absolute; width: 20px; height: 20px;
        border: 1px solid var(--accent-color);
        top: 50%; left: 50%; transform: translate(-50%, -50%);
        z-index: 10; pointer-events: none;
        opacity: 0.7;
    }
    .crosshair::before, .crosshair::after {
        content:''; position: absolute; background: var(--accent-color);
    }
    .crosshair::before { top: 9px; left: -5px; width: 30px; height: 1px; }
    .crosshair::after { left: 9px; top: -5px; height: 30px; width: 1px; }

    /* 애니메이션 */
    .reveal {
        opacity: 0; transform: translateX(-30px);
        transition: 1s cubic-bezier(0.165, 0.84, 0.44, 1);
    }
    .reveal.active { opacity: 1; transform: translateX(0); }

</style>
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<div class="store-container">
    <div class="info-section">
        <div class="page-header reveal">
            <span class="page-subtitle">HQ LOCATION</span>
            <div class="page-title">
                MAKNAEZ<br>
                <span>BASE CAMP.</span>
            </div>
        </div>

        <div class="info-list">
            <div class="info-item reveal" style="transition-delay: 0.1s;">
                <span class="label">ADDRESS</span>
                <div class="value">
                    서울특별시 마포구 월드컵북로 21<br>
                    풍성빌딩 2F - 4F
                </div>
                <div class="sub-value">Hongik Univ. Station Exit 1 (300m)</div>
            </div>

            <div class="info-item reveal" style="transition-delay: 0.2s;">
                <span class="label">OPENING HOURS</span>
                <div class="value">11:00 - 21:00</div>
                <div class="sub-value">Break Time : 15:00 - 16:00</div>
            </div>

            <div class="info-item reveal" style="transition-delay: 0.3s;">
                <span class="label">CONTACT</span>
                <div class="value">02-333-7777</div>
                <div class="sub-value">help@maknaez.com</div>
            </div>
        </div>

        <div class="reveal" style="transition-delay: 0.4s;">
            <a href="https://map.kakao.com/link/search/서울특별시 마포구 월드컵북로 21" target="_blank" class="map-link-btn">
                Open Kakao Map
            </a>
        </div>
    </div>

    <div class="map-section">
        <div id="map"></div>
        
        <div id="mapFallback" class="map-fallback" style="display:none;">
            <div class="fallback-content">
                <h3>MAP OFFLINE</h3>
                <p>Connecting to Satellite...</p>
                </div>
        </div>

        <div class="crosshair"></div>
        
        <div style="position:absolute; bottom:30px; right:30px; text-align:right; font-family:monospace; color:var(--accent-color); font-size:0.8rem; z-index:10;">
            LAT : 37.555946<br>
            LNG : 126.919597
        </div>
    </div>
</div>

<footer>
    <jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
</footer>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        // 텍스트 등장 애니메이션
        setTimeout(() => {
            document.querySelectorAll('.reveal').forEach(el => el.classList.add('active'));
        }, 100);

        // 카카오맵 설정
        const container = document.getElementById('map');
        const fallback = document.getElementById('mapFallback');
        
        // 마포구 풍성빌딩 좌표
        const lat = 37.555946;
        const lng = 126.919597;

        try {
            if (typeof kakao !== 'undefined' && kakao.maps) {
                const options = { center: new kakao.maps.LatLng(lat, lng), level: 3 };
                const map = new kakao.maps.Map(container, options);
                
                // 마커 커스텀 (기본 마커 말고 커스텀 오버레이나 이미지 가능하지만 심플하게 기본으로)
                const markerPosition  = new kakao.maps.LatLng(lat, lng); 
                const marker = new kakao.maps.Marker({ position: markerPosition });
                marker.setMap(map);

                // 마커 위에 검은색/주황색 라벨 표시
                const content = `
                    <div style="
                        padding: 8px 15px; 
                        background: #000; 
                        color: #fff; 
                        border: 1px solid #FF3B00; 
                        font-family: 'Montserrat'; 
                        font-weight: 700; 
                        font-size: 12px;
                        box-shadow: 5px 5px 15px rgba(0,0,0,0.5);
                        transform: translateY(-50px);
                    ">
                        MAKNAEZ HQ
                    </div>
                `;
                
                const customOverlay = new kakao.maps.CustomOverlay({
                    position: markerPosition,
                    content: content,
                    yAnchor: 1 
                });
                customOverlay.setMap(map);

            } else {
                throw new Error("Kakao SDK not loaded");
            }
        } catch (e) {
            // API 키가 없거나 로드 실패시 -> 멋진 대체 이미지 표시
            console.log("Map Load Failed. Switching to Fallback Mode.");
            container.style.display = 'none';
            fallback.style.display = 'flex';
        }
    });
</script>

</body>
</html>