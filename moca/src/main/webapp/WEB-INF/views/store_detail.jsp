<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
		.carousel-inner img {
			margin: 0px auto;
		}

		.carousel .carousel-inner img {
			width: 100%;
			height: 20rem;
			object-fit: cover;
			overflow: hidden;
		}

	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> 
	<!-- jqm 사용시 <script type="text/javascript" src="resources/js/jquery.mobile-1.4.5.js"></script>	-->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaReview.js"/>"> </script> 
	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- 차트 -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			//변수 바인딩
			bindReviewVariable();
			

			
			//가져올때부터 수정 모달에 값 세팅
			$('input:radio[name=wifi]:input[value=' + ${storeVo.wifi} + ']').attr("checked", true);
			$('input:radio[name=parkingLot]:input[value=' + ${storeVo.parkingLot} + ']').attr("checked", true);

			var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
				mapOption = {
					center: new kakao.maps.LatLng(${
						storeVo.xLocation
					}, ${
						storeVo.yLocation
					}), // 지도의 중심좌표
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
						content: '<div style="width:150px;text-align:center;padding:6px 0;">${storeVo.name}</div>'
					});
					infowindow.open(map, marker);

					// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
					map.setCenter(coords);
				}
			});


			
			//좋아요 또는 싫어요 버튼 클릭시
			likeHateButton.click(function() {
				//클릭한 버튼의 리뷰에 해당하는 정보를 변수 바인딩
				clickedLikeHateButton = $(this);
				btnGroup = clickedLikeHateButton.parent();
				reviewId = btnGroup.children('.review-id').val();
				likeBtn = btnGroup.children('.like-btn');
				hateBtn = btnGroup.children('.hate-btn');
				likeCount = btnGroup.children('.like-count');
				hateCount = btnGroup.children('.hate-count');

				var isLike;

				//이전 상태 판단
				if (clickedLikeHateButton.hasClass('like-btn')) {
					isLike=1;
					//좋아요 버튼을 눌렀을때 
					if (likeBtn.hasClass('clicked')) {
						//이전에 좋아요 누른 상태 > 좋아요를 누를때 = > 좋아요 취소
						console.log('이전에 좋아요 누른 상태 > 좋아요를 누를때')
						cancelLikeHate(reviewId, isLike);
					} else if (hateBtn.hasClass('clicked')) {
						//이전에 싫어요 누른 상태 > 좋아요를 누를때 = > 싫어요 취소 + 좋아요
						console.log('이전에 싫어요 누른 상태 > 좋아요를 누를때 ')
						changeLikeHate(reviewId, isLike);
					} else {
						//이전에 아무것도 누르지 않은 상태 > 좋아요 누를때 => 좋아요
						console.log('이전에 아무것도 누르지 않은 상태 > 좋아요 누를때 ');
						addLikeHate(reviewId,isLike);
					}


				} else if (clickedLikeHateButton.hasClass('hate-btn')) {
					isLike=-1;
					
					//싫어요 버튼을 눌렀을때 
					if (likeBtn.hasClass('clicked')) {
						//이전에 좋아요 누른 상태 > 싫어요를 누를때 = >좋아요 취소 + 싫어요
						console.log('이전에 좋아요 누른 상태 > 싫어요 누를때 ')
						changeLikeHate(reviewId, isLike);

					} else if (hateBtn.hasClass('clicked')) {
						//이전에 싫어요 누른 상태 > 싫어요를 누를때 = > 싫어요 취소
						console.log('이전에 싫어요 누른 상태 > 싫어요를 누를때 ')
						cancelLikeHate(reviewId, isLike);

					} else {
						//이전에 아무것도 누르지 않은 상태 > 싫어요 누를때 => 싫어요
						console.log('이전에 아무것도 누르지 않은 상태 > 싫어요 누를때 ')
						addLikeHate(reviewId, isLike);
					}
				}
			})


			//차트
			var ctx = document.getElementById('myChart').getContext('2d');
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
				options: {
					legend: {
						display: false
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


			$('#updateStore').click(function() {
				$(this).attr('data-dismiss', "modal");
				updateStore();
			});

			//리뷰 저장 버튼 클릭시
			$(saveReviewBtn).click(function() {
				saveReview();
			})

			//수정 버튼 클릭시
			editBtn.click(function(){
				//리뷰 내용을 리뷰 모달로 옴기고 창 띄움
				reviewData2ReviewModal(this);				
			})
			
			//리뷰 수정 버튼 클릭시
			editReviewBtn.click(function(){
				editReview();
			})

			//삭제 버튼 클릭시
			deleteBtn.click(function(){
				console.log(this,"editBtn clicked");
			})

		});





		function deleteReview() {
			$.ajax({
				url: 'review',
				type: 'delete',
				data: '1', //일단 좋아요를 제거한다고 가정
				success: function() {

				}

			})
		}

		var updateStore = function() {

			var checkTel = $('input[name="tel2"]').val();
			if (checkTel != "") {
				checkTel = $('input[name="tel1"]').val() + "-" + $('input[name="tel2"]').val() + "-" + $('input[name="tel3"]').val()
			};

			//var params=$('#StoreInfoModal form').serializeObject();
			var param = {
				"wifi": $('input[name="wifi"]:checked').val(),
				"parkingLot": $('input[name="parkingLot"]:checked').val(),
				"dayOff": $('input[name="dayOff"]').val(),
				"openTime2": $('input[name="openTime"]').val(),
				"endTime2": $('input[name="endTime"]').val(),
				"tel": checkTel,
				"url": $('input[name="url"]').val()
			};
			console.log(param);

			//카페 상세정보 수정
			$.ajax({
				type: 'put',
				url: ${
					storeVo.store_Id
				},
				contentType: "application/json; charset=UTF-8",
				datatype: "json",
				data: JSON.stringify(param),
				error: function(errorMsg) {
					console.log("카페상세정보 수정실패", errorMsg);
				},
				success: function(data) {
					console.log("카페상세정보 수정성공");
					//카페 정보 바꿔주기
					if (param.wifi == '0') {
						$('#wifiInfo').html('없음');
					} else if (param.wifi == '1') {
						$('#wifiInfo').html('있음');
					} else if (param.wifi == '-1') {
						$('#wifiInfo').html('');
					}

					if (param.parkingLot == '0') {
						$('#parkingLotInfo').html('없음');
					} else if (param.parkingLot == '1') {
						$('#parkingLotInfo').html('있음');
					} else if (param.parkingLot == '-1') {
						$('#parkingLotInfo').html('');
					}

					$('#dayOffInfo').html(param.dayOff);
					var dash = ' - ';
					if (param.endTime2 == '') {
						dash = '';
					};
					$('#TimeInfo').html(param.openTime2 + dash + param.endTime2);
					$('#telInfo').html(param.tel);
					$('#urlInfo').html(param.url);
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
								<c:if test="${tag ne ''}">
									<button type="button" class="btn btn-default btn-sm">#${tag}</button>
								</c:if>
							</c:forEach>
						</p>
						<!-- 로고 & 카페이름-->
						<!-- 이미지 호스팅 할 건지, 데이터 베이스에 넣을건지 -->
						<h1>
							<c:if test="${empty storeVo.logoImg}">
								<img src="<c:url value="/resources/imgs/logoDefault.png"/>" alt="logo" class="img-circle" style="width:100px;">
							</c:if>
							<c:if test="${not empty storeVo.logoImg}">
								<img src="<c:url value="${storeVo.logoImg }" />" alt="logo" class="img-circle" style="width:100px;">
							</c:if>
							&nbsp;${storeVo.name}
						</h1>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-4 col-md-offset-2">
					<!-- 갖고있는 이미지의 개수만큼  캐러셀 시작-->
					<div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
						<!-- Indicators -->
						<ol class="carousel-indicators">
							<c:set var="reviewImgs" value="${fn:split(storeVo.reviewImg,',')}" />
							<c:forEach items="${reviewImgs}" var="reviewImg" varStatus="status">
								<c:if test="${status.index eq 0}">
									<li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
								</c:if>
								<c:if test="${status.index ne 0}">
									<li data-target="#carousel-example-generic" data-slide-to="${status.index }"></li>
								</c:if>
							</c:forEach>
						</ol>

						<!-- Wrapper for slides -->
						<div id="carouselExampleControls" class="carousel slide" data-ride="carousel">
							<div class="carousel-inner" role="listbox">
								<c:if test="${not empty storeVo.reviewImg}">
									<c:forEach items="${reviewImgs}" var="reviewImg" varStatus="status">
										<c:if test="${status.index eq 0}">
											<div class="item active">
										</c:if>
										<c:if test="${status.index ne 0}">
											<div class="item">
										</c:if>
										<img src="<c:url value="${reviewImg }" />" alt="..." class="d-block w-100">
										<div class="carousel-caption">...</div>
							</div>
							</c:forEach>
							</c:if>
							<c:if test="${empty storeVo.reviewImg}">
								<img src="<c:url value="/resources/imgs/reviewDefault.png"/>" alt="..." class="d-block w-100">
							</c:if>
						</div>

						<!-- Controls -->
						<a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev"> <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
							<span class="sr-only">Previous</span>
						</a> <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
							<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span> <span class="sr-only">Next</span>
						</a>
					</div>
				</div>
				<!-- 갖고있는 이미지의 개수만큼  캐러셀 끝-->
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
								<span id="wifiInfo">
									<c:if test="${storeVo.wifi eq 0}">없음</c:if>
									<c:if test="${storeVo.wifi eq 1}">있음</c:if>
								</span>
								<br>
								주차장 :
								<span id="parkingLotInfo">
									<c:if test="${storeVo.parkingLot eq 0}">없음</c:if>
									<c:if test="${storeVo.parkingLot eq 1}">있음</c:if>
								</span>
								<br>
								휴무일 : <span id="dayOffInfo">${storeVo.dayOff}</span><br>
								영업시간 :
								<span id="TimeInfo">
									${fn:substring(storeVo.openTime,11,16)} <c:if test="${not empty storeVo.endTime}">
										<c:out value="-"></c:out>
									</c:if> ${fn:substring(storeVo.endTime,11,16)}
								</span>
								<br>
								전화번호 :
								<span id="telInfo">
									${storeVo.tel}
								</span>
								<br>
								홈페이지 :
								<span id="urlInfo">
									<a href="${storeVo.url}">${storeVo.url}</a>
								</span>
								<br>
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
					<button type="button" class="btn btn-primary" data-toggle="modal" id="reviewModalBtn" data-target="#reviewModal">
						리뷰 작성
					</button>
					<br><br>
				</div>
				<div class="review-content">
					<!-- js로 리뷰 수만큼 추가 할 것  -->
					<c:forEach items="${reviewVoList }" var="reviewVo">
						<div class="row">
							<!-- isMine 에 따라 표시(일단 다 표시)
							-->
							<div class="editDeleteGroup btn-group" role="group">
								<input type="number" class="review-id" value=${reviewVo.review_id } style="display: none;">
								<button type="button" class="btn-edit btn btn-default">수정</button>
								<button type="button" class="btn-delete btn btn-default">삭제</button>
							</div>
							<div class="reviewer-info col-md-2">
								<div class="nickName-div">
									<label>별명</label>	
									<span class="reviewer-nickName">${reviewVo.nickName} </span>
								</div>
								<div class="follows-div">
									<label>팔로워 수</label>
									<span class="reviewer-followers">${reviewVo.followCount}</span>
								</div>
								<div class="reviews-div">
									<label>리뷰 수</label>
									<span class="reviewer-reviews">${reviewVo.reviewCount}</span>
								</div>
							</div>


							<div class="review-info col-md-8">

								<div id="carousel-example-generic${reviewVo.review_id}" class="carousel slide" data-ride="carousel">

									<!-- Wrapper for slides -->
									<div class="carousel-inner" role="listbox">
										<div class="item active">
											<img src="<c:url value="/resources/imgs/store1.jpg"/>" alt="store1">
										</div>
										<div class="item">
											<img src="<c:url value="/resources/imgs/store1.jpg"/>" alt="store2">
										</div>
										<div class="item">
											<img src="<c:url value="/resources/imgs/store1.jpg"/>" alt="store3">
										</div>
									</div>

									<!-- Controls -->
									<a class="left carousel-control" href="#carousel-example-generic${reviewVo.review_id}" role="button" data-slide="prev">
										<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
										<span class="sr-only">Previous</span>
									</a>
									<a class="right carousel-control" href="#carousel-example-generic${reviewVo.review_id}" role="button" data-slide="next">
										<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
										<span class="sr-only">Next</span>
									</a>
								</div>

								<div class="write-date-div">
									<label>작성일</label>
									<span class="reviewInfo-write-date">${reviewVo.writeDate }</span>
								</div>
								<div class="review-content-div">
									<label>리뷰 내용</label>
									<span class="reviewInfo-review-content">${reviewVo.reviewContent }</span>
								</div>
								<div class="form-group like-hate">
									<div class="btn-group" data-toggle="buttons">
										<input type="number" class="review-id" value=${reviewVo.review_id } style="display: none;">
										<c:choose>
											<c:when test="${reviewVo.isLike==1 }"><button type="button" class="btn btn-primary like-btn clicked">좋아요</button></c:when>
											<c:otherwise><button type="button" class="btn btn-primary like-btn ">좋아요</button></c:otherwise>
										</c:choose>
										<input type="number" class="like-count" value=${reviewVo.likeCount }>
										<c:choose>
											<c:when test="${reviewVo.isLike==-1 }"><button type="button" class="btn btn-primary hate-btn clicked">싫어요</button></c:when>
											<c:otherwise><button type="button" class="btn btn-primary hate-btn">싫어요</button></c:otherwise>
										</c:choose>

										<input type="number" class="hate-count" value=${reviewVo.hateCount }>
									</div>
								</div>
							</div>

							<div class="review-level col-md-2">
								<div class="taste-level-div">
									<label>맛</label>
									<span class="taste-level">${reviewVo.tasteLevel }</span>점
								</div><br>
								<div class="price-level-div">
									<label>가격</label>
									<span class="price-level">${reviewVo.priceLevel }</span>점
								</div><br>
								<div class="service-level-div">
									<label>서비스</label>
									<span class="service-level">${reviewVo.serviceLevel }</span>점
								</div><br>
								<div class="taste-level-div">
									<label>분위기</label>
									<span class="mood-level">${reviewVo.moodLevel }</span>점
								</div><br>
								<div class="taste-level-div">
									<label>편의성</label>
									<span class="convenience-level">${reviewVo.convenienceLevel }</span>점
								</div>
								<div class="taste-level-div">
									<label for="average_level">평균</label>
									<span class="average-level">${reviewVo.averageLevel }</span>점
								</div>								
							</div>
							<br><br><br>
						</div>
					</c:forEach>

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
	
	<!-- clone할 review element -->
	<div class="row"  id="reviewTemplate" style="display : none;">
		<div class="editDeleteGroup btn-group" role="group">
			<input type="number" style="display: none;" class="review-id" value=${reviewVo.review_id } >
			<button type="button" class="btn-edit btn btn-default">수정</button>
			<button type="button" class="btn-delete btn btn-default">삭제</button>
		</div>
		<div class="reviewer-info col-md-2">
			<div class="nickName-div">
				<label>별명</label>	
				<span class="reviewer-nickName">${reviewVo.nickName} </span>
			</div>
			<div class="follows-div">
				<label>팔로워 수</label>
				<span class="reviewer-followers">${reviewVo.followCount}</span>
			</div>
			<div class="reviews-div">
				<label>리뷰 수</label>
				<span class="reviewer-reviews">${reviewVo.reviewCount}</span>
			</div>
		</div>
		<div class="review-info col-md-8">

			<div id="carousel-example-generic" class="carousel slide" data-ride="carousel">


				<!-- Wrapper for slides -->
				<div class="carousel-inner" role="listbox">
					<div class="item active">
						<img src="<c:url value="/resources/imgs/store1.jpg"/>" alt="store1">
					</div>
					<div class="item">
						<img src="<c:url value="/resources/imgs/store1.jpg"/>" alt="store2">
					</div>
					<div class="item">
						<img src="<c:url value="/resources/imgs/store1.jpg"/>" alt="store3">
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

			<div class="write-date-div">
				<label>작성일</label>
				<span class="reviewInfo-write-date">${reviewVo.writeDate }</span>
			</div>
			<div class="review-content-div">
				<label>리뷰 내용</label>
				<span class="reviewInfo-review-content">${reviewVo.reviewContent }</span>
			</div>
			<div class="form-group like-hate">
				<div class="btn-group" data-toggle="buttons">
					<input type="number" class="review-id" style="display: none;">
					<button type="button" class="btn btn-primary like-btn ">좋아요</button>
					<input type="number" class="like-count" value=0 >
					<button type="button" class="btn btn-primary hate-btn">싫어요</button>
					<input type="number" class="hate-count" value=0>
				</div>
			</div>
		</div>

		<div class="review-level col-md-2">
			<div class="taste-level-div">
				<label>맛</label>
				<span class="taste-level">${reviewVo.tasteLevel }</span>점
			</div><br>
			<div class="price-level-div">
				<label>가격</label>
				<span class="price-level">${reviewVo.priceLevel }</span>점
			</div><br>
			<div class="service-level-div">
				<label>서비스</label>
				<span class="service-level">${reviewVo.serviceLevel }</span>점
			</div><br>
			<div class="taste-level-div">
				<label>분위기</label>
				<span class="mood-level">${reviewVo.moodLevel }</span>점
			</div><br>
			<div class="taste-level-div">
				<label>편의성</label>
				<span class="convenience-level">${reviewVo.convenienceLevel }</span>점
			</div>
			<div class="taste-level-div">
				<label for="average_level">평균</label>
				<span class="average-level">${reviewVo.averageLevel }</span >점
			</div>								
		</div>
		<br><br><br>
	</div>
	
	
	<!-- Modal -->
	<div class="modal fade" id="reviewModal" tabindex="-1" role="dialog" aria-labelledby="reviewModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="reviewModalLabel">
						${storeVo.name}에 대한 리뷰</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body" data-role="content">
					<form id="reviewForm">
						<input name="storeId" value=${storeVo.store_Id} style="display:none;" >
						<input name="review_id" id="review_id" value="0" style="display:none;" >
						<div class="form-group">
							<label for="picture-file">사진 선택</label>
							<input type="file" name="pictureUrls" id="picture-file" multiple><!-- 다중으로 입력 하는 방법을 생각해야 할듯 -->
						</div>
						<div class="form-group">
							<label for="review-content">후기</label>
							<textarea class="form-control" name="reviewContent" id="review-content" placeholder="자세한 후기는 다른 고객의 이용에 많은 도움이 됩니다."></textarea>
						</div>
						<div class="form-group">
							<label for="taste-level">맛</label>
							<select id="taste-level" name="tasteLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>
						<div class="form-group">
							<label for="price-level">가격</label>
							<select id="price-level" name="priceLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>	
						<div class="form-group">
							<label for="service-level">서비스</label>
							<select id="service-level" name="serviceLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>
						<div class="form-group">
							<label for="mood-level">분위기</label>
							<select id="mood-level" name="moodLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>
						<div class="form-group">
							<label for="convenience-level">편의성</label>
							<select id="convenience-level" name="convenienceLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>

					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" id="saveReviewBtn">작성</button>
					<button type="button" class="btn btn-primary" id="editReviewBtn">수정</button>
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
						<div class="form-group">
							<label for="wifi" class="col-sm-2 control-label">와이파이</label>
							<div class="col-sm-10">
								<input type="radio" name="wifi" id="wifiOption1" value="1"> 있음
								<input type="radio" name="wifi" id="wifiOption2" value="0"> 없음
								<input type="radio" name="wifi" id="wifiOption3" value="-1" checked> 모름
							</div>
						</div>
						<div class="form-group">
							<label for="parkingLot" class="col-sm-2 control-label">주차장</label>
							<div class="col-sm-10">
								<input type="radio" name="parkingLot" id="parkingLotOption1" value="1"> 있음
								<input type="radio" name="parkingLot" id="parkingLotOption2" value="0"> 없음
								<input type="radio" name="parkingLot" id="parkingLotOption3" value="-1" checked> 모름
							</div>
						</div>
						<div class="form-group">
							<label for="dayOff" class="col-sm-2 control-label">휴무일</label>
							<div class="col-sm-10">
								<input type="text" id="dayOff" name="dayOff" value="${storeVo.dayOff}">
							</div>
						</div>
						<div class="form-group">
							<label for="openTime" class="col-sm-2 control-label">영업시간</label>
							<div class="col-sm-10">
								<input type="time" id="openTime" name="openTime" value="${fn:substring(storeVo.openTime,11,16)}"> - <input type="time" id="endTime" name="endTime" value="${fn:substring(storeVo.endTime,11,16)}">
							</div>
						</div>
						<div class="form-group">
							<label for="tel" class="col-sm-2 control-label">전화번호</label>
							<div class="col-sm-10">
								<input type="text" name="tel1" size="3" maxlength="3" pattern="[0-9]{3}" value="${fn:substring(storeVo.tel,0,3)}" />
								-
								<input type="text" name="tel2" size="4" maxlength="4" pattern="[0-9]{4}" value="${fn:substring(storeVo.tel,4,8)}" />
								-
								<input type="text" name="tel3" size="4" maxlength="4" pattern="[0-9]{4}" value="${fn:substring(storeVo.tel,9,13)}" />
							</div>
						</div>
						<div class="form-group">
							<label for="url" class="col-sm-2 control-label">홈페이지</label>
							<div class="col-sm-10">
								<input type="url" id="url" name="url" pattern="https?://.+" value="${storeVo.url }">
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
