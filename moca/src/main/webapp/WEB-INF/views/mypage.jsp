<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
	<title>Home</title>
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap-theme.css"/>" />
	<style type="text/css">
		#userInfo{
			margin:0px auto;
			text-align: center;
		}
	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> 	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- 차트 -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
	<script type="text/javascript">
	var haveFollowerInfo = false;
	var haveFollowingInfo = false;
	var haveFavoriteInfo = false;
	var haveLikeInfo = false;
	
	$(document).ready(function() { 
		$('#mypageTab li').click(function(){
			//탭 클릭과 데이터 유무에 따른 tabContent 통신
			if($(this).index() ==1 && !haveFollowerInfo){

				$.ajax({
					type: 'GET',
					url: '/moca/follower/1',
					success: function(reviewVo) {

						
						haveFollowerInfo =true;
					},
					error: function(request,status,error) {

					}
				})

			}else if($(this).index() ==2 && !haveFollowingInfo){

				
				$.ajax({
					type: 'GET',
					url: '/moca/following/1',
					success: function(reviewVo) {

						
						haveFollowingInfo =true;
					},
					error: function(request,status,error) {

					}
				})

			}else if($(this).index() ==3 && !haveFavoriteInfo){

				//사진 이름 주소 별점
				$.ajax({
					type: 'GET',
					url: '/moca/favoriteStores/1',
					success: function(reviewVo) {

						
						haveFavoriteInfo =true;
					},
					error: function(request,status,error) {

					}
				})

			}else if($(this).index() ==4 && !haveLikeInfo){

				//사진 이름 주소 별점
				$.ajax({
					type: 'GET',
					url: '/moca/likeStores/1',
					success: function(reviewVo) {

						
						haveLikeInfo =true;
					},
					error: function(request,status,error) {

					}
				})
		    }
		})		
    });

    
	$('#followBtn').click(function() {
		$('#followBtn').toggleClass("btn btn-success");
		$('#followBtn').removeClass();
		$('#followBtn').addClass('btn btn-success');
	});

	$('#followingBtn').click(function() {
		$('#followingBtn').attr('class','btn btn-success');
	});

   
	</script>
</head>
<body>
	<!-- 그리드 시스템으로 만들것 -->
	<div id="header">
		<jsp:include page="../../resources/template/header.jsp" flush="true"></jsp:include>
	</div>
	<div id="content">
		<div class="row">
			<div class="col-md-2 col-md-offset-2" >
				<div id="userInfo">
					<img alt="basicProfile" src="<c:url value="/resources/imgs/basicProfile.png"/>" class="img-circle"><br>
					<button id="followBtn" class="btn btn-default">팔로우</button><button id="followingBtn" class="btn btn-default">팔로잉</button><br>
					<span id="nickName">별명</span><br>
					Lv.<span id="accountLevel">3</span><br>			
				</div>
			</div>
			<div class="col-md-3">
				그래프
			
			</div>
			<div class="col-md-3">
				배지
			
			</div>
			<br><br>
			
		</div>
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<ul id="mypageTab" class="nav nav-tabs">
					<li role="presentation" class="nav-item active">
						<a class="nav-link active" data-toggle="tab" href="#myReviewDiv">내 게시글</a>
					</li>
					<li role="presentation" class="nav-item">
						<a class="nav-link" data-toggle="tab" href="#followerDiv">팔로워</a>
					</li>
					<li role="presentation" class="nav-item">
						<a class="nav-link" data-toggle="tab" href="#followingDiv">팔로잉</a>
					</li>
					<li role="presentation" class="nav-item">
						<a class="nav-link" data-toggle="tab" href="#favoriteDiv">즐겨찾는 카페</a>
					</li>
					<li role="presentation" class="nav-item">
						<a class="nav-link" data-toggle="tab"  href="#likeDiv">좋아하는 카페</a>
					</li>
					
				</ul>
				<div class="tab-content">
					<div class="tab-pane fade active in" id="myReviewDiv">
						<p>myReviewDiv 리뷰 스타일 그대로 가져오고</p>
					</div>
					<div class="tab-pane fade" id="followerDiv">
						<!--followerDiv  -->
						<p>followerDiv </p>
					</div>
					<div class="tab-pane fade" id="followingDiv">
						<!--followingDiv  -->
						<p>followingDiv</p>
					</div>
					<div class="tab-pane fade" id="favoriteDiv">
						<p>favoriteDiv</p>
					</div>
					<div class="tab-pane fade" id="likeDiv">
						<p>likeDiv</p>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
			</div>
		</div>
	</div>
	<div id="footer">
		<jsp:include page="../../resources/template/footer.jsp" flush="true"></jsp:include>
	</div>

</div>
</body>
</html>
