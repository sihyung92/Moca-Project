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
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> <script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> <!-- jqm 사용시 <script type="text/javascript" src="resources/js/jquery.mobile-1.4.5.js"></script>
	-->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- 차트 -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
	<script type="text/javascript">
		var likeHateButton;
		var btnGroup;
		var likeHateCount;
		var reviewId;
		var clickedLikeHateButton;
		var likeBtn;
		var hateBtn;
		var likeCount;
		var hateCount;

		$(document).ready(function() {
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


			likeHateButton = $('.like-hate>.btn-group>button')

			likeHateButton.click(function() {
				clickedLikeHateButton = $(this);
				btnGroup = clickedLikeHateButton.parent();
				reviewId = btnGroup.children('.review-id').val();
				likeBtn = btnGroup.children('.like-btn');
				hateBtn = btnGroup.children('.hate-btn');
				likeCount = btnGroup.children('.like-count');
				hateCount = btnGroup.children('.hate-count');


				//이전 상태 판단
				if (clickedLikeHateButton.hasClass('like-btn')) {
					//좋아요 버튼을 눌렀을때 
					if (likeBtn.hasClass('clicked')) {
						//이전에 좋아요 누른 상태 > 좋아요를 누를때 = > 좋아요 취소
						console.log('이전에 좋아요 누른 상태 > 좋아요를 누를때')

						//ajax 통신 - delete 방식으로 삭제
						$.ajax({
							type: 'DELETE',
							url: '/moca/likeHates/' + reviewId,
							data: {
								"isLike": 1
							},
							success: function() {
								console.log('ajax 통신 성공 - 좋아요 취소')
								likeBtn.removeClass('clicked')
								likeCount.val(Number(likeCount.val()) - 1);
							},
							error: function() {
								console.log('ajax 통신 실패')
								alert("좋아요 취소 실패")
							}

						})





					} else if (hateBtn.hasClass('clicked')) {
						//이전에 싫어요 누른 상태 > 좋아요를 누를때 = > 싫어요 취소 + 좋아요
						console.log('이전에 싫어요 누른 상태 > 좋아요를 누를때 ')

						//ajax 통신 - put 방식으로 수정
						$.ajax({
							type: 'PUT',
							url: '/moca/likeHates/' + reviewId,
							data: {
								"isLike": 1
							},
							success: function() {
								console.log('ajax 통신 성공 - 싫어요 취소 + 좋아요')
								//ajax 통신 성공시
								hateBtn.removeClass('clicked')
								hateCount.val(Number(hateCount.val()) - 1);
								likeBtn.addClass('clicked')
								likeCount.val(Number(likeCount.val()) + 1);

							},
							error: function() {
								console.log('ajax 통신 실패')
								alert("싫어요 취소, 좋아요 실패")
							}

						})


					} else {
						//이전에 아무것도 누르지 않은 상태 > 좋아요 누를때 => 좋아요
						console.log('이전에 아무것도 누르지 않은 상태 > 좋아요 누를때 ');

						//ajax 통싱 - post방식으로 추가
						$.ajax({
							type: 'POST',
							url: '/moca/likeHates/' + reviewId,
							data: {
								"isLike": 1
							},
							success: function() {
								console.log('ajax 통신 성공 - 좋아요')
								//ajax 통신 성공시
								likeBtn.addClass('clicked')
								likeCount.val(Number(likeCount.val()) + 1);
							},
							error: function() {
								console.log('ajax 통신 실패')
								alert("좋아요 실패")
							}
						})



					}


				} else if (clickedLikeHateButton.hasClass('hate-btn')) {
					//싫어요 버튼을 눌렀을때 
					if (likeBtn.hasClass('clicked')) {
						//이전에 좋아요 누른 상태 > 싫어요를 누를때 = >좋아요 취소 + 싫어요
						console.log('이전에 좋아요 누른 상태 > 싫어요 누를때 ')

						//ajax 통신 - put 방식으로 수정
						$.ajax({
							type: 'PUT',
							url: '/moca/likeHates/' + reviewId,
							data: {
								"isLike": -1
							},
							success: function() {
								console.log('ajax 통신 성공 - 좋아요 취소 + 싫어요')
								//ajax 통신 성공시
								likeBtn.removeClass('clicked')
								likeCount.val(Number(likeCount.val()) - 1);
								hateBtn.addClass('clicked')
								hateCount.val(Number(hateCount.val()) + 1);

							},
							error: function() {
								console.log('ajax 통신 실패')
								alert("싫어요 취소, 좋아요 실패")
							}

						})



					} else if (hateBtn.hasClass('clicked')) {
						//이전에 싫어요 누른 상태 > 싫어요를 누를때 = > 싫어요 취소
						console.log('이전에 싫어요 누른 상태 > 싫어요를 누를때 ')

						//ajax 통신 - delete 방식으로 삭제
						$.ajax({
							type: 'DELETE',
							url: '/moca/likeHates/' + reviewId,
							data: {
								"isLike": -1
							},
							success: function() {
								console.log('ajax 통신 성공 - 싫어요 취소')
								//ajax 통신하고 성공시 
								hateBtn.removeClass('clicked')
								hateCount.val(Number(hateCount.val()) - 1);
							},
							error: function() {
								console.log('ajax 통신 실패')
								alert("싫어요 취소 실패")
							}

						})




					} else {
						//이전에 아무것도 누르지 않은 상태 > 싫어요 누를때 => 싫어요
						console.log('이전에 아무것도 누르지 않은 상태 > 싫어요 누를때 ')

						//ajax 통싱 - post방식으로 추가
						$.ajax({
							type: 'POST',
							url: '/moca/likeHates/' + reviewId,
							data: {
								"isLike": -1
							},
							success: function() {
								console.log('ajax 통신 성공 - 싫어요')
								hateBtn.addClass('clicked')
								hateCount.val(Number(hateCount.val()) + 1);
							},
							error: function() {
								console.log('ajax 통신 실패')
								alert("싫어요 실패")
							}

						})
					}
				}
				console.log(clickedLikeHateButton);

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

			$('#myModal').on('shown.bs.modal', function() {
				$('#myInput').focus()
			});

			$('#updateStore').click(function() {
				$(this).attr('data-dismiss', "modal");
				updateStore();
			});

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
					<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal">
						리뷰 작성
					</button>
				</div>
				<div class="review-content">
					<!-- js로 리뷰 수만큼 추가 할 것  -->
					<c:forEach items="${reviewVoList }" var="reviewVo">
						<div class="row">
							<div class="reviewer-info col-md-2">
								<label for="nick-name">별명 : ${reviewVo.nickName} </label><br>
								<label for="follow-count">팔로워 : ${reviewVo.followCount}</label><br>
								<label for="review-count">리뷰 수 : ${reviewVo.reviewCount}</label>
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

								<label for="write-date">작성일 : ${reviewVo.writeDate }</label><br>
								<label for="review-content">리뷰 내용 : ${reviewVo.reviewContent }</label>
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
								<label for="taste_level">맛 : ${reviewVo.tasteLevel } 점</label><br>
								<label for="price_level">가격 : ${reviewVo.priceLevel } 점</label><br>
								<label for="service_level">서비스 : ${reviewVo.serviceLevel } 점</label><br>
								<label for="mode_level">분위기 : ${reviewVo.modeLevel } 점</label><br>
								<label for="convenient_level">편의성 : ${reviewVo.convenienceLevel } 점</label><br>
								<label for="average_level">평균 : ${reviewVo.averageLevel } 점</label>
							</div>
						</div>
						<br><br><br>
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
						<div class="form-group">
							<label for="taste-level">맛</label>
							<input type="range" min="0" max="5" id="taste-level">
						</div>
						<div class="form-group">
							<label for="price-level">가격</label>
							<input type="range" min="0" max="5" id="price-level">
						</div>
						<div class="form-group">
							<label for="mode-level">분위기</label>
							<input type="range" min="0" max="5" id="mode-level">
						</div>
						<div class="form-group">
							<label for="service-level">서비스</label>
							<input type="range" min="0" max="5" id="service-level">
						</div>
						<div class="form-group">
							<label for="convinient-level">편의성</label>
							<input type="range" min="0" max="5" id="convinient-level">
						</div>
						<div class="form-group">
							<label for="picture-file">사진 선택</label>
							<input type="file" id="picture-file" multiple><!-- 다중으로 입력 하는 방법을 생각해야 할듯 -->
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
