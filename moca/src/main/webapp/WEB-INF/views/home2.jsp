<%@page import="com.kkssj.moca.model.entity.AccountVo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- naver API -->
    <script type="text/javascript" src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.0.js"></script>
<!-- kakao API -->
    <script type="text/javascript" src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<!-- JQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<!-- bootstrap -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous">
<!-- Optional theme -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap-theme.min.css" integrity="sha384-6pzBo3FDv/PJ8r2KRkGHifhEocL+1X2rVCTTkUfGk7/0pbek5mMa1upzvWbrUbOZ" crossorigin="anonymous">
<!-- Latest compiled and minified JavaScript -->
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js" integrity="sha384-aJ21OjlMXNL5UyIl/XNwTMqvzeRMZH2w8c5cRVpzpU8Y5bApTppSuUkhZXN0VxHd" crossorigin="anonymous"></script>

    <script type='text/javascript'>
    $(document).ready(function(){
    	alert('aaa');
    	var testBtn = $('#test-btn');
    	testBtn.click(function(){
    		 //alert(sessionStorage.getItem("login"));
    		console.log('a?'); 
    		 var loginSession = JSON.parse(sessionStorage.getItem("login"));
    		 
			console.log(sessionStorage.getItem("login"));
			console.log('b?');
    	});
    });
    </script>
</head>
<body>
	<!-- test2 -->
	<h2>helloooooooooooooooooooㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ000000000000000</h2>
	<button id="test-btn">로그인 세션 확인 버튼</button>

</body>
</html>