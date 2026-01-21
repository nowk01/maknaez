<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<script>
	$(function() {
		$('#sidebar-toggle').on('click', function() {
			$('body').toggleClass('header-wide');
		});

		$('#notiBtn').on('click', function(e) {
			e.stopPropagation();
			$('#notiDropdown').toggleClass('active');
			$('#adminMenu').removeClass('active');
		});

		$('#profileBtn').on('click', function(e) {
			e.stopPropagation();
			$('#adminMenu').toggleClass('active');
			$('#notiDropdown').removeClass('active');
		});

		$(document)
				.on(
						'click',
						function(e) {
							if (!$(e.target).closest('.notification-wrapper').length
									&& !$(e.target).closest('.profile-wrapper').length) {
								$('#notiDropdown').removeClass('active');
								$('#adminMenu').removeClass('active');
							}
						});

		var alertUrl = "${pageContext.request.contextPath}/admin/alert/list";

		$("#alertListContainer").load(
				alertUrl,
				function(response, status, xhr) {
					if (status == "error") {
						console.log("알림 로드 실패: " + xhr.status + " "
								+ xhr.statusText);
						return;
					}

					var count = $("#ajaxAlertCount").val();

					if (count && parseInt(count) > 0) {
						$('#alarm-dot').show();
					} else {
						$('#alarm-dot').hide();
					}
				});
	});
	
	function updateHeaderStatus() {
	    const statusDot = document.getElementById('header-user-status');
	    if (!statusDot) return;

	    if (navigator.onLine) {
	        statusDot.classList.remove('offline');
	    } else {
	        statusDot.classList.add('offline');
	    }
	}

	window.addEventListener('online', updateHeaderStatus);
	window.addEventListener('offline', updateHeaderStatus);

	document.addEventListener('DOMContentLoaded', updateHeaderStatus);
</script>