<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>moca</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.css"/>" />
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap-theme.css"/>" />
<!-- jqm 사용시
 <link rel="stylesheet" type="text/css" href="resources/css/jquery.mobile-1.4.5.css" />
 -->
<style type="text/css">
	.carousel-inner img{
		margin: 0px auto;
	}
</style>
<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"></script>
<!-- jqm 사용시
<script type="text/javascript" src="resources/js/jquery.mobile-1.4.5.js"></script>
-->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
<!-- 차트 -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
<!-- 카카오 로그인 -->
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
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

	//차트
	var ctx = document.getElementById('myChart').getContext('2d');
	var myRadarChart = new Chart(ctx, {
	    type: 'radar',
	    data: {
		    labels: ['맛', '서비스', '분위기', '가격', '편의성'],
		    datasets: [{
		    	//label: '종합 평가',
//		    	backgroundColor: 'rgb(255, 99, 132)',
            	borderColor: 'rgb(255, 99, 132)',
            	pointRadius: 0,
            	lineTension: 0.1,
		        data: [5, 10, 8, 3, 7]
		    }]
		},
		options:{
			legend:{
			  display:false
			},
			scale: {
	            ticks: {
	                suggestedMin: 0,
	                suggestedMax: 10,
	                stepSize: 2
	            }
	        }
		}
	});

	$('#myModal').on('shown.bs.modal', function () {
		  $('#myInput').focus()
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
  		<div class="jumbotron text-center">
  			<!-- 태그 -->
 			 <p><button type="button" class="btn btn-default btn-sm">#뿌릴태그</button><button type="button" class="btn btn-default btn-sm">#뿌릴태그</button></p>
  			<!-- 로고 & 카페이름-->
  			 <h1><img src="<c:url value="/resources/imgs/logo.png"/>" alt="logo" class="img-circle" style="width:100px;">&nbsp;STARBUCKS</h1>
		</div>
  	</div>
  </div>
  <div class="row">
  	<div class="col-md-4 col-md-offset-2">
  		<div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
  <!-- Indicators -->
  <ol class="carousel-indicators">
    <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
    <li data-target="#carousel-example-generic" data-slide-to="1"></li>
    <li data-target="#carousel-example-generic" data-slide-to="2"></li>
  </ol>

  <!-- Wrapper for slides -->
  <!-- 갖고있는 이미지의 개수만큼 -->
  <div class="carousel-inner" role="listbox">
    <div class="item active">
      <img src="<c:url value="/resources/imgs/logo.png"/>" alt="...">
      <div class="carousel-caption">
        ...
      </div>
    </div>
    <div class="item">
      <img src="<c:url value="/resources/imgs/logo.png"/>" alt="...">
      <div class="carousel-caption">
        ...
      </div>
    </div>
  </div>

  <!-- Controls -->
  <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
    <span class="sr-only">Previous</span>
  </a>
  <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
    <span class="sr-only">Next</span>
  </a>
</div>
  	</div>
  	<div class="col-md-4">
  		<canvas id="myChart"></canvas>
  	</div>
  </div>
  <div class="row">
  	<div class="col-md-8 col-md-offset-2">
  		<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingOne">
      <h4 class="panel-title">
        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
          	상세정보
        </a>
      </h4>
    </div>
    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
      <div class="panel-body">
        	와이파이 주차장<br>
        	영업시간 : <br>
        	홈페이지 : <br>
        	<button>#아메리카노가 맛있는</button><button>#호지티 라떼</button>
      </div>
    </div>
  </div>
  </div>
  	</div>
  </div>
  <div class="row">
  	<div class="col-md-8 col-md-offset-2">
  		<div id="map" style="width:100%;height:500px;"></div>
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