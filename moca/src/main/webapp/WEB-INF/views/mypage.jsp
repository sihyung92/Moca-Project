<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
	<title>moca</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
	<link rel="shortcut icon" href="<c:url value="/resources/imgs/circleLogo.ico"/>" type="image/x-icon">
	<link rel="icon" href="<c:url value="/resources/imgs/circleLogo.ico"/>" type="image/x-icon">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap-theme.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/review.css?ver=16"/>" />
	<style type="text/css">
	#userGraph{
		margin-top:70px;
	}
	#userGraph table{
		width:100%;
		text-align: center;
	}
	#userGraph table tr{
		height:30px;
	}
	
	/*그 스토어페이지랑 메인페이지랑 로그인 사이즈가 다른 이유가 클래스 설정이 이상해서임 이거 제발 추가해야함*/
	.modal-login{
	    width:100%;
	}
	#userBadge{
		height:150px;
		margin-top:20px;
		padding:20px;
	}
	#userBadge img{
		margin-right: 5px;
		margin-left: 5px;
		margin-bottom : 10px;
	}
	
	#userInfo{
		padding:30px;
	}
	#userInfo button{
		margin: 20px 0px;
	}
	#userInfo, #followInfo{
		margin:20px auto;
		text-align: center;
		display: inline-block;
		width:100%;
	}
	
	.followInfo, .likeStore, .favoriteStore{
		text-align: center;
		margin-right: 3rem;
		margin-bottom: 3em;
	    background-color: white;
	    padding: 1em;
	    box-shadow: 0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23);
	}
	.likeStore, .favoriteStore{
		padding: 3em;
	}
	
	#followingDiv, #followerDiv, #likeDiv, #favoriteDiv{
		margin-top: 3em;
	}
	
	#followerDiv>div{
		display: inline;
		margin:0px 3px;
	}
	
	.inlineBlock{
		display: inline;
	}
	
	/*글리피콘 사이즈*/
	.glyphicon-cog{
		font-size: 2rem;
	}
	
	.popover{
		width: 400px;
   		max-width: 400px;
	}
	
	#userImage{
		margin: 20px auto;
		text-align: center;
	}
	
	#needBadgeSpan{
		color: #c0c0c0;
	    position: relative;
	    top: 35%;
	    left: 40%;
	    font-weight: bold;
	}
	
	.storeName{
		font-size:110%;
		font-weight: bold;
		padding-top: 10px;
   		display: block;
	}
	
	.nav-tabs{
		margin-top: 30px;
	}
	
	.followed{
		background-color: rgba(242,174,46,0.85);
	}
		
	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> 	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- mocaReview -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaReview.js?ver=23"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery.raty.js"/>"></script>
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

	//여러 파일을 가지고 있는 버퍼
	var fileBuffer;
	var fileListDiv;
	var removeThumbnailBtn;
	var newFileDiv;
	var fileBuffer;

	/// mypage 사용자 id(url 주소의 맨 마지막)
	var id=$(location).attr('pathname').split('/')[$(location).attr('pathname').split('/').length-1];

	var storeTemplate;

	var tagNameList;
	
	$(document).ready(function() { 
			
		if(accountId==0 && id=="mypage"){
			respondHttpStatus(401);
		}

		$('#Login-Modal').on('hidden.bs.modal', function () {
			if(accountId==0 && id=="mypage"){
				respondHttpStatus(401);
			}
		});
		
		/////////////////내가 쓴글 관리 시작//////////////
		//변수 바인딩
		bindReviewVariable();
		storeTemplate = $('#storeTemplate')	//변수 바인딩

		
		//raty
		bindRaty();
		<c:forEach items="${reviewVoList }" var="reviewVo">
		$.fn.raty.start(${reviewVo.averageLevel }, '#reviewAverageLevel-${reviewVo.review_id }');
		</c:forEach>
		
		//좋아요 또는 싫어요 버튼 클릭시
		likeHateButton.click(function(){
			bindLikeHateButtonEvent($(this));
		});

		//fileBuffer 초기화
		fileBuffer = [];

		//수정을 눌렀을 때와 입력을 눌렀을 때 파일 입력 개수의 차이
		$('#files').change(filesChange);
		
		
		//리뷰 내용 더보기 style 변화
		callReviewDataMore();

		//리뷰 더보기 버튼을 눌렀을 때
		$('#moreReview').click(function(){
			if(reviewVoListLength==true){
				return false;
			}
			reviewMoreBtnClick("mypage");
		});
		
		//리뷰 저장 버튼 클릭시
		$(saveReviewBtn).click(function() {
			saveReview(fileBuffer);
		})
		
		//수정 버튼 클릭시
		editBtn.click(function(){
			//파일 버퍼 내용 비우기
			fileBuffer = [];
			
			//리뷰 내용을 리뷰 모달로 옴기고 창 띄움
			var storeName = $(this).parent().parent().find('.store-info .storeName-div .storeName').html();
			
			reviewData2ReviewModal($(this),storeName);
			
			transReviewEditMode();
			$('#reviewModal').modal("show");		//리뷰 모달창 show
						
		})
		
		//리뷰 수정 버튼 클릭시
		editReviewBtn.click(function(){
			tagCheckboxData2Tags();

			editReview();
		})
		
		reviewModalBtn.click(function(){
			//모달에 있는 데이터 없애고 
			fileBuffer = [];
			clearReviewModalData();
			reviewModal.find('#saveReviewBtn').css('display','')
			reviewModal.find('#editReviewBtn').css('display','none')
			$('#reviewModal').modal("show");		//리뷰 모달창 show
		})
		

		//리뷰 삭제 버튼 클릭시
		deleteBtn.click(function(){
			var reviewId = $(this).parent().find('.review-id').val();
			var reviewTodelete = $(this).parent().parent();
			$('#confirm').modal({ backdrop: 'static', keyboard: false })
	        .one('click', '#delete', function() {
	        	reviewTodelete.remove();
				deleteReview(reviewId);
	        });
		});

		//리뷰 이미지 디테일 모달
		reviewImg.click(function(){
			//모달 활성화(+초기화)
			reviewsDetailModal.modal("show");
			

			//섬네일 url > 원본 url
			showDetailReviewImg(this);

			
			//데이터 값 전송
			
		});

		$('#preReviewImgBtn').click(function(){
			if(detailImgIdx > 0){
				detailImgIdx =detailImgIdx-1;
			}else{
				detailImgIdx = 0;
			}
			showDetailReviewImg(reviewThumbnailGroup.find('img').eq(detailImgIdx)[0]);
			
		});

		$('#nextReviewImgBtn').click(function(){
			if(detailImgIdx < detailImgsSize-1){
				detailImgIdx =detailImgIdx+1;
			}else{
				detailImgIdx = detailImgsSize-1;
			}
			showDetailReviewImg(reviewThumbnailGroup.find('img').eq(detailImgIdx)[0]);
		});
		
		/////////////////내가 쓴글 관리 끝//////////////
		
		if(isMine!=1){
			$('#followBtn').show();
		}

		var followingList = new Array();
		
		<c:forEach items="${followingList}" var="following">
			followingList.push("${following.account_id}");
		</c:forEach>
		
		for ( var i = 0; i < followingList.length; i++) {
			if(followId==followingList[i]){
				$('#followBtn').attr('class','btn followed');
			}
		}

		$('#followInfo').hide();
		$('#mypageTab li').click(function(){
			//탭 클릭과 데이터 유무에 따른 tabContent 통신
			if($(this).index() ==1 && !haveFollowerInfo){

				$.ajax({
					type: 'GET',
					url: '/moca/follower/'+followId,
					success: function(followerList) {

						for(var i=0; i<followerList.length; i++){
							followInfoTemplate = $('#followInfo').clone();
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
						
						
					},
					error: function(request,status,error) {
						if(request.status==423){
							whenAccessDeny($('#followerDiv'));
						}
					}
					
				}).always(function(){
					haveFollowerInfo =true;
				})

			}else if($(this).index() ==2 && !haveFollowingInfo){
				$.ajax({
					type: 'GET',
					url: '/moca/following/'+followId,
					success: function(followingList) {

						for(var i=0; i<followingList.length; i++){
							followInfoTemplate = $('#followInfo').clone();
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
						
						
					},
					error: function(request,status,error) {
						if(request.status==423){
							whenAccessDeny($('#followingDiv'));
						}
					}
					
				}).always(function(){
					haveFollowingInfo =true;
				})

			}else if($(this).index() ==3 && !haveLikeInfo){

				//사진 이름 주소 별점
				$.ajax({
					type: 'GET',
					url: '/moca/likeStores/'+id,
					success: function(likeStoreList) {
											
						for(var idx in likeStoreList){
							var newStore = makeNewStore(likeStoreList[idx]);

							$('#likeDiv').append(newStore);
							$('#likeDiv').append('<br>')
							$.fn.raty.start(likeStoreList[idx].averageLevel, '#storeAverageLevel-'+likeStoreList[idx].store_Id);
						}
						
					},
					error: function(request,status,error) {
						if(request.status==423){
							whenAccessDeny($('#likeDiv'));
						}
					}
					
				}).always(function(){
					haveLikeInfo =true;	
				})

			}else if($(this).index() ==4 && !haveFavoriteInfo){

				//사진 이름 주소 별점
				$.ajax({
					type: 'GET',
					url: '/moca/favoriteStores/'+id,
					success: function(favoriteStoreList) {
						
						
						for(var idx in favoriteStoreList){
							var newStore = makeNewStore(favoriteStoreList[idx]);

							$('#favoriteDiv').append(newStore);
							$('#favoriteDiv').append('<br>')
							$.fn.raty.start(favoriteStoreList[idx].averageLevel, '#storeAverageLevel-'+favoriteStoreList[idx].store_Id);
						}
						
					},
					error: function(request,status,error) {
						if(request.status==423){
							whenAccessDeny($('#favoriteDiv'));
						}
					}
					
				}).always(function(){
					haveFavoriteInfo =true;
				})
		    }
		})		

		$('#followBtn').click(function() {
			var type;
			
			if(!$('#followBtn').hasClass('followed')){
				//팔로우 신청
				type = 'POST';
				
			}else{
				//팔로우 취소
				type = 'DELETE';
			}
			$.ajax({
				type: type,
				url: '/moca/follow/'+followId,
				success: function() {
					//타입에 따라서 팔로잉/팔로우 텍스트 변경
					if(type == 'POST'){
						$('#followBtn').attr('class', 'btn followed');
						var oldFollowCnt = $('#followCount').text()
						$('#followCount').text((oldFollowCnt*1)+1);
					}else{
						$('#followBtn').attr('class', 'btn');
						var oldFollowCnt = $('#followCount').text()
						$('#followCount').text((oldFollowCnt*1)-1);
					}
				},
				error: function(request,status,error) {
					respondHttpStatus(request.status);
				}
			});
			
		});

		//레벨제 설명 툴팁 옵션
		$('#levelGuide').popover({
			trigger : 'hover',
			html : true
		});

		//회원정보 수정 모달
		$('#userInfoUpdateBtn').click(function(){
			$('#userImage').find('img').attr('src', $('#userInfo').find('img').attr('src'));
			$('#userInfoUpdate').modal("show");
		});

		//input file 버튼 대체
		$('#userImageUpdateBtn').click(function(){
			$('#userImageUpdateInput').click();
		});

		//input file change시
		$('#userImageUpdateInput').change(userImageChange);

		//회원 탈퇴 버튼 클릭시
		$('#deleteUserBtn').click(function(){
			if (confirm("정말 탈퇴하시겠습니까??") == true){    //확인
				
				
			    //ajax통신으로 세션에서도 삭제,디비에서도 삭제
			    $.ajax({
					type: 'DELETE',
					url: '/moca/deleteAccount/' + accountId,
					success: function() {
						//카카오 삭제
						Kakao.API.request({
							url: '/v1/user/unlink',
							success: function(res) {
								alert('정상적으로 회원탈퇴 되었습니다. 이용해주셔서 감사합니다.');
							},
							fail: function(error) {
					            alert(JSON.stringify(error));
					        }
						});
						window.location.href='/moca/'
					},
					error: function() {
						alert("탈퇴 실패")
					}
				});
				
			    ///회원 탈퇴이유도 받았으면 좋겠다 (ver2)
			    $('#userInfoUpdate').modal("hide");
			    //
			}else{   //취소
			    return;
			}
		});

		//회원 정보 수정 확인 눌렀을 때 
		$('#updateBtn').click(function(){

			var form = $('#userInfoUpdateForm')[0];

			var userInfoFormData = new FormData(form);

			userInfoFormData.delete('file');
			
			if(isMine==1){
				$.ajax({
					type: 'POST',
					url: '/moca/editAccount/'+accountId,
					enctype : 'multipart/form-data',
					data: userInfoFormData,
					datatype: 'json',
					contentType : false,
					processData : false,
					success: function() {
						$('#userInfo').find('img').attr('src',$('#userImage').find('img').attr('src'));
						$('#userInfo').find('#nickName').html($('input[name=nickname]').val());
						$('#profile-icon').attr({
                            src:changedImg
                        });
					},
					error: function(request,status,error) {
						console.log('회원정보 수정 실패');
					}
				})
			}
		});		
    });

	var makeNewStore = function(store){
		var newStore = $('#storeTemplate').clone(true);
		
		newStore.css('display', '');
		newStore.removeAttr('id');
		newStore.addClass('likeStore')
		newStore.find('.storeId').html(store.store_Id);
		if(store.logoImg !=null){
			newStore.find('.storeLogoDiv img').attr('src' ,store.logoImg)
		}
		newStore.find('.storeName').html(store.name);
		newStore.find('.storeAddress').html(store.address);

		var newStoreId = 'storeAverageLevel-'+store.store_Id;
		newStore.find('.storeAverageLevel').attr('id',newStoreId);
		newStore.find('.storeAverageLevel').raty({
			half:true,
			readOnly:  true,
			starHalf:   'star-half.png',
			starOff:    'star-off.png',
			starOn:     'star-on.png',  
		});
		
		newStore.find('.storeLevel').html(int2Double(store.averageLevel));

		newStore.attr('href', "/moca/stores/"+store.store_Id );

		newStore.click(function(){
			window.location.href = '/moca/stores/'+$(this).find('.storeId').html();
		})

		return newStore;
	}

	//회원정보 수정 때 userImage change되면
	var changedImg = "";
	var userImageChange = function(){
		
		const userImageUpdateInput = document.getElementById('userImageUpdateInput');
		var userImage = userImageUpdateInput.files[0];
		const fileName = userImage.name;
		const fileEx = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
	    if(fileEx != "jpg" && fileEx != "png" &&  fileEx != "gif" &&  fileEx != "bmp" &&  fileEx != "jpeg"){
	        alert("파일은 (jpg, jpeg, png, gif, bmp) 형식만 등록 가능합니다.");
	        return false;
	    }

		$('#userImage').find('img').attr('src', URL.createObjectURL(userImage));
		$('#userImage').find('img').css('width','110px').css('height','110px');
		changedImg = "" + URL.createObjectURL(userImage);
	};

	var whenAccessDeny = function(whereAccessDeny){
		var accessDeny = $('#accessDeny').clone();
		accessDeny.css('display','block');
		whereAccessDeny.prepend(accessDeny);
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
			<div class="col-md-2 col-md-offset-2" >
				<div id="userInfo">
					<c:if test="${accountVo.isMine eq 1}">
					<span class="glyphicon glyphicon-cog" id="userInfoUpdateBtn" aria-hidden="true" style="float:right;"></span>
					</c:if>
					<br>
					<img alt="basicProfile" src="${currentPageAccount.thumbnailImage}" class="img-circle" style="width:110px; height:110px;"><br>
					<button id="followBtn" class="btn" style="display:none;">팔로우</button><br>
					<span id="nickName">${currentPageAccount.nickname}</span><br>
					Lv.<span id="accountLevel">${currentPageAccount.accountLevel}</span>
					<span id="levelName">(${currentPageAccount.levelName})</span>
					<span class="glyphicon glyphicon-question-sign" aria-hidden="true"
						id="levelGuide" data-toggle="popover" title="등급제도 안내"
						data-content="Lv.1 : 라이트 <br>Lv.2 : 시나몬 <br>Lv.3 : 미디움 <br> Lv.4 : 하이 <br>Lv.5 : 시티 <br>Lv.6 : 풀시티 <br>Lv.7 : 프렌치 <br>Lv.8 : 이탈리안 <br>">
					</span> <br>
					<c:if test="${accountVo.isMine eq 1}">
					<div class="progress">
						<div class="progress-bar progress-bar-info" role="progressbar"
							aria-valuenow="${accountVo.exp}" aria-valuemin="${accountVo.minExp}" aria-valuemax="${accountVo.maxExp}"
							style="width: ${(accountVo.exp-accountVo.minExp)/(accountVo.maxExp-accountVo.minExp)*100}%">
							<fmt:formatNumber value="${(accountVo.exp-accountVo.minExp)/(accountVo.maxExp-accountVo.minExp)}" type="percent"></fmt:formatNumber>
						</div>
					</div>
					</c:if>
				</div>
			</div>
			<div class="col-md-6" >
			<div class="row">
			<div class="col-md-12" id="userGraph">
			<table>
					<tr>
						<td><b>출석수</b></td>
						<td><b>리뷰수</b></td>
						<td><b>팔로워</b></td>
						<td><b>팔로잉</b></td>
					</tr>
					<tr>
						<td>${currentPageAccount.attendanceCount}</td>
						<td>${currentPageAccount.reviewCount}</td>
						<td id="followCount">${currentPageAccount.followCount}</td>
						<td>${currentPageAccount.followingCount}</td>
					</tr>
				</table>
				</div>
				
			</div>
			<div class="row">
				<div id="userBadge">
					<c:forEach items="${currentPageAccount.badgeList }" var="badgeVo">
						<div class="col-md-2 col-xs-4">
							<img class="img-circle" alt="badge" src="<c:url value="${badgeVo.badgeUrl}"/>" style="width: 100px">
						</div>
					</c:forEach>
					<c:if test="${empty currentPageAccount.badgeList}">
						<span id="needBadgeSpan">뱃지를 모아주세요</span>
					</c:if>
				</div>
			</div>
				
			</div>
			
		</div>
		<div class="row">
			<div class="col-xs-10 col-xs-offset-1 col-sm-8 col-sm-offset-2">
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
						<a class="nav-link" data-toggle="tab" href="#favoriteDiv">가고싶은 카페</a>
					</li>				
					
				</ul>
				<div class="tab-content">
					<div class="tab-pane fade active in" id="myReviewDiv">
						<div class="review-content">
							<!-- js로 리뷰 수만큼 추가 할 것  -->
							<c:forEach items="${reviewVoList }" var="reviewVo">
								<div class="row reviewCnt">
									<c:if test="${reviewVo.editable eq 1}">
										<div class="editDeleteGroup btn-group" role="group">
											<input name="storeId" class="store-id" value="${reviewVo.store_id}" style="display: none;">
											<input type="number" class="review-id" value=${reviewVo.review_id } style="display: none;">
											<img class="btn-edit clickableSvgCss" src="<c:url value="/resources/imgs/icons/compose.svg"/>"> 
											<img class="btn-delete clickableSvgCss" src="<c:url value="/resources/imgs/icons/trash.svg"/>">
										</div>
									</c:if>
									<div class="store-info col-md-2 text-center" >
										<div class="storeLogo-div">
											<!-- store logo 이미지 -->
											<c:if test="${empty reviewVo.storeLogoImg}">
												<img src="<c:url value="/resources/imgs/logo/noneCirclelogo.png"/>"
													alt="logo" class="img-circle clickableSvgCss" style="width: 100px; height:100px;" 
													onclick="location.href='/moca/stores/${reviewVo.store_id}'" >
											</c:if>
											<c:if test="${not empty reviewVo.storeLogoImg}">
												<img src="<c:url value="${reviewVo.storeLogoImg }" />" alt="logo"
													class="img-circle clickableSvgCss" style="width: 100px; height:100px;"
													onclick="location.href='/moca/stores/${reviewVo.store_id}'" >
											</c:if>
										</div>
										<div class="storeName-div">
											<!-- store 이름 -->
											<span class="storeName">${reviewVo.storeName}</span>
										</div>
									</div>

									<div class="review-info col-md-9"> 
										<div class="row">
											<div class="review-level">
												<div class="taste-level-div">
													<label>맛</label>
													<span class="taste-level">${reviewVo.tasteLevel }</span>
												</div>
												<div class="price-level-div">
													<label>가격</label>
													<span class="price-level">${reviewVo.priceLevel }</span>
												</div>
												<div class="service-level-div">
													<label>서비스</label>
													<span class="service-level">${reviewVo.serviceLevel }</span>
												</div>
												<div class="mood-level-div">
													<label>분위기</label>
													<span class="mood-level">${reviewVo.moodLevel }</span>
												</div>
												<div class="convenience-level-div">
													<label>편의성</label>
													<span class="convenience-level">${reviewVo.convenienceLevel }</span>
												</div>
												<div class="average-level-div" style="display: block;">
													<label for="average_level">평균</label>
													<div class="reviewAverageLevel" id="reviewAverageLevel-${reviewVo.review_id }"></div><span class="average-level">${reviewVo.averageLevel }</span>
												</div>
											</div>
											<div class="reviewThumbnailGroup">
												<c:forEach items="${reviewVo.imageList}" var="reviewImg">
													<div class="reviewThumbnail">
														<img src="${reviewImg.thumbnailUrl}" alt="Image" class="img-thumbnail" id="${reviewImg.uu_id}">
													</div>
												</c:forEach>
											</div>
											<div class="review-data">
												<div class="write-date-div">
													<span class="reviewInfo-write-date">${reviewVo.writeDate }</span>
												</div>
												<div class="review-tags-div">
													<c:forEach items="${reviewVo.tagMap}" var="i">
														<c:if test="${i.value eq 1}">
															<a class="review-tag" href="/moca/stores?keyword=%23${i.key }&filter=distance">#${i.key }</a>	
														</c:if>
													</c:forEach>
												</div>
												<div class="review-content-div">
													<pre class="reviewInfo-review-content more-review-content">${reviewVo.reviewContent }</pre>
													<span class="more-review-content-btn"><img src="<c:url value="/resources/imgs/icons/chevron-bottom.svg"/>">더보기</span>
												</div>
											</div>
											<div class="form-group like-hate">
												<div class="btn-group" data-toggle="buttons">
													<input type="number" class="review-id" value=${reviewVo.review_id } style="display: none;">
													<c:choose>
														<c:when test="${reviewVo.isLike==1 }">
															<img class="like-btn clickableSvgCss" src="<c:url value="/resources/imgs/icons/thumbs-up-fill.svg"/>">
														</c:when>
														<c:otherwise>
															<img class="like-btn clickableSvgCss" src="<c:url value="/resources/imgs/icons/thumbs-up.svg"/>">
														</c:otherwise>
													</c:choose>
													<input type="number" class="like-count" readonly value=${reviewVo.likeCount }>
													<c:choose>
														<c:when test="${reviewVo.isLike==-1 }">
															<img class="hate-btn clickableSvgCss" src="<c:url value="/resources/imgs/icons/thumbs-down-fill.svg"/>">
														</c:when>
														<c:otherwise>
															<img class="hate-btn clickableSvgCss" src="<c:url value="/resources/imgs/icons/thumbs-down.svg"/>">
														</c:otherwise>
													</c:choose>
													<input type="number" class="hate-count" readonly value=${reviewVo.hateCount }>
												</div>
											</div>
										</div>
									</div>
								</div>
							</c:forEach>
						</div>
						<div class="review-footer">
							<c:if test="${fn:length(reviewVoList) ge 3}">
								<button id="moreReview" class="customBtn" style="width:100%; border: 2px solid #c0c0c0; border-left:none; border-right:none; padding: 10px;">
									<img alt="more" src="<c:url value="/resources/imgs/icons/chevron-bottom.svg"/>" style="width: 15px; padding-bottom: 2px; margin-right: 5px;"> 더보기
								</button>
							</c:if>
						</div>
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
					<div class="tab-pane fade" id="likeDiv">
					</div>
					<div class="tab-pane fade" id="favoriteDiv">
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
			<img src="<c:url value="/resources/imgs/logo/noneCirclelogo.png"/>" alt="logo" class="img-circle clickableSvgCss" style="width:100px; height:100px;">
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
			<label for="storeLevel">평균</label>
			<div class="storeAverageLevel"></div>
			<span class="storeLevel"></span>
		</div>
	</div>
	<!--followDiv  -->
	<div class="followInfo" id="followInfo">
		<img alt="basicProfile" src="<c:url value="/resources/imgs/basicProfile.png"/>" class="img-circle" style="width:10rem;"><br>
		<b><span id="nickName">별명</span></b><br>
		<small>Lv.<span id="accountLevel">3</span></small><br>
	</div>
	
	<!-- 접근 제한 Div -->
	<div class="text-center" id="accessDeny" style="display: none;">
		<img src="/moca/resources/imgs/icons/lock.svg"/>
		<p><br>접근 제한된 정보입니다</p>
	</div>
	
	<!--회원정보 수정 모달 -->
	<div id="userInfoUpdate" class="modal fade" aria-hidden="true" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" >
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        <h4 class="modal-title">회원 정보 수정</h4>
		      	</div>
				<div class="modal-body">
					<form class="form-horizontal" id="userInfoUpdateForm">
						<input type="hidden" name="account_id" value="${accountVo.account_id}" />
						<div class="form-group" id="userImage">
						<!-- 
						int account_id, followCount, reviewCount, platformId, accountLevel, isMine, exp;
	String nickname, platformType, profileImage, thumbnailImage;
						 -->
							<!-- 프로필사진 수정 -->
							<img alt="basicProfile"
								src="${currentPageAccount.thumbnailImage}" class="img-circle" style="width: 110px;">
							<button type="button" id="userImageUpdateBtn" class="btn btn-default" aria-label="Right Align" style="position:relative; left:-35px; top:40px">
								<span class="glyphicon glyphicon-camera" aria-hidden="true"></span>
							</button>
							<input type="file" id="userImageUpdateInput" name="userImage" style="display:none"/>
						</div>
						<!-- 닉네임 수정 -->
						<div class="form-group">
							<label for="nickName" class="col-sm-2 control-label">닉네임
								: </label>
								<div class="col-sm-10">
								<input class="form-control" name="nickname" id="nickName"
								value="${currentPageAccount.nickname}" placeholder="닉네임을 입력해주세요" />
								</div>
						</div>
						<!-- 이메일 수정 -->
						<div class="form-group">
							<label for="userEmail" class="col-sm-2 control-label">이메일
								: </label>
								<div class="col-sm-10">
								<input class="form-control" id="email" name="email"
								value="${currentPageAccount.email}" placeholder="이메일을 입력해주세요" />
								</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-danger" id="deleteUserBtn" style="float: left;">회원탈퇴</button>
					<button type="button" id="updateBtn" data-dismiss="modal" class="btn btn-primary">수정</button>
					<button type="button" data-dismiss="modal" class="btn">취소</button>
				</div>
			</div>
		</div>
	</div>
	
	<jsp:include page="../../resources/template/reviewElement.jsp" flush="true"></jsp:include>

</body>
</html>