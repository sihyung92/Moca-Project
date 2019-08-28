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
		#userInfo, #followInfo{
			margin:0px auto;
			text-align: center;
			display: inline-block;
		}
		#followerDiv>div{
			display: inline;
			margin:0px 3px;
		}
		.inlineBlock{
			display: inline;
		}
		.followInfo{
			text-align: center;
			margin-right: 3rem;
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

	var accountId = "${accountVo.account_id}";
	var isMine = "${accountVo.isMine}";
	var followingId;
	var followInfoTemplate;

	var address = window.location.pathname
	var followId = address.substring(address.lastIndexOf("/")+1);
	
	$(document).ready(function() { 
		if(isMine==1){
			$('#followBtn').hide();
		}

		var followingList = new Array();
		
		<c:forEach items="${followingList}" var="following">
			followingList.push("${following.account_id}");
		</c:forEach>
		console.log(followingList);
		
		for ( var i = 0; i < followingList.length; i++) {
			if(followId==followingList[i]){
				$('#followBtn').attr('class','btn btn-success');
			}
		}
		
		$('#followInfo').hide();
		$('#mypageTab li').click(function(){
			//탭 클릭과 데이터 유무에 따른 tabContent 통신
			if($(this).index() ==1 && !haveFollowerInfo){

				$.ajax({
					type: 'GET',
					url: '/moca/follower/'+accountId,
					success: function(followerList) {
						console.log(followerList);

						console.log(followInfoTemplate);
						for(var i=0; i<followerList.length; i++){
							followInfoTemplate = $('#followInfo').clone();
							console.log(followerList[i].thumbnailImage);
							$(followInfoTemplate).removeAttr('id');
							onclick="location.href='address'"
							$(followInfoTemplate).attr('onclick','location.href="'+followerList[i].account_id+'"');
							$(followInfoTemplate).find('img').attr('src',followerList[i].thumbnailImage);
							$(followInfoTemplate).find('#nickName').html(followerList[i].nickname);
							$(followInfoTemplate).find('#accountLevel').html(followerList[i].accountLevel);
							$(followInfoTemplate).css('display','inline-block');
							$(followInfoTemplate).css('cursor','pointer');
							$('#followerDiv>div>div').append(followInfoTemplate);
						}
						$('#followerDiv>div>div.followInfo').show();
						$('#followInfo').hide();
						
						haveFollowerInfo =true;
					},
					error: function(request,status,error) {

					}
				})

			}else if($(this).index() ==2 && !haveFollowingInfo){
				$.ajax({
					type: 'GET',
					url: '/moca/following/'+accountId,
					success: function(followingList) {

						for(var i=0; i<followingList.length; i++){
							followInfoTemplate = $('#followInfo').clone();
							console.log(followingList[i].thumbnailImage);
							$(followInfoTemplate).removeAttr('id');
							$(followInfoTemplate).attr('onclick','location.href="'+followingList[i].account_id+'"');
							$(followInfoTemplate).find('img').attr('src',followingList[i].thumbnailImage);
							$(followInfoTemplate).find('#nickName').html(followingList[i].nickname);
							$(followInfoTemplate).find('#accountLevel').html(followingList[i].accountLevel);
							$(followInfoTemplate).css('display','inline-block');
							$('#followingDiv>div>div').append(followInfoTemplate);
						}
						$('#followingDiv>div>div.followInfo').show();
						$('#followInfo').hide();
						
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

		$('#followBtn').click(function() {
			var type;
			
			if($('#followBtn').attr('class')=='btn btn-default'){
				//팔로우 신청
				type = 'POST';
				
			}else if($('#followBtn').attr('class')=='btn btn-success'){
				//팔로우 취소
				type = 'DELETE';
			}
			$.ajax({
				type: type,
				url: '/moca/follow/'+accountId,
				data: {"followId":followId},
				success: function() {
					//타입에 따라서 팔로잉/팔로우 텍스트 변경
					$('#followBtn').toggleClass("btn-success");
					$('#followBtn').toggleClass('btn-default');
				},
				error: function(request,status,error) {
					//타입에 따라서 에러 텍스트 변경
					if(error='Internal Server Error'){
						alert('이미 팔로우한 대상입니다');
					}
				}
			});
			
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
		<div class="row">
			<div class="col-md-2 col-md-offset-2" >
				<div id="userInfo">
					<img alt="basicProfile" src="<c:url value="/resources/imgs/basicProfile.png"/>" class="img-circle"><br>
					<button id="followBtn" class="btn btn-default">팔로우</button><br>
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
						<div class="row">
							<div class="col-md-10 col-md-offset-1 inlineBlock" >
							</div>
						</div>
					</div>
					<div class="tab-pane fade" id="followingDiv">
						<div class="row">
							<div class="col-md-10 col-md-offset-1 inlineBlock" >
							</div>
						</div>
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
	
	<!--followDiv  -->
	<div class="followInfo" id="followInfo">
		<img alt="basicProfile" src="<c:url value="/resources/imgs/basicProfile.png"/>" class="img-circle" style="width:10rem;"><br>
		<b><span id="nickName">별명</span></b><br>
		<small>Lv.<span id="accountLevel">3</span></small><br>
	</div>
</body>
</html>
