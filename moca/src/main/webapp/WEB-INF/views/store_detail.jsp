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


		////////////리뷰//////////////////
		//리뷰 받아오기
		$.ajax({
			type:"GET",
			url:"reviews/1",
			datatype: "json",
			error : function(errorMsg){
				console.log("리뷰 받아오기 실패",errorMsg);
			},
			success: function(reviewsJson){
				console.log("리뷰 받아오기 성공", reviewJson);

				//리뷰 데이터 띄우기
				displayReviews(reviewsJson);
			}
		})		   
	});

	//리뷰 데이터 띄우기
	function displayReviews(json){
		
	}
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
	
</body>
</html>