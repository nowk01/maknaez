function clearRecent() {
    if(!confirm("최근 본 상품 기록을 모두 삭제하시겠습니까?")) {
        return;
    }

    // 쿠키 삭제 로직 (Max-Age를 0으로 설정하여 덮어쓰기)
    const cookieName = "recent_products";
    document.cookie = cookieName + "=; path=/; max-age=0;";

    alert("삭제되었습니다.");
    location.reload(); // 페이지 새로고침
}