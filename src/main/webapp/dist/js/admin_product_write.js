document.addEventListener("DOMContentLoaded", function() {
    const sizeList = [225, 230, 235, 240, 245, 250, 255, 260, 265, 270, 275, 280, 285, 290, 295, 300];
    const optionTbody = document.getElementById('optionTbody');
    const colorInput = document.getElementById('colorInput');

    window.generateOptions = function() {
        const color = colorInput.value.trim();
        if(!color) { alert("먼저 추가할 색상을 입력해주세요."); return; }

        const fragment = document.createDocumentFragment();
        sizeList.forEach(size => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td style="font-weight:800;">${color}</td>
                <td style="font-weight:700; color:#666;">${size} mm</td>
                <td><input type="number" class="form-control input-stock" name="stock" value="0"></td>
                <td><input type="number" class="form-control input-stock" name="extraPrice" value="0"></td>
                <td><button type="button" class="btn btn-sm" onclick="this.closest('tr').remove()">×</button></td>
            `;
            fragment.appendChild(tr);
        });
        optionTbody.appendChild(fragment);
        colorInput.value = '';
    };

    window.openFile = function(id) { document.getElementById(id).click(); };
});