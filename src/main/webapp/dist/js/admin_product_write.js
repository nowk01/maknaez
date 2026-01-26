var oEditors = []; 

document.addEventListener("DOMContentLoaded", function() {
    if(typeof contextPath !== 'undefined') {
        nhn.husky.EZCreator.createInIFrame({
            oAppRef: oEditors,
            elPlaceHolder: "prodDesc", 
            sSkinURI: contextPath + "/dist/vendor/se2/SmartEditor2Skin.html",
            htParams : {
                bUseToolbar : true,             
                bUseVerticalResizer : true,     
                bUseModeChanger : true,
                fOnBeforeUnload : function(){
                }
            }, 
            fCreator: "createSEditor2"
        });
    } else {
        console.error("contextPath is undefined. Check JSP file.");
    }

    const sizeList = [220, 230, 235, 240, 245, 250, 255, 260, 265, 270, 275, 280, 285, 290];
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

    window.openFile = function(id) {
        document.getElementById(id).click();
    };

    window.previewImage = function(input, boxId) {
        const box = document.getElementById(boxId);
        
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                box.style.backgroundImage = "url('" + e.target.result + "')";
                box.style.backgroundSize = "cover";
                box.style.backgroundPosition = "center";
                box.style.backgroundRepeat = "no-repeat";
                box.style.border = "2px solid #ff4e00"; 
                
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

function previewImage(input, boxId) {
    const box = document.getElementById(boxId);
    
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        
        reader.onload = function(e) {
            const oldImages = box.querySelectorAll('img');
            oldImages.forEach(img => img.remove());
            
            const span = box.querySelector('span');
            if(span) span.style.display = 'none';

            const newImg = document.createElement('img');
            newImg.src = e.target.result;
            newImg.style.width = '100%';
            newImg.style.height = '100%';
            newImg.style.objectFit = 'cover';
            newImg.style.borderRadius = '8px';
            
            box.appendChild(newImg);
        };
        
        reader.readAsDataURL(input.files[0]);
    }
}

function removeOptionRow(btn) {
    var row = btn.parentNode.parentNode;
    row.parentNode.removeChild(row);
}

function submitProduct() {
    if(oEditors.length > 0 && oEditors.getById["prodDesc"]) {
        oEditors.getById["prodDesc"].exec("UPDATE_CONTENTS_FIELD", []);
    }
    
    const f = document.getElementById("productForm");
    const mode = f.mode.value; 
    
    if(!f.cateCode.value) {
        alert("카테고리를 선택하세요.");
        f.cateCode.focus();
        return;
    }
    
    if(!f.prodName.value.trim()) {
        alert("상품명을 입력하세요.");
        f.prodName.focus();
        return;
    }
    
    if(!f.base_price.value.trim() || isNaN(f.base_price.value)) {
        alert("판매가를 숫자로 올바르게 입력하세요.");
        f.base_price.focus();
        return;
    }

	    if(mode === "write") {
        if(!f.thumbnailFile.value) {
            alert("대표 이미지를 등록해주세요.");
            return;
        }
    }
    
    let content = document.getElementById("prodDesc").value;
    if(content === "" || content === "<p>&nbsp;</p>") {
        alert("상품 상세 설명을 입력하세요.");
        return;
    }

    
    f.submit();
}


function deleteExistingFile(fileId, boxId, event) {
    event.stopPropagation();
    
    if(!confirm("이미지를 삭제하시겠습니까?")) {
        return;
    }
    
    const url = contextPath + "/admin/product/deleteFile";
    $.ajax({
        type: "POST",
        url: url,
        data: { fileId: fileId },
        dataType: "json",
        success: function(data) {
            if(data.state === "true") {
                const box = document.getElementById(boxId);
                
                $(box).find(".existing-img").remove();
                $(box).find(".btn-img-delete").remove();
                $(box).find("input[name=prevImgIds]").remove();
                
                alert("삭제되었습니다.");
            } else {
                alert("삭제 실패");
            }
        },
        error: function() {
            alert("삭제 중 에러가 발생했습니다.");
        }
    });
}