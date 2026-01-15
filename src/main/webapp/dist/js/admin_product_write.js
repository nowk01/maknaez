var oEditors = []; // 스마트 에디터 객체 담을 배열

document.addEventListener("DOMContentLoaded", function() {
    
    // [1] 스마트 에디터 로딩
    // [수정 3] JSP 상단에서 contextPath가 미리 선언되었으므로 정상적으로 경로를 찾습니다.
    if(typeof contextPath !== 'undefined') {
        nhn.husky.EZCreator.createInIFrame({
            oAppRef: oEditors,
            elPlaceHolder: "prodDesc", // textarea ID
            sSkinURI: contextPath + "/dist/vendor/se2/SmartEditor2Skin.html",
            htParams : {
                bUseToolbar : true,             
                bUseVerticalResizer : true,     
                bUseModeChanger : true,
                fOnBeforeUnload : function(){
                    // alert("완료!");
                }
            }, 
            fCreator: "createSEditor2"
        });
    } else {
        console.error("contextPath is undefined. Check JSP file.");
    }

    // [2] 사이즈 옵션 생성 기능
    const sizeList = [225, 230, 235, 240, 245, 250, 255, 260, 265, 270, 275, 280, 285, 290, 295, 300];
    const optionTbody = document.getElementById('optionTbody');
    const colorInput = document.getElementById('colorInput');

    window.generateOptions = function() {
        const color = colorInput.value; 
        
        if(optionTbody.rows.length > 0) {
            if(!confirm("기존 옵션을 초기화하고 새로 생성하시겠습니까?")) return;
            optionTbody.innerHTML = "";
        }

        const fragment = document.createDocumentFragment();
        sizeList.forEach(size => {
            const tr = document.createElement('tr');
            // [수정 1] 삭제 버튼 td 제거 (3칸 구성: 색상, 사이즈, 재고)
			tr.innerHTML = `
			                <td style="font-weight:800; vertical-align:middle;">${color}</td>
			                <td style="font-weight:700; color:#666; vertical-align:middle;">
			                    ${size} mm
			                    <input type="hidden" name="sizes" value="${size}">
			                    <input type="hidden" name="pdSize" value="${size}">
			                </td>
			                <td style="vertical-align:middle;">
			                    <input type="number" class="form-control input-stock" name="stocks" value="0" min="0" style="width:100px;">
			                </td>
							<td style="vertical-align:middle; text-align: center;"> <button type="button" 
			                            style="border:none; background:none; color:black; font-weight:bold; font-size:1.2em; cursor:pointer;" 
			                            onclick="removeOptionRow(this)">
			                        X
			                    </button>
			                </td>
			            `;
            fragment.appendChild(tr);
        });
        optionTbody.appendChild(fragment);
    };

    // [3] 파일 업로드 트리거
    window.openFile = function(id) {
        document.getElementById(id).click();
    };

    // [수정 2] 이미지 미리보기 함수 구현
    window.previewImage = function(input, boxId) {
        const box = document.getElementById(boxId);
        
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                // 이미지를 배경으로 설정
                box.style.backgroundImage = "url('" + e.target.result + "')";
                box.style.backgroundSize = "cover";
                box.style.backgroundPosition = "center";
                box.style.backgroundRepeat = "no-repeat";
                box.style.border = "2px solid #ff4e00"; // 활성화 시 테두리 강조
                
                // 박스 안의 텍스트(span)나 아이콘 등을 숨김 처리 (input 제외)
                const children = box.children;
                for(let i=0; i<children.length; i++) {
                    if(children[i].tagName !== 'INPUT') {
                        children[i].style.display = 'none';
                    }
                }
            };
            
            reader.readAsDataURL(input.files[0]);
        }
    };
});

function removeOptionRow(btn) {
    var row = btn.parentNode.parentNode;
    row.parentNode.removeChild(row);
}

// [4] 폼 전송 (에디터 내용 동기화 필수)
function submitProduct() {
    // 에디터의 내용을 textarea에 적용
    if(oEditors.length > 0 && oEditors.getById["prodDesc"]) {
        oEditors.getById["prodDesc"].exec("UPDATE_CONTENTS_FIELD", []);
    }
    
    const f = document.getElementById("productForm");
    
    if(!f.prodName.value.trim()) { alert("상품명을 입력하세요."); f.prodName.focus(); return; }
    if(!f.price.value.trim()) { alert("가격을 입력하세요."); f.price.focus(); return; }
    if(!f.cateCode.value) { alert("카테고리를 선택하세요."); f.cateCode.focus(); return; }
    
    // 내용 유효성 검사 (HTML 태그 제거 후 검사)
    let content = document.getElementById("prodDesc").value;
    if( content == ""  || content == null || content == '&nbsp;' || content == '<p>&nbsp;</p>')  {
         alert("상품 상세 설명을 입력하세요.");
         if(oEditors.length > 0) oEditors.getById["prodDesc"].exec("FOCUS"); //포커싱
         return;
    }

    f.submit();
}