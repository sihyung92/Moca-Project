<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%response.setStatus(404); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap-theme.css"/>" />
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
        .Sma-Font{
            font-family : "잘난체";
			font-size: 18px;
        }
        .Nom-Font{
            font-family : "잘난체";
			font-size: 27px;
        }
        .Lar-Font{
            font-family : "잘난체";
			font-size: 36px;
        }
	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> 	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- 차트 -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
	<!-- mocaReview -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaReview.js?ver=31"/>"></script>
	<!-- mocaStore -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaStore.js?ver=19"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery.raty.js"/>"></script>
<!-- Latest compiled and minified CSS -->
<title>페이지를 찾을 수 없습니다</title>

</head>
<body>
	<div class="error_div">
	<div class="row Big-Font">
	  <div class="col-md-8">Error Code <span style="color: red">404</span></div>
	  <div class="col-md-8 col-md-offset-1">페이지를 찾을 수 없습니다!</div>
	</div>
	<img alt="#" src="/moca/resources/imgs/404Page_Not_Found.PNG"/>
    <div class="Sma-Font">
        <span class="Lar-Font"> 죄송합니다,</span><span class="Nom-Font"> 요청하신 페이지를 찾을 수 없습니다.</span><br>
        <span class="Sma-Font">찾으시려는 페이지는 주소를 잘못 입력하였거나 페이지 주소의 변경 또는 삭제 등의 이유로 페이지를 찾을 수 없습니다.</span><br>
        <span class="Sma-Font">입력하신 페이지의 주소와 경로가 정확한지 한 번 더 확인 후 이용하시기 바랍니다.</span><br>
    </div>
    </div>
    <div><button>이전페이지</button></div>
</body>
<script type="text/javascript">
</script>
</html>