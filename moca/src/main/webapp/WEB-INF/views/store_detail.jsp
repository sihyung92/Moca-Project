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

	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> <script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> <!-- jqm 사용시 <script type="text/javascript" src="resources/js/jquery.mobile-1.4.5.js"></script>
	-->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- 차트 -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
	<!-- 카카오 로그인 -->
	<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
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
							type :'DELETE',
							url : '/moca/likeHates/'+reviewId,
							success : function(){
								console.log('ajax 통신 성공 - 좋아요 취소')
								likeBtn.removeClass('clicked')
								likeCount.val(Number(likeCount.val()) -1);
							},
							error : function(){
								console.log('ajax 통신 실패')
								alert("좋아요 취소 실패")
							}
							
						})
						
						
						


					} else if (hateBtn.hasClass('clicked')) {
						//이전에 싫어요 누른 상태 > 좋아요를 누를때 = > 싫어요 취소 + 좋아요
						console.log('이전에 싫어요 누른 상태 > 좋아요를 누를때 ')
						
						//ajax 통신 - put 방식으로 수정
						$.ajax({
							type :'PUT',
							url : '/moca/likeHates/'+reviewId,
							data : {"isLike" : 1},
							success : function(){
								console.log('ajax 통신 성공 - 싫어요 취소 + 좋아요')
								//ajax 통신 성공시
								hateBtn.removeClass('clicked')
								hateCount.val(Number(hateCount.val()) -1);
								likeBtn.addClass('clicked')
								likeCount.val(Number(likeCount.val()) +1);
								
							},
							error : function(){
								console.log('ajax 통신 실패')
								alert("싫어요 취소, 좋아요 실패")
							}
							
						})
					
						
					}else {
						//이전에 아무것도 누르지 않은 상태 > 좋아요 누를때 => 좋아요
						console.log('이전에 아무것도 누르지 않은 상태 > 좋아요 누를때 ');
						
						//ajax 통싱 - post방식으로 추가
						$.ajax({
							type :'POST',
							url : '/moca/likeHates/'+reviewId,
							data : {"isLike" : 1},
							success : function(){
								console.log('ajax 통신 성공 - 좋아요')
								//ajax 통신 성공시
								likeBtn.addClass('clicked')
								likeCount.val(Number(likeCount.val()) +1);
							},
							error : function(){
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
							type :'PUT',
							url : '/moca/likeHates/'+reviewId,
							data : {"isLike" : -1},
							success : function(){
								console.log('ajax 통신 성공 - 좋아요 취소 + 싫어요')
								//ajax 통신 성공시
								likeBtn.removeClass('clicked')
								likeCount.val(Number(likeCount.val())-1);
								hateBtn.addClass('clicked')
								hateCount.val(Number(hateCount.val())+1);
								
							},
							error : function(){
								console.log('ajax 통신 실패')
								alert("싫어요 취소, 좋아요 실패")
							}
							
						})
					
						

					} else if (hateBtn.hasClass('clicked')) {
						//이전에 싫어요 누른 상태 > 싫어요를 누를때 = > 싫어요 취소
						console.log('이전에 싫어요 누른 상태 > 싫어요를 누를때 ')
						
						//ajax 통신 - delete 방식으로 삭제
						$.ajax({
							type :'DELETE',
							url : '/moca/likeHates/'+reviewId,
							success : function(){
								console.log('ajax 통신 성공 - 싫어요 취소')
								//ajax 통신하고 성공시 
								hateBtn.removeClass('clicked')
								hateCount.val(Number(hateCount.val()) -1);
							},
							error : function(){
								console.log('ajax 통신 실패')
								alert("싫어요 취소 실패")
							}
							
						})
						
						
						
						
					}else{
						//이전에 아무것도 누르지 않은 상태 > 싫어요 누를때 => 싫어요
						console.log('이전에 아무것도 누르지 않은 상태 > 싫어요 누를때 ')
						
						//ajax 통싱 - post방식으로 추가
						$.ajax({
							type :'POST',
							url : '/moca/likeHates/'+reviewId,
							data : {"isLike" : -1},
							success : function(){
								console.log('ajax 통신 성공 - 싫어요')
								hateBtn.addClass('clicked')
								hateCount.val(Number(hateCount.val()) +1);
							},
							error : function(){
								console.log('ajax 통신 실패')
								alert("싫어요 실패")
							}
							
						})
					}
				}
				console.log(clickedLikeHateButton);

			})

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

		function deleteReview() {
			$.ajax({
				url: 'review',
				type: 'delete',
				data: '1', //일단 좋아요를 제거한다고 가정
				success: function() {

				}

			})
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
						<h1><img src="<c:url value="/resources/imgs/logo.png"/>" alt="logo" class="img-circle">&nbsp;STARBUCKS</h1>
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

</body>

</html>
