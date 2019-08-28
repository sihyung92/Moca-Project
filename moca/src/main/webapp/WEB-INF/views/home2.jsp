<%-- 사용 X --%>

<%-- <%@page import="com.kkssj.moca.model.entity.AccountVo"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
<title>Custom Login Demo - Kakao JavaScript SDK</title>
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
  //<![CDATA[
    // 사용할 앱의 JavaScript 키를 설정해 주세요.
    $(document).ready(function(){
    	Kakao.init('e85bc4677809dd977652da6eeaac836f');
    	$('#moca-logout').click(kakaoLogout);
    });
    
    function kakaoLogout(){

    	$.ajax({
					type: 'post',
					url: 'logout',
					contentType: "application/json; charset=UTF-8",
					//datatype: "json",
					//data: JSON.stringify(param),
					error: function(errorMsg) {
						alert('이미 로그아웃되어 있습니다.');

				   		Kakao.Auth.logout();
						redirToHome();
					},
					success: function(fromServer) {
						
				   		Kakao.Auth.logout();
						redirToHome();
					}
				});
    }
    
    function redirToHome(){
		  location.replace("http://localhost:8080/moca/home2")
	}
  //]]>
</script>

</head>
<body>
<a id="custom-login-btn" href="javascript:loginWithKakao()">
<img src="//mud-kage.kakao.com/14/dn/btqbjxsO6vP/KPiGpdnsubSq3a0PHEGUK1/o.jpg" width="300"/>
</a>
<h1>입니다.</h1>
<button id="moca-logout">logout</button>

<c:if test="${sessionScope.login != 'NULL_VAL' }">
	<h1>내용 있음?</h1>
</c:if>
<c:if test="${sessionScope.login == 'NULL_VAL' }">
	<h1>내용 없음?</h1>
</c:if>

















</body>
</html> --%>