<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 등록 | MAKNAEZ ADMIN</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/admin_notice_write.css">
</head>
<body>
	<div id="wrapper">
		<jsp:include page="/WEB-INF/views/admin/layout/left.jsp" />
		<div id="page-content-wrapper">
			<jsp:include page="/WEB-INF/views/admin/layout/header.jsp" />

			<div class="content-container">
				<div class="page-header">
					<h3 class="page-title">공지사항 등록</h3>
					<p class="page-desc">Create New Announcement</p>
				</div>

				<div class="card-box">
					<form name="noticeForm" method="post" enctype="multipart/form-data"
						action="${pageContext.request.contextPath}/admin/cs/notice_write">
						<table class="table-write">
							<tr>
								<th>공지 설정</th>
								<td>
									<label class="check-label">
										<input type="checkbox" name="isNotice" value="1"> 중요공지 (상단고정)
									</label>
									<label class="check-label">
										<input type="checkbox" name="isShow" value="1" checked> 바로게시
									</label>
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td>
									<input type="text" name="subject" class="form-control"
										placeholder="공지사항 제목을 입력하세요" required>
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td>
									<textarea name="content" id="content" class="form-control"
										style="height: 300px; width: 100%;"></textarea>
								</td>
							</tr>
							<tr>
								<th>첨부파일</th>
								<td>
									<input type="file" name="selectFile" class="form-control">
									<p class="file-help">* 이미지 또는 문서 파일을 업로드할 수 있습니다.</p>
								</td>
							</tr>
						</table>

						<div class="write-footer">
							<button type="button" class="btn-cancel"
								onclick="location.href='${pageContext.request.contextPath}/admin/cs/notice_list'">취소하기</button>
							<button type="submit" class="btn-submit">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp" />

	<script src="${pageContext.request.contextPath}/dist/vendor/se2/js/service/HuskyEZCreator.js"></script>

	<script src="${pageContext.request.contextPath}/dist/js/admin_notice_write.js"></script>
	
</body>
</html>