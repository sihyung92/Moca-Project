<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%response.setStatus(404); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap-theme.min.css" integrity="sha384-6pzBo3FDv/PJ8r2KRkGHifhEocL+1X2rVCTTkUfGk7/0pbek5mMa1upzvWbrUbOZ" crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>

<title>페이지를 찾을 수 없습니다</title>
<style type="text/css">
	@font-face {
	font-family:"잘난체";
	src:url("/moca/resources/fonts/Jalnan.ttf");
	}
	body img{
		display : block;
		margin: 50px auto;
	}
	.Big-Font{
		font-family : "잘난체";
		font-size: 60px;
	}
	.Mid-Font{
		font-family : "잘난체";
		font-size: 44px;
	}
</style>
</head>
<body>
	<div id="header">
		<jsp:include page="/resources/template/header.jsp" flush="true"></jsp:include>
	</div>
	<div class="row Big-Font">
	  <div class="col-md-8">Error Code <span style="color: red">404</span></div>
	</div>
	<div class="row Mid-Font">
	  <div class="col-md-8 col-md-offset-1">페이지를 찾을 수 없습니다!</div>
	</div>
	<img alt="#" src="/moca/resources/imgs/404Page_Not_Found.PNG"/>

</body>
</html>