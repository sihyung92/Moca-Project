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
	var haveFollowerInfo = false;
	var haveFollowingInfo = false;
	var haveFavoriteInfo = false;
	var haveLikeInfo = false;

	var id=1;
	var test;

	var storeTemplate;

	
	$(document).ready(function() { 
		//변수 바인딩
		storeTemplate = $('#storeTemplate')
		
		$('#mypageTab li').click(function(){
			//탭 클릭과 데이터 유무에 따른 tabContent 통신
			if($(this).index() ==1 && !haveFollowerInfo){
				

				$.ajax({
					type: 'GET',
					url: '/moca/follower/1',
					success: function(reviewVo) {
						haveFollowerInfo =true;
						
					},
					error: function(error) {

					}
				})

			}else if($(this).index() ==2 && !haveFollowingInfo){
				

				
				$.ajax({
					type: 'GET',
					url: '/moca/following/',
					success: function(reviewVo) {
						haveFollowingInfo =true;
						
					},
					error: function(error) {

					}
				})

			}else if($(this).index() ==3 && !haveLikeInfo){
				//사진 이름 주소 별점
				$.ajax({
					type: 'GET',
					url: '/moca/likeStores/'+id,
					success: function(likeStoreList) {
						haveLikeInfo =true;						
						for(var idx in likeStoreList){
							var newStore = $('#storeTemplate').clone(true);
							test = newStore
							console.log(test);
							
							newStore.css('display', '');
							newStore.removeAttr('id');
							newStore.addClass('likeStore')
							newStore.find('.storeId').html(likeStoreList[idx].store_Id);
							if(likeStoreList[idx].logoImg !=null){
								newStore.find('.storeLogoDiv img').attr('src' ,likeStoreList[idx].logoImg)
							}
							newStore.find('.storeName').html(likeStoreList[idx].name);
							newStore.find('.storeAddress').html(likeStoreList[idx].address);
							newStore.find('.storeLevel').html(likeStoreList[idx].averageLevel);

							newStore.attr('href', "/moca/stores/"+likeStoreList[idx].store_Id );

							newStore.click(function(){
								window.location.href = '/moca/stores/'+$(this).find('.storeId').html();
							})

							$('#likeDiv').append(newStore);
							$('#likeDiv').append('<br>')
						}
						
					},
					error: function(error) {

					}
				})

				
				

			}else if($(this).index() ==4 && !haveFavoriteInfo){
				//사진 이름 주소 별점
				$.ajax({
					type: 'GET',
					url: '/moca/favoriteStores/'+id,
					success: function(favoriteStoreList) {
						haveFavoriteInfo =true;
						
						for(var idx in favoriteStoreList){
							
							
							var newStore = $('#storeTemplate').clone(true);
							test = newStore
							console.log(test);
							
							newStore.css('display', '');
							newStore.removeAttr('id');
							newStore.addClass('favoriteStore')
							newStore.find('.storeId').html(favoriteStoreList[idx].store_Id);
							if(favoriteStoreList[idx].logoImg !=null){
								newStore.find('.storeLogoDiv img').attr('src' ,favoriteStoreList[idx].logoImg)
							}
							newStore.find('.storeName').html(favoriteStoreList[idx].name);
							newStore.find('.storeAddress').html(favoriteStoreList[idx].address);
							newStore.find('.storeLevel').html(favoriteStoreList[idx].averageLevel);

							newStore.attr('href', "/moca/stores/"+favoriteStoreList[idx].store_Id );

							newStore.click(function(){
								window.location.href = '/moca/stores/'+$(this).find('.storeId').html();
							})

							$('#favoriteDiv').append(newStore);
							$('#favoriteDiv').append('<br>')
						}
						
					},
					error: function(error) {

					}
				})
				
		    }
		})		
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
						<a class="nav-link" data-toggle="tab"  href="#likeDiv">좋아하는 카페</a>
					</li>
					<li role="presentation" class="nav-item">
						<a class="nav-link" data-toggle="tab" href="#favoriteDiv">즐겨찾는 카페</a>
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
					<div class="tab-pane fade" id="likeDiv">
						<br>
					</div>
					<div class="tab-pane fade" id="favoriteDiv">
						<br>						
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
	
	<!-- clone할 store element -->
	<div class="row" id="storeTemplate" style="display : none;" style="cursor:pointer;">
		<span class="storeId" style="display:none;"></span>
		<div class="storeLogoDiv col-md-2 col-md-offset-1">
			<img src="<c:url value="/resources/imgs/logoDefault.png"/>" alt="logo" class="img-circle" style="width:100px;">
		</div>
		<div class="storeInfoDiv col-md-5">
			<div class="storeNameDiv">
				<span class="storeName">카페명</span>
			</div>
			<div class="storeImgDiv">
				<span class="storeAddress">카페 주소</span>
			</div>
		</div>
		<div class="storeLevelDiv col-md-3">
			평점 : <span class="storeLevel">5.5</span>
		</div>
		
	</div>
</body>
</html>
