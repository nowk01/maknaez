<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header>
    <div class="logo">
        <a href="${pageContext.request.contextPath}/main">MAKNAEZ</a>
    </div>

    <nav class="gnb">
        <ul class="gnb-list">
            
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/collections/list?category=men" class="nav-link">MEN</a>
                <div class="mega-menu">
                    <div class="mega-container">
                        <div class="mega-promo">
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Men Style">
                                <span class="promo-text">NEW ARRIVALS</span>
                            </div>
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Shoes Detail">
                            </div>
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/1464625/pexels-photo-1464625.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Techwear">
                            </div>
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/1271619/pexels-photo-1271619.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Outdoor">
                                <span class="promo-text">OUTDOOR</span>
                            </div>
                        </div>
                        
                        <div class="mega-links reduced-col">
                            <div class="link-col">
                                <h3>CATEGORY</h3>
                                <ul>
                                    <li><a href="#">전체보기</a></li>
                                    <li><a href="#">트레일 러닝</a></li>
                                    <li><a href="#">로드 러닝</a></li>
                                    <li><a href="#">하이킹 & 아웃도어</a></li>
                                    <li><a href="#">샌들 / 슬라이드</a></li>
                                </ul>
                            </div>
                            <div class="link-col">
                                <h3>FEATURED</h3>
                                <ul>
                                    <li><a href="#">신상품 (New)</a></li>
                                    <li><a href="#">베스트셀러</a></li>
                                    <li><a href="#">고어텍스 (Gore-Tex)</a></li>
                                    <li><a href="#">S/LAB (Premium)</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </li>

            <li class="nav-item">
                <a href="/shop/women" class="nav-link">WOMEN</a>
                <div class="mega-menu">
                    <div class="mega-container">
                        <div class="mega-promo">
                             <div class="promo-item">
                                <img src="https://images.pexels.com/photos/1921336/pexels-photo-1921336.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Women Style">
                                <span class="promo-text">WOMEN'S RUN</span>
                            </div>
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/2444429/pexels-photo-2444429.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Shoes">
                            </div>
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/2529157/pexels-photo-2529157.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Detail">
                            </div>
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/2885429/pexels-photo-2885429.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Lookbook">
                                <span class="promo-text">LOOKBOOK</span>
                            </div>
                        </div>

                        <div class="mega-links reduced-col">
                            <div class="link-col">
                                <h3>CATEGORY</h3>
                                <ul>
                                    <li><a href="#">전체보기</a></li>
                                    <li><a href="#">트레일 러닝</a></li>
                                    <li><a href="#">로드 러닝</a></li>
                                    <li><a href="#">하이킹 & 아웃도어</a></li>
                                    <li><a href="#">샌들 / 슬라이드</a></li>
                                </ul>
                            </div>
                            <div class="link-col">
                                <h3>FEATURED</h3>
                                <ul>
                                    <li><a href="#">신상품 (New)</a></li>
                                    <li><a href="#">베스트셀러</a></li>
                                    <li><a href="#">여성 전용 핏</a></li>
                                    <li><a href="#">S/LAB (Premium)</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </li>

            <li class="nav-item">
                <a href="/shop/sportstyle" class="nav-link">SPORTSTYLE</a>
                <div class="mega-menu">
                    <div class="mega-container" style="display: flex; justify-content: center; align-items: center; padding: 40px 0;">
                         <div style="text-align: center;">
                             <h3 style="font-size: 2.5rem; font-family:'Archivo'; font-style: italic; margin-bottom: 10px;">XT-6 / ACS PRO</h3>
                             <p style="color:#666; margin-bottom: 20px;">도심 속의 테크니컬 스니커즈</p>
                             <a href="#" style="text-decoration: underline; font-weight: bold;">전체 컬렉션 보기 &rarr;</a>
                         </div>
                    </div>
                </div>
            </li>

            <li class="nav-item">
                <a href="/shop/sale" class="nav-link" style="color: #ff4e00;">SALE</a>
                <div class="mega-menu">
                    <div class="mega-container">
                        <div class="mega-promo">
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/1456706/pexels-photo-1456706.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Sale">
                                <span class="promo-text" style="color: #ff4e00;">SEASON OFF</span>
                            </div>
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/3490360/pexels-photo-3490360.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Red">
                            </div>
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/1598505/pexels-photo-1598505.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Shoes">
                            </div>
                            <div class="promo-item">
                                <img src="https://images.pexels.com/photos/1124466/pexels-photo-1124466.jpeg?auto=compress&cs=tinysrgb&w=400" alt="Run">
                                <span class="promo-text" style="color: #ff4e00;">LAST CHANCE</span>
                            </div>
                        </div>

                        <div class="mega-links reduced-col">
                            <div class="link-col">
                                <h3 style="color: #ff4e00;">PRICE</h3>
                                <ul>
                                    <li><a href="#">5만원 ~ 10만원</a></li>
                                    <li><a href="#">10만원 ~ 15만원</a></li>
                                    <li><a href="#">15만원 이상</a></li>
                                </ul>
                            </div>
                            <div class="link-col">
                                <h3>LAST CHANCE</h3>
                                <ul>
                                    <li><a href="#">5% 미만 세일</a></li>
                                    <li><a href="#">10% 미만 세일</a></li>
                                    <li><a href="#">20% 미만 세일</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </li>

        </ul>
    </nav>

    <div class="user-actions">
        <div class="icon-btn"><i class="ph ph-magnifying-glass"></i></div>
        
        
        <c:choose>
            <c:when test="${not empty sessionScope.member}">
                
                <a href="${pageContext.request.contextPath}/member/mypage/main.do" class="icon-btn" style="color: inherit; text-decoration: none; display: flex; align-items: center; justify-content: center;">
                    <i class="ph ph-user"></i>
                </a>
            </c:when>
            <c:otherwise>
                
                <a href="${pageContext.request.contextPath}/member/login" class="icon-btn" style="color: inherit; text-decoration: none; display: flex; align-items: center; justify-content: center;">
                    <i class="ph ph-user"></i>
                </a>
            </c:otherwise>
        </c:choose>

        <div class="icon-btn"><i class="ph ph-shopping-bag"></i></div>
    </div>
</header>