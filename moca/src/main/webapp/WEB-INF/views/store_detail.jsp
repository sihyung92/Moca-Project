<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>moca</title>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.css" />
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.css" />
<!-- jqm 사용시
 <link rel="stylesheet" type="text/css" href="resources/css/jquery.mobile-1.4.5.css" />
 -->
<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
<!-- jqm 사용시
<script type="text/javascript" src="resources/js/jquery.mobile-1.4.5.js"></script>
-->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	    mapOption = {
	        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };  

	// 지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 

	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();

	// 주소로 좌표를 검색합니다
	geocoder.addressSearch('제주특별자치도 제주시 첨단로 242', function(result, status) {

	    // 정상적으로 검색이 완료됐으면 
	     if (status === kakao.maps.services.Status.OK) {

	        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

	        // 결과값으로 받은 위치를 마커로 표시합니다
	        var marker = new kakao.maps.Marker({
	            map: map,
	            position: coords
	        });

	        // 인포윈도우로 장소에 대한 설명을 표시합니다
	        var infowindow = new kakao.maps.InfoWindow({
	            content: '<div style="width:150px;text-align:center;padding:6px 0;">카페이름</div>'
	        });
	        infowindow.open(map, marker);

	        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
	        map.setCenter(coords);
	    } 
	});    
	});
</script>
</head>
<body>
<!-- 그리드 시스템으로 만들것 -->
<div id="header">
	<jsp:include page="../../resources/template/header.jsp" flush="true"></jsp:include>
</div>
<div id="content">
<div class="container-fluid">
  <div class="row">
  	<div class="col-md-8 col-md-offset-2">
  		<div class="jumbotron">
  			<!-- 태그 -->
 			 <p style="margin: 0px auto;">#뿌릴태그 #뿌릴태그 </p>
  			<!-- 로고 & 카페이름-->
  			 <h1><img src="resources/imgs/logo.png" alt="logo" class="img-circle">&nbsp;STARBUCKS</h1>
		</div>
  	</div>
  </div>
  <div class="row">
  	<div class="col-md-4 col-md-offset-2">
  		<h1>리뷰사진 캐러셀</h1>
  	</div>
  	<div class="col-md-4">
  		<h1>그래프</h1>
  	</div>
  </div>
  <div class="row">
  	<div class="col-md-8 col-md-offset-2">
  		<h1>정보</h1>
  	</div>
  </div>
  <div class="row">
  	<div class="col-md-8 col-md-offset-2">
  		<div id="map" style="width:500px;height:400px;"></div>
  	</div>
  </div>
  <div class="row">
  	<div class="col-md-8 col-md-offset-2">
  		<h1>리뷰들</h1>
  	</div>
  </div>
</div>
</div>
<div id="footer">
	<jsp:include page="../../resources/template/footer.jsp" flush="true"></jsp:include>
</div>
	
</body>
</html>