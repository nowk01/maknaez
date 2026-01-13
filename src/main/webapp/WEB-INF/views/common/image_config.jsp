	<%@ page contentType="text/html; charset=UTF-8" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core"%>
	
	<%-- 
	    [Image Configuration]
	    Updated: MEN / WOMEN / SPORTSSTYLE / SALE
	    Style: High-End Techwear & Dark Mood
	--%>
	
	<%-- HERO SLIDER --%>
	<c:set var="img_hero_1" value="https://images.pexels.com/photos/1271619/pexels-photo-1271619.jpeg?auto=compress&cs=tinysrgb&w=1600" scope="request"/>
	<c:set var="img_hero_2" value="https://images.pexels.com/photos/1365425/pexels-photo-1365425.jpeg?auto=compress&cs=tinysrgb&w=1600" scope="request"/>
	<c:set var="img_hero_3" value="https://images.pexels.com/photos/1450360/pexels-photo-1450360.jpeg?auto=compress&cs=tinysrgb&w=1600" scope="request"/>
	
	<%-- WIDE BANNER --%>
	<c:set var="img_wide_banner" value="https://images.pexels.com/photos/2387873/pexels-photo-2387873.jpeg?auto=compress&cs=tinysrgb&w=1600" scope="request"/>
	
	<%-- 
	    [CATEGORY NAV IMAGES] 
	    요청하신 4개 카테고리 (MEN, WOMEN, SPORTSSTYLE, SALE)에 맞게 설정
	--%>
	<c:set var="img_cat_men" value="https://images.pexels.com/photos/845457/pexels-photo-845457.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/> <c:set var="img_cat_women" value="https://images.pexels.com/photos/1921336/pexels-photo-1921336.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/> <c:set var="img_cat_sportstyle" value="https://images.pexels.com/photos/1464625/pexels-photo-1464625.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/> <c:set var="img_cat_sale" value="https://images.pexels.com/photos/3011385/pexels-photo-3011385.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/> <%-- LATEST DROPS (세로 비율, Cover 적용용) --%>
	<c:set var="img_prod_xt6" value="https://images.pexels.com/photos/1464625/pexels-photo-1464625.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	<c:set var="img_prod_speedcross" value="https://images.pexels.com/photos/1124466/pexels-photo-1124466.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	<c:set var="img_prod_acs" value="https://images.pexels.com/photos/1478442/pexels-photo-1478442.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	<c:set var="img_prod_women" value="https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>

	
	<c:set var="img_cat_trail_1" value="https://images.pexels.com/photos/1571799/pexels-photo-1571799.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	<c:set var="img_cat_trail_2" value="https://images.pexels.com/photos/2403474/pexels-photo-2403474.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	
	<c:set var="img_cat_road_1" value="https://images.pexels.com/photos/1464625/pexels-photo-1464625.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	<c:set var="img_cat_road_2" value="https://images.pexels.com/photos/6076412/pexels-photo-6076412.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	
	<c:set var="img_cat_hiking_1" value="https://images.pexels.com/photos/1365428/pexels-photo-1365428.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	<c:set var="img_cat_hiking_2" value="https://images.pexels.com/photos/1032110/pexels-photo-1032110.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	
	<c:set var="img_cat_sandal_1" value="https://images.pexels.com/photos/3353621/pexels-photo-3353621.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	<c:set var="img_cat_sandal_2" value="https://images.pexels.com/photos/1320701/pexels-photo-1320701.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	
	<c:set var="img_cat_sale_1" value="https://images.pexels.com/photos/3011385/pexels-photo-3011385.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	<c:set var="img_cat_sale_2" value="https://images.pexels.com/photos/5632371/pexels-photo-5632371.jpeg?auto=compress&cs=tinysrgb&w=800" scope="request"/>
	
	
	<%-- list에서 이미지 뽑아오기 --%>
	<c:set var="uploadPath" value="${pageContext.request.contextPath}/uploads" scope="request"/>