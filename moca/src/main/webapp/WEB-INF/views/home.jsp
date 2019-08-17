<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>

<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.min.css">
	<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
	<!-- 
	<script type="text/javascript" src="resources/js/jquery.mobile-1.4.5.js"></script>
 -->
	<script type="text/javascript">
		var reviewModal;
		var reviewForm;
		var reviewModalBtn;
		var saveReviewBtn;


		$(document).ready(function() {
			console.log("onready")

			reviewModal = $('#reviewModal');
			reviewForm = $('#reviewModal form');
			saveReviewBtn = $('#reviewModal .modal-footer button').eq(1);

			$(saveReviewBtn).click(function() {
				console.log("saveReviewBtn clicked")

				console.log($(reviewForm).serializeArray());

				

				//ajax 통싱 - post방식으로 추가
				$.ajax({
					type: 'POST',
					url: '/moca/reviews',
					data: $(reviewForm).serializeArray(),
					success: function() {
						console.log('ajax 통신 성공')
						
						
						//리뷰 추가(최상단에)
						
					},
					error: function(error) {
						console.log('ajax 통신 실패', error)
						
					}
				})

			})



			//////////////////////////////////////////////////////////////////////
		/* 	$('#btn-upload').on('click',function(){
				console.log("btn-upload");
				var form = new FormData(document.getElementById('uploadForm'));
				
				$.ajax({
					url : "/moca/pictures",
					data : form,
					dataType : 'text',
					processData : false,
					contentType : false,
					type : "POST",
					success : function(reps){
						console.log('success', reps);
					},
					error : function(jqXHR){
						console.log('error', jqXHR);
					}
					
				})
			}) */

		})

	</script>
	<title>Home</title>
</head>

<body>
	<h1>
		Hello world!
	</h1>
	<!-- 
	<form id="uploadForm" enctype="multipart/form-data" method="POST">
		<label for="file1">file1</label>
		<input type="file" id="file1" name="file" required="required" />
		<label for="file2">file2</label>
		<input type="file" id="file2" name="file" required="required" />
	</form> 
	<button id='btn-upload'>파일 업로드</button>
	<br><br>
	
	
	file upload 연습1
	<form id="uploadForm" enctype="multipart/form-data"> 
	<input type="file" id="fileId" name="file-data"/>
	</form> 
	<button id="btn-upload">file upload</button>
	<br><br> -->

	
	
	
	<!-- Button trigger modal -->
	<button type="button" class="btn btn-primary" data-toggle="modal" id="reviewModalBtn" data-target="#reviewModal">
		리뷰 작성
	</button>
	<!-- Modal -->
	<div class="modal fade" id="reviewModal" tabindex="-1" role="dialog" aria-labelledby="reviewModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="reviewModalLabel">
						<!-- ${storeVo.name} -->에 대한 리뷰</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body" data-role="content">
					<form id="reviewForm">
						<input name="storeId" value=1>
						<div class="form-group">
							<label for="picture-file">사진 선택</label>
							<input type="file" name="pictureUrls" id="picture-file" multiple><!-- 다중으로 입력 하는 방법을 생각해야 할듯 -->
						</div>
						<div class="form-group">
							<label for="review-content">후기</label>
							<textarea class="form-control" name="reviewContent" id="review-content" placeholder="자세한 후기는 다른 고객의 이용에 많은 도움이 됩니다."></textarea>
						</div>
						<div class="form-group">
							<label for="taste-level">맛</label>
							<select id="taste-level" name="tasteLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>
						<div class="form-group">
							<label for="price-level">가격</label>
							<select id="price-level" name="priceLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>
						<div class="form-group">
							<label for="mode-level">분위기</label>
							<select id="mode-level" name="modeLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>
						<div class="form-group">
							<label for="service-level">서비스</label>
							<select id="service-level" name="serviceLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>
						<div class="form-group">
							<label for="convinience-level">편의성</label>
							<select id="convinience-level" name="convinienceLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>

					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary">저장</button>
					<button type="button" class="btn btn-primary">수정</button>
				</div>
			</div>
		</div>
	</div>
</body>

</html>
