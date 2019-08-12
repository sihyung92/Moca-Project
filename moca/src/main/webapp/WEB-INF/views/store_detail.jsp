<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
	        //center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
	        center: new kakao.maps.LatLng(${storeVo.xLocation}, ${storeVo.yLocation}), // 지도의 중심좌표
	        level: 3 // 지도의 확대 레벨
	    };  
	// 지도를 생성합니다    
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();
	// 주소로 좌표를 검색합니다
	geocoder.addressSearch('${storeVo.address}', function(result, status) {
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
	            content: '<div style="width:100%;text-align:center;padding:6px 0;">${storeVo.name}</div>'
	        });
	        infowindow.open(map, marker);
	        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
	        map.setCenter(coords);
	    } 
	});
	//차트
	var ctx = document.getElementById('myChart').getContext('2d');
	//맛,서비스,분위기,가격,편의성 레벨 변수로 저장
	var labelVal = [${storeVo.tasteLevel}, ${storeVo.serviceLevel}, ${storeVo.moodLevel}, ${storeVo.priceLevel}, ${storeVo.convenienceLevel}];
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
		        data: labelVal
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

	$('#updateStore').click(function(){
		updateStore();
	});
	
});

	var updateStore = function(){


		var params=$('#StoreInfoModal form').serialize();
		/*
		$.post(${storeVo.store_Id},params,function(){
			console.log("카페상세정보 수정성공");
		});
		*/
		var data={store_Id:12};
		//카페 상세정보 수정
		//put -> 수정
		$.ajax({
			type:'put',
			url:${storeVo.store_Id},
			//contentType:"application/json; charset=UTF-8",
			//datatype: "json",
			data: params,
			error : function(errorMsg){
				console.log("카페상세정보 수정실패",errorMsg);
			},
			success: function(data){
				console.log("카페상세정보 수정성공");
			}
		});
	};
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
  		<c:set var="tags" value="${fn:split(storeVo.tag,'#')}" />
  			<p>  		
  		<c:forEach items="${tags}" var="tag">
  				<button type="button" class="btn btn-default btn-sm">#${tag}</button>
  		</c:forEach>
  			</p>
  		<!-- 로고 & 카페이름-->
  		<!-- 이미지 호스팅 할 건지, 데이터 베이스에 넣을건지 -->
  			<h1><img src="<c:url value="/resources/imgs/logo.png"/>" alt="logo" class="img-circle" style="width:100px;">&nbsp;${storeVo.name}</h1>
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
  <br>
  	<div class="col-md-8 col-md-offset-2">
  		<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="headingOne">
      <h4 class="panel-title">
        <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
          &#9432; 상세정보 
        </a>
      </h4>
    </div>
    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
      <div class="panel-body">
        	와이파이 : 
        	<c:if test="${storeVo.wifi eq 0}">없음</c:if>
        	<c:if test="${storeVo.wifi eq 1}">있음</c:if>
        	<br>
        	주차장 : 
        	<c:if test="${storeVo.parkingLot eq 0}">없음</c:if>
        	<c:if test="${storeVo.parkingLot eq 1}">있음</c:if>
        	<br>
        	휴무일 : ${storeVo.dayOff}<br>
        	영업시간 : ${fn:substring(storeVo.openTime,0,5)} - ${fn:substring(storeVo.endTime,0,5)}<br>
        	홈페이지 : <a href="${storeVo.url}">${storeVo.url}</a><br>
        	<hr>
        	<button type="button" class="btn btn-default btn-sm" data-toggle="modal" data-target="#StoreInfoModal">
			  정보제공
			</button>
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
  		<div class="review-header">
  			<h1>리뷰들</h1>
  			<!-- Button trigger modal -->
			<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal">
			  리뷰 작성
			</button>
  		</div>
  		<div class="review-content">
 			<!-- js로 리뷰 수만큼 추가 할 것  -->	
  			<div class="row">
 				<div class="reviewer-info col-md-2" >
				  	<label for="nick-name">$(닉네임 )</label>
				  	<label for="follow-count">$(팔로워 수 )</label>
				  	<label for="review-count">$(리뷰 수 )</label>
				</div>
		
		
				<div class="review-info col-md-8">
				  	<label for="write-date">$(작성일 )</label>
				  	<label for="review-content">$(리뷰 내용 )</label>
				  	<label for="like_count">$(좋아요 수 )</label>
				  	<label for="hate_count">$(싫어요 수 )</label>
				</div>
		
				<div class="review-level col-md-2">
					<label for="taste_level">$(맛 점수 )</label>
					<label for="price_level">$(가격 점수 )</label>
					<label for="service_level">$(서비스 점수 )</label>
					<label for="mode_level">$(분위기 점수 )</label>
					<label for="convenient_level">$(편의성 점수 )</label>
					<label for="average_level">$(평균 점수 )</label>
				</div>	
			</div>
  		</div>
  		<div class="review-footer">
  			<a href="#">더보기</a>
  		</div>
  		
  	</div>
  </div>
</div>
</div>
<div id="footer">
	<jsp:include page="../../resources/template/footer.jsp" flush="true"></jsp:include>
</div>
<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">$(상호 명)에 대한 리뷰</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" data-role="content">
        <form> 
		  <div class="form-group reviewer-info" style="display: none;">
		  	<label for="nick-name">$(닉네임 )</label>
		  	<label for="nick-name">$(팔로워 수 )</label>
		  	<label for="nick-name">$(리뷰 수 )</label>
		  	<label for="nick-name">$(좋아요 수 )</label>
		  	<label for="nick-name">$(싫어요) 수 )</label>
		  </div>
		  <div class="form-group">
		    <label for="review-content">내용</label>
		    <textarea class="form-control" id="review-content" placeholder="리뷰내용을 입력해 주세요"></textarea>
		  </div>
		  <div class="form-group" >
		    <label for="taste-level">맛</label>
		    <input type="range" min="0" max="5" id="taste-level">
		  </div>
		  <div class="form-group" >
		    <label for="price-level">가격</label>
		    <input type="range" min="0" max="5" id="price-level">
		  </div>
		  <div class="form-group" >
		    <label for="mode-level">분위기</label>
		    <input type="range" min="0" max="5" id="mode-level">
		  </div>
		  <div class="form-group" >
		    <label for="service-level">서비스</label>
		    <input type="range" min="0" max="5" id="service-level">
		  </div>
		  <div class="form-group" >
		    <label for="convinient-level">편의성</label>
		    <input type="range" min="0" max="5" id="convinient-level">
		  </div>		  
		  <div class="form-group">
		    <label for="picture-file">사진 선택</label>
		    <input type="file" id="picture-file"><!-- 다중으로 입력 하는 방법을 생각해야 할듯 -->
		  </div>
		  <div class="form-group like-hate" >
		    <div class="btn-group" data-toggle="buttons">
			  <label class="btn btn-primary">
			    좋아요<input type="radio" name="options" id="option2">
			  </label>
			  <input type="number" id="like-count" value=1>
			  <label class="btn btn-primary">
			    싫어요<input type="radio" name="options" id="option3">
			  </label>
			  <input type="number" id="hate-count" value=1>
			</div>
		  </div>
		</form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>
<!-- 리뷰작성 모달 끝-->
<!-- store 정보 수정 모달 시작  -->
<div class="modal fade" id="StoreInfoModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h3 class="modal-title" id="exampleModalLabel">${storeVo.name}</h3>
      </div>
      <div class="modal-body" data-role="content">
        <form class="form-horizontal">
		  <div class="form-group reviewer-info" style="display: none;">
		  	<label for="nick-name">와이파이</label>
		  	<label for="nick-name">주차장</label>
		  	<label for="nick-name">휴무일</label>
		  	<label for="nick-name">영업시간</label>
		  	<label for="nick-name">홈페이지</label>
		  </div>
		  <div class="form-group" >
		    <label for="wifi" class="col-sm-2 control-label">와이파이</label>
		    <div class="col-sm-10">
		    <input type="radio" name="wifi" id="wifiOption1" value="1"> 있음
		    <input type="radio" name="wifi" id="wifiOption2" value="0"> 없음
		    <input type="radio" name="wifi" id="wifiOption3" value="-1" checked> 모름
		    </div>
		  </div>
		  <div class="form-group" >
		    <label for="parkingLot" class="col-sm-2 control-label">주차장</label>
		    <div class="col-sm-10">
		    <input type="radio" name="parkingLot" id="parkingLotOption1" value="1"> 있음
		    <input type="radio" name="parkingLot" id="parkingLotOption2" value="0"> 없음
		    <input type="radio" name="parkingLot" id="parkingLotOption3" value="-1" checked> 모름
		    </div>
		  </div>
		  <div class="form-group" >
		    <label for="dayOff" class="col-sm-2 control-label">휴무일</label>
		    <div class="col-sm-10">
		    <input type="text" id="dayOff" name="dayOff">
		    </div>
		  </div>
		  <div class="form-group" >
		    <label for="openTime" class="col-sm-2 control-label">영업시간</label>
		    <div class="col-sm-10">
		    <!-- 
		     <input type="text" id="openTime" name="openTime"> - <input type="text" id="endTime" name="endTime">
		     -->
		    </div>
		  </div>
		  <div class="form-group" >
		    <label for="url" class="col-sm-2 control-label">홈페이지</label>
		    <div class="col-sm-10">
		    <input type="url" id="url" name="url">
		    </div>
		  </div>
		</form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" id="updateStore">입력</button>
      </div>
    </div>
  </div>
</div>
<!-- store 정보 수정 모달 끝 -->
</body>
</html>