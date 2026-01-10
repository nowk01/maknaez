<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>휴면 회원 관리 - MAKNAEZ ADMIN</title>
    <jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
    
    <style>
        body { 
            background-color: #fcfcfd; 
            color: #202224; 
            font-family: 'Pretendard', -apple-system, sans-serif;
            letter-spacing: -0.4px;
        }
        
        .content-container { padding: 40px; }
        
        /* 헤더 섹션 */
        .page-header { margin-bottom: 35px; border-left: 4px solid #202224; padding-left: 20px; }
        .page-title { font-weight: 800; font-size: 28px; color: #1a1c1e; margin: 0; }
        .page-desc { color: #8a8a8a; font-size: 14px; margin-top: 4px; }

        .card-box {
            background: #ffffff;
            border-radius: 1px; 
            border: 1px solid #eee;
            box-shadow: 0 10px 30px rgba(0,0,0,0.02);
            padding: 30px;
            margin-bottom: 30px;
        }

        .search-row { display: grid; grid-template-columns: 1.5fr 1fr 2fr; gap: 20px; align-items: end; }
        .form-label { font-weight: 700; color: #333; font-size: 12px; margin-bottom: 10px; display: block; text-transform: uppercase; }
        .form-control, .form-select {
            border-radius: 0; border: none; border-bottom: 1px solid #ddd; height: 40px; font-size: 14px; padding: 0; transition: all 0.3s;
        }
        .form-control:focus, .form-select:focus {
            border-bottom: 2px solid #202224; box-shadow: none;
        }
        .btn-black {
            background: #202224; color: #fff; border: none; padding: 10px 30px; font-weight: 600; font-size: 13px; height: 40px; transition: 0.3s;
        }
        .btn-black:hover { background: #000; letter-spacing: 0.5px; }

        /* 액션 컨트롤러 */
        .list-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .count-info { font-size: 14px; color: #666; }
        .count-info b { color: #000; font-size: 16px; }
        
        .action-group .btn { 
            font-size: 12px; font-weight: 600; padding: 6px 15px; border-radius: 0; margin-left: 5px; border: 1px solid #ddd; background: #fff; color: #555;
        }
        .action-group .btn:hover { border-color: #000; color: #000; }

        .table { width: 100%; border-top: 2px solid #202224; }
        .table thead th {
            background: #fbfbfb; color: #222; font-weight: 700; font-size: 13px; padding: 15px; border-bottom: 1px solid #eee; text-align: center;
        }
        .table tbody td {
            padding: 20px 15px; vertical-align: middle; border-bottom: 1px solid #f5f5f5; text-align: center; font-size: 14px; color: #444;
        }
        .table tbody tr:hover { background-color: #fafafa; }

        .badge-clean {
            font-size: 11px; font-weight: 700; padding: 4px 10px; border: 1px solid #eee; color: #888; text-transform: uppercase;
        }
        .badge-active { border-color: #202224; color: #202224; }
        .badge-point { border-color: #e5e7eb; background: #f9fafb; color: #374151; }

        .pagination .page-link { border: none; color: #999; font-size: 14px; padding: 8px 15px; transition: 0.2s; }
        .pagination .page-item.active .page-link { background: none; color: #000; font-weight: 800; text-decoration: underline; }
        .pagination .page-link:hover { color: #000; background: none; }

    </style>
</head>
<body>

    <div id="wrapper">
        <jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />

        <div id="page-content-wrapper">
            <jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

            <div class="content-container">
                
                <div class="page-header">
                    <h3 class="page-title">DORMANT MANAGEMENT</h3>
                    <p class="page-desc">Manage dormant accounts and security protocols.</p>
                </div>

                <div class="card-box">
                    <form class="search-row">
                        <div>
                            <label class="form-label">Period</label>
                            <div class="d-flex align-items-center">
                                <input type="date" class="form-control" value="2025-01-01">
                                <span class="mx-2 text-muted">~</span>
                                <input type="date" class="form-control" value="2026-01-08">
                            </div>
                        </div>
                        <div>
                            <label class="form-label">Mail Status</label>
                            <select class="form-select">
                                <option>ALL STATUS</option>
                                <option>SENT</option>
                                <option>WAITING</option>
                            </select>
                        </div>
                        <div>
                            <label class="form-label">Search</label>
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="ID or Member Name">
                                <button class="btn-black">SEARCH</button>
                            </div>
                        </div>
                    </form>
                </div>

                <div class="card-box" style="padding: 40px;">
                    <div class="list-header">
                        <div class="count-info">Showing <b>3</b> members found</div>
                        <div class="action-group">
                            <button class="btn">RESTORE</button>
                            <button class="btn">SEND MAIL</button>
                            <button class="btn" style="color: #d93025;">DELETE</button>
                        </div>
                    </div>

                    <table class="table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" class="form-check-input"></th>
                                <th>NO</th>
                                <th>ID</th>
                                <th>NAME</th>
                                <th>LAST LOGIN</th>
                                <th>DORMANT DATE</th>
                                <th>STATUS</th>
                                <th>MAIL</th>
                                <th>SETTING</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>3</td>
                                <td class="fw-bold">sleeping_lion</td>
                                <td>사자후</td>
                                <td style="color: #999;">2024.12.10</td>
                                <td class="fw-bold" style="color: #000;">2025.12.10</td>
                                <td><span class="badge-clean badge-active">Dormant</span></td>
                                <td><span class="badge-clean">Sent</span></td>
                                <td><i class="fas fa-ellipsis-v" style="cursor: pointer; color: #ccc;"></i></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>2</td>
                                <td class="fw-bold">ghost_user</td>
                                <td>유령회원</td>
                                <td style="color: #999;">2024.05.20</td>
                                <td class="fw-bold" style="color: #000;">2025.05.20</td>
                                <td><span class="badge-clean badge-active">Dormant</span></td>
                                <td><span class="badge-clean badge-point">Waiting</span></td>
                                <td><i class="fas fa-ellipsis-v" style="cursor: pointer; color: #ccc;"></i></td>
                            </tr>
                            <tr>
                                <td><input type="checkbox" class="form-check-input"></td>
                                <td>1</td>
                                <td class="fw-bold">user_03</td>
                                <td>현곡</td>
                                <td style="color: #999;">2025.01.03</td>
                                <td class="fw-bold" style="color: #000;">2026.01.03</td>
                                <td><span class="badge-clean badge-active">Dormant</span></td>
                                <td><span class="badge-clean">Sent</span></td>
                                <td><i class="fas fa-ellipsis-v" style="cursor: pointer; color: #ccc;"></i></td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="mt-5 d-flex justify-content-center">
                        <ul class="pagination">
                            <li class="page-item"><a class="page-link" href="#">PREV</a></li>
                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                            <li class="page-item"><a class="page-link" href="#">NEXT</a></li>
                        </ul>
                    </div>
                </div>

            </div>
        </div>
    </div>  
    <jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />
</body>
</html>