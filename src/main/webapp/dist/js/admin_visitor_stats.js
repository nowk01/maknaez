/**
 * MAKNAEZ Admin Visitor Stats Logic
 */
document.addEventListener("DOMContentLoaded", function() {
    initVisitorChart();
    initReferralChart();
});

function initVisitorChart() {
    const ctx = document.getElementById('visitorChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['01.05', '01.06', '01.07', '01.08', '01.09', '01.10', '01.11'],
            datasets: [{
                label: '방문자 수',
                data: [850, 1100, 920, 1450, 1180, 1560, 1240],
                borderColor: '#111',
                backgroundColor: 'rgba(17, 17, 17, 0.05)',
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                pointBackgroundColor: '#ff4e00',
                pointBorderColor: '#fff',
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f5f5f5' } },
                x: { grid: { display: false } }
            }
        }
    });
}

function initReferralChart() {
    const ctx = document.getElementById('referralChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Search', 'Social', 'Direct', 'Other'],
            datasets: [{
                data: [45, 30, 15, 10],
                backgroundColor: ['#111', '#ff4e00', '#888', '#ddd'],
                borderWidth: 0,
                hoverOffset: 12
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '65%',
            plugins: {
                legend: { position: 'bottom', labels: { usePointStyle: true, padding: 25, font: { weight: '600' } } }
            }
        }
    });
}	/**
	 * MAKNAEZ Admin Visitor Stats Logic
	 */
	document.addEventListener("DOMContentLoaded", function() {
	    initVisitorChart();
	    initReferralChart();
	});

	function initVisitorChart() {
	    const ctx = document.getElementById('visitorChart').getContext('2d');
	    new Chart(ctx, {
	        type: 'line',
	        data: {
	            labels: ['01.05', '01.06', '01.07', '01.08', '01.09', '01.10', '01.11'],
	            datasets: [{
	                label: '방문자 수',
	                data: [850, 1100, 920, 1450, 1180, 1560, 1240],
	                borderColor: '#111',
	                backgroundColor: 'rgba(17, 17, 17, 0.05)',
	                borderWidth: 3,
	                fill: true,
	                tension: 0.4,
	                pointBackgroundColor: '#ff4e00',
	                pointBorderColor: '#fff',
	                pointRadius: 4
	            }]
	        },
	        options: {
	            responsive: true,
	            maintainAspectRatio: false,
	            plugins: { legend: { display: false } },
	            scales: {
	                y: { beginAtZero: true, grid: { color: '#f5f5f5' } },
	                x: { grid: { display: false } }
	            }
	        }
	    });
	}

	function initReferralChart() {
	    const ctx = document.getElementById('referralChart').getContext('2d');
	    new Chart(ctx, {
	        type: 'doughnut',
	        data: {
	            labels: ['Search', 'Social', 'Direct', 'Other'],
	            datasets: [{
	                data: [45, 30, 15, 10],
	                backgroundColor: ['#111', '#ff4e00', '#888', '#ddd'],
	                borderWidth: 0,
	                hoverOffset: 12
	            }]
	        },
	        options: {
	            responsive: true,
	            maintainAspectRatio: false,
	            cutout: '65%',
	            plugins: {
	                legend: { position: 'bottom', labels: { usePointStyle: true, padding: 25, font: { weight: '600' } } }
	            }
	        }
	    });
	}