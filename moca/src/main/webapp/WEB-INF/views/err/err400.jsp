<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%response.setStatus(200); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap-theme.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/testHeaderCss.css"/>" />
	
<title>페이지를 찾을 수 없습니다</title>
</head>
<body>
	<div class="error_div">
		<div class="row Big-Font">
		  <div >Error Code <span style="color: red">400</span></div>
		  <div >시스템 에러입니다!</div>
		</div>
		<div class="col-md-4" >
			<img id="error404"alt="#" src="/moca/resources/imgs/icons/alert.svg"/>
		</div>
		<div class="col-md-8">
		    <div>
		        <span class="Lar-Font"> 죄송합니다,</span><p class="Nom-Font"> 현재 시스템 오류가 발생했습니다.</p><br>
		        <span >새로고침 단추를 클릭하거나 나중에 다시 시도하시기 바랍니다.</span><br>
		        <span >주소 표시줄에 페이지 주소를 입력하셨다면 올바르게 입력되었는지 확인하시기 바랍니다.</span><br>
		    </div>
	    	<div><a href="<c:url value="/"/>">메인페이지</a></div>
    	</div>
    </div>
</body>
</html>