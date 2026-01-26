const ajaxRequest = function(url, method, requestParams, responseType, callback, file = false, contentType = 'text') {
	const sentinelNode = document.querySelector('.sentinel');
	
	const settings = {
			type: method, 
			data: requestParams,
			dataType: responseType,
			success:function(data) {
				callback(data);
			},
			beforeSend: function(xhr) {
				xhr.setRequestHeader('AJAX', true);
				
				if(sentinelNode) {
					sentinelNode.setAttribute('data-loading', 'true');
				}
			},
			complete: function () {
			},
			error: function(xhr) {
				if(xhr.status === 401) {
					alert('로그인이 필요 합니다.');
					return false;
				} else if(xhr.status === 403) {
					alert('권한이 필요 합니다.');
					return false;
				} else if(xhr.status === 406) {
					alert('요청 처리가 실패 했습니다.');
					return false;
				} else if(xhr.status === 410) {
					// console.log(xhr.responseText);
					alert('삭제된 게시물입니다.');
					return false;
				}
		    	
				console.log(xhr.responseText);
			}
	};
	
	if(file) {
		settings.processData = false;  
		settings.contentType = false; 
	}
	
	if(contentType.toLowerCase() === 'json') {
		settings.contentType = 'application/json; charset=utf-8';
	}
	
	$.ajax(url, settings);
};

$(function(){
	$(document)
	   .ajaxStart(function(){ 
		   $('#loadingLayout .loader').center();
		   $('#loadingLayout').fadeTo('slow', 0.5);
	   })
	   .ajaxComplete(function(){ 
		   $('#loadingLayout').hide();
	   });
});

$(function(){
	$('.modal').on('hide.bs.modal', function() {
		$('button, input, select, textarea').each(function(){
			$(this).blur();
		});
	});
});

$(function(){
	$('input').not($(':button')).keydown(function (evt) {
		let key = evt.key || evt.keyCode;
		if (key === 'Enter' || key === 13) {
			let fields = $(this).parents('form,body').find('button,input,textarea,select');
			let index = fields.index(this);
			if ( index > -1 && ( index + 1 ) < fields.length ) {
				fields.eq( index + 1 ).focus();
			}
			
			return false;
		}
	});
});

function checkScrollBar() {
	let hContent = $('body').height();
	let hWindow = $(window).height();
	if(hContent > hWindow) {
		return true;
	}
	
	return false;
}

jQuery.fn.center = function () {
    this.css('position', 'absolute');
    this.css('top', Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + 
                                                $(window).scrollTop()) + "px");
    this.css('left', Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + 
                                                $(window).scrollLeft()) + "px");
    return this;
}
