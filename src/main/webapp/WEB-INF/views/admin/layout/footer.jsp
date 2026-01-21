<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<script>
$(function() {
    $('#sidebar-toggle').on('click', function() { $('body').toggleClass('header-wide'); });
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

    $(document).on('click', function(e) {
        if (!$(e.target).closest('.notification-wrapper').length && !$(e.target).closest('.profile-wrapper').length) {
            $('#notiDropdown').removeClass('active'); 
            $('#adminMenu').removeClass('active');
        }
    });

    function loadAlerts() {
        var alertUrl = "${pageContext.request.contextPath}/admin/alert/list";
        $("#alertListContainer").load(alertUrl, function(response, status, xhr) {
            if (status != "error") {
                var count = $("#ajaxAlertCount").val();
                if (count && parseInt(count) > 0) { 
                    $('#alarm-dot').show(); 
                } else { 
                    $('#alarm-dot').hide(); 
                }
            }
        });
    }

    loadAlerts();
    
    $(document).off('click', '.noti-item').on('click', '.noti-item', function() {
        var $item = $(this);
        var alertIdx = $item.attr('data-alert-idx');
        var moveUrl = $item.attr('data-url');
        
        if (!moveUrl) return;

        if (!$item.hasClass('unread')) {
            location.href = moveUrl;
            return;
        }

        $item.removeClass('unread'); 
        $item.css('opacity', '0.5');
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/alert/read',
            type: 'post',
            data: { alertIdx: alertIdx },
            success: function() {
                location.href = moveUrl;
            },
            error: function() {
                location.href = moveUrl; 
            }
        });
    });
    
    
    

    $(document).on('click', '.noti-header a', function(e) {
        e.preventDefault();
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/alert/readAll',
            type: 'post',
            success: function(res) {
                if (res.state === 'true') {
                    $('.noti-item').removeClass('unread');
                    $('#alarm-dot').hide();
                }
            }
        });
    });

    function checkRemainingAlerts() {
        if ($('.noti-item.unread').length === 0) {
            $('#alarm-dot').hide();
        }
    }
});

function updateHeaderStatus() {
    var statusDot = document.getElementById('header-user-status');
    if (statusDot) {
        statusDot.classList.toggle('offline', !navigator.onLine);
    }
}
window.addEventListener('online', updateHeaderStatus);
window.addEventListener('offline', updateHeaderStatus);
document.addEventListener('DOMContentLoaded', updateHeaderStatus);
</script>