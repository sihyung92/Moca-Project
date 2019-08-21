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

		})

	</script>
	<title>Home</title>
</head>

<body>
	<h1>
		Hello world!
	</h1>
	<form id="fileUploadForm" enctype="multipart/form-data" method="POST" actino="/moca/uploadImage">
	
		<label for="file1">file1</label>
		<input type="file" id="files" name="files" multiple />
	<!-- 	<input type="text" name="ssn_num" id="ssn_num" > -->
		<input type="submit" value="Submit" id="btnSubmit">
		<!-- <label for="file2">file2</label>
		<input type="file" id="file2" name="file" required="required" /> -->
	</form> 
	<!-- <button id='btn-upload'>파일 업로드</button> -->
	<br><br>
	
	
	<!-- 
	file upload 연습1
	<form id="uploadForm" enctype="multipart/form-data"> 
	<input type="file" id="fileId" name="file-data"/>
	</form> 
	<button id="btn-upload">file upload</button>
	<br><br> -->

	
</body>

</html>
