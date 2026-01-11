/**
 * MAKNAEZ Admin Category Logic
 */
function selectCategory(no, name, parentCode, display) {
    document.querySelectorAll('.tree-item').forEach(el => el.classList.remove('active'));
    if (event && event.currentTarget) {
        event.currentTarget.classList.add('active');
    }

    document.getElementById('cateNo').value = no;
    document.getElementById('cateName').value = name;
    
    if(document.getElementById('parentCate')) {
        if(no > 10) document.getElementById('parentCate').value = Math.floor(no/10);
        else document.getElementById('parentCate').value = "0";
    }

    if (display === 'N') document.getElementById('displayN').checked = true;
    else document.getElementById('displayY').checked = true;
}

function resetForm() {
    document.querySelectorAll('.tree-item').forEach(el => el.classList.remove('active'));
    document.getElementById('cateNo').value = '';
    document.getElementById('cateName').value = '';
    document.getElementById('parentCate').value = '0';
    document.getElementById('displayY').checked = true;
    document.getElementById('cateName').focus();
}

function setParent() {
    const currentNo = document.getElementById('cateNo').value;
    if(!currentNo) {
        alert("목록에서 상위가 될 항목을 먼저 선택해주세요.");
        return;
    }
    document.getElementById('parentCate').value = currentNo;
    document.getElementById('cateNo').value = '';
    document.getElementById('cateName').value = '';
    document.getElementById('cateName').focus();
}