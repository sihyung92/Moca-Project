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

	<style type="text/css">
		.fileDrop{
			width: 600px;
			height : 200px;
			border: 1px dotted blue;
		}
		
		small{
			margin-left :3px;
			font-weight : bold;
			color : gray;
		}
	</style>
	<script type="text/javascript">
	$(document).ready(function(){

		$('.fileDrop').on("dragenter dragover", function(event){
			event.preventDefault(); //기본 효과 제거
		});

		$('.fileDrop').on("drop", function(event){
			event.preventDefault(); //기본 효과 제거

			//드레그된 파일의 정보
			var files = event.originalEvent.dataTransfer.files;
			var file = files[0];

			console.log(file);

			//ajax로 전달할 폼 객체
			var formData = new FormData();

			console.log(formData);

			//form 객체에 파일 추가 append("변수명", 값)
			formData.append("file", file);

			$.ajax({
				type: "post",
				url : "/moca/uploadAjax",
				data : formData,
				dataType : "text",
				processData : false,
				contentType : false,
				success: function(data){
					console.log(data)
				}
			})
			
		})

		$('#saveReviewBtn').on("click", function(event){
			console.log(event, this)
			var form = $('#reviewForm')[0];

			var reviewFormData = new FormData(form);

			$.ajax({
				type:"POST",
				enctype : 'multipart/form-data',
				url : "/moca/uploadAjax",
				data : reviewFormData,
				contentType : false,
				processData : false,
				cache : false,
				timeout : 600000,
				success : function(data){
					console.log("업로드 성공",data);
					
				},
				error : function(err){
					console.log("업로드 실패", err)
				}
			})
			
			
		})


		
		
		
	});


	</script>
	<title>Home</title>
</head>

<body>
	<h1>file 페이지</h1>
	
	<!-- 파일을 업로드할 영역 -->
	<div class="fileDrop"></div>
	
	
	<!-- 업로드된 파일 목록 -->
	<div class="uploadList"></div>
	
	
	<br><br>
	<form id="reviewForm" method="post" enctype="multipart/form-data">
		<input name="storeId" value="1" style="display:none;" >
		<input name="review_id" id="review_id" value="0" style="display:none;" >
		<div class="form-group">
			<label for="picture-file">사진 선택</label>
			<input type="file" name="file" id="picture-file" multiple="multiple"><!-- 다중으로 입력 하는 방법을 생각해야 할듯 -->
		</div>
		<!-- 
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
			<label for="mood-level">분위기</label>
			<select id="mood-level" name="moodLevel" class="form-control">
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
			<label for="convenience-level">편의성</label>
			<select id="convenience-level" name="convenienceLevel" class="form-control">
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
		 -->
	
	</form>
	<div class="modal-footer">
		<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
		<button type="button" class="btn btn-primary" id="saveReviewBtn">작성</button>
		<button type="button" class="btn btn-primary" id="editReviewBtn">수정</button>
	</div>
</body>

</html>
