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
	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> 	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- 차트 -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
	<!-- mocaReview -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaReview.js?ver=1"/>"></script>
	<!-- mocaStore -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaStore.js"/>"></script>
	<script type="text/javascript">
    window.onload = function () { 

    };

   
	</script>
</head>
<body>
	<!-- 그리드 시스템으로 만들것 -->
	<div id="header">
		<jsp:include page="../../resources/template/header.jsp" flush="true"></jsp:include>
	</div>
	<div id="content">
		<div class="row">
			<div class="col-md-2 col-md-offset-2">
				<img alt="basicProfile" src="<c:url value="/resources/imgs/basicProfile.png"/>" class="img-circle">
				<div>
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
				<ul class="nav nav-tabs">
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
						<p>followerDiv </p>
					</div>
					<div class="tab-pane fade" id="followingDiv">
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
