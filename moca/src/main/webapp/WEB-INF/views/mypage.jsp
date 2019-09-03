<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
	<title>Home</title>
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap-theme.css"/>" />
	<style type="text/css">
		#userInfo, #followInfo{
			margin:20px auto;
			text-align: center;
			display: inline-block;
			width:100%;
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
		
		/* br태그 대신 margin */
		.reviewCnt{
			margin-bottom: 2em;
		}
		
		/* 리뷰 내용 더보기 */
		.review-data{overflow:hidden;}
     	.review-data .more-review-content.hidden{
	         white-space:nowrap;
	         word-wrap:normal;
	         width:90%;
	         overflow:hidden;
	         text-overflow: ellipsis;
	         float:left;
	      }
	    .more-review-content-btn{display:none;white-space:nowrap;float:right;}
	    
	    .reviewThumbnailGroup .reviewThumbnail{
	    	display: inline-block;
	    }
	    
	    .reviewThumbnailGroup img{
	    	width:100px;
	    	height: 100px;
			object-fit: cover;
			overflow: hidden;
	    }
	    
	    .modal-content {
		  position: relative;
		  background-color: #fefefe;
		  margin: auto;
		  padding: 0;
		  width: 90%;
		  max-width: 1200px;
		}	
		#reviewDetailDiv {
			overflow:hidden;
		  text-align: center;
		  background-color: black;
		  padding: 2px 16px;
		  color: white;
		}
		#reviewThumbnailGroup{
			text-align: center;
			background-color: black;
			padding: 2px 16px;
			color: white;
		}
		#reviewThumbnailGroup .clickedImg {
	    	border: 5px solid red;
	    }
	    /* Next & previous buttons */
		#preReviewImgBtn,
		#nextReviewImgBtn {
		  cursor: pointer;
		  position: absolute;
		  top: 50%;
		  width: auto;
		  padding: 16px;
		  margin-top: -50px;
		  font-weight: bold;
		  font-size: 20px;
		  transition: 0.6s ease;
		  border-radius: 0 3px 3px 0;
		  user-select: none;
		  -webkit-user-select: none;
		}
		
		/* Position the "next button" to the right */
		#nextReviewImgBtn{
		  right: 0;
		  border-radius: 3px 0 0 3px;
		}
		
		/*글리피콘 사이즈*/
		.glyphicon-cog{
			font-size: 2rem;
		}
		
		.popover{
			width:300px;
    		max-width: 100%;
		}
		
		#userImage{
			margin: 20px auto;
			text-align: center;
		}
		
	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> 	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- mocaReview -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaReview.js?ver=1"/>"></script>
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

	/// 접속자 아이디
	var id=1;

	var storeTemplate;
	
	$(document).ready(function() { 
		/////////////////내가 쓴글 관리 시작//////////////
		//변수 바인딩
		bindReviewVariable();
		storeTemplate = $('#storeTemplate')	//변수 바인딩

		//좋아요 또는 싫어요 버튼 클릭시
		likeHateButton.click(function(){
			bindLikeHateButtonEvent($(this));
		});

		//fileBuffer 초기화
		fileBuffer = [];

		//수정을 눌렀을 때와 입력을 눌렀을 때 파일 입력 개수의 차이
		$('#files').change(filesChange);
		
		//리뷰 3개씩 끊어서 가져오기
		$('.reviewCnt').hide();
		reviewCnt(quotient,remainder,callNum);
		
		
		//리뷰 내용 더보기 style 변화
		callReviewDataMore();

		//리뷰 더보기 버튼을 눌렀을 때
		$('#moreReview').click(function(){
				callNum += 1;
				reviewCnt(quotient,remainder,callNum);
				callReviewDataMore();
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
			var storeName = $(this).parent().parent().find('.reviewer-info').find('.storeName-div').find('.storeName').html();
			console.log(storeName);
			reviewData2ReviewModal(this,storeName);
			reviewModal.find('#saveReviewBtn').css('display','none')
			reviewModal.find('#editReviewBtn').css('display','')
			$('#reviewModal').modal("show");		//리뷰 모달창 show
						
		})
		
		//리뷰 수정 버튼 클릭시
		editReviewBtn.click(editReview);
		
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
			console.log(reviewTodelete);
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
					url: '/moca/follower/'+followId,
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
					url: '/moca/following/'+followId,
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
				url: '/moca/follow/'+followId,
				success: function() {
					//타입에 따라서 팔로잉/팔로우 텍스트 변경
					$('#followBtn').toggleClass("btn-success");
					$('#followBtn').toggleClass('btn-default');
				},
				error: function(request,status,error) {
					//타입에 따라서 에러 텍스트 변경
					if(error.includes("Locked")){
						alert('로그인을 해주세요');
					}
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
						console.log('회원 삭제 성공');
						window.location.href='/moca/'
					},
					error: function() {
						console.log('회원 삭제 실패')
						alert("탈퇴 실패")
					}
				});
				
			    //회원 탈퇴이유도 받았으면 좋겠다 (ver2)

				
			    console.log("삭제됨");
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
						//$('#userInfo').find('#email').text($('#userInfo').find('input[name=nickname]').val());
						console.log('회원정보 수정 성공');
					},
					error: function(request,status,error) {
						console.log('회원정보 수정 실패');
					}
				})
			}
		});
		
    });

	//회원정보 수정 때 userImage change되면
	var userImageChange = function(){
		const userImageUpdateInput = document.getElementById('userImageUpdateInput');
		var userImage = userImageUpdateInput.files[0];
		console.log(userImage);
		const fileName = userImage.name;
		const fileEx = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
	    if(fileEx != "jpg" && fileEx != "png" &&  fileEx != "gif" &&  fileEx != "bmp"){
	        alert("파일은 (jpg, png, gif, bmp) 형식만 등록 가능합니다.");
	        resetFile();
	        return false;
	    }

		$('#userImage').find('img').attr('src', URL.createObjectURL(userImage));
		$('#userImage').find('img').css('width','110px').css('height','110px');
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
					<button id="followBtn" class="btn btn-default" style="display:none;">팔로우</button><br>
					<span id="nickName">${currentPageAccount.nickname}</span><br>
					Lv.<span id="accountLevel">${currentPageAccount.accountLevel}</span>
					<span id="levelName">(${currentPageAccount.levelName})</span>
					<span class="glyphicon glyphicon-question-sign" aria-hidden="true"
						id="levelGuide" data-toggle="popover" title="등급제도 안내"
						data-content="8단계의 등급을 설명해요 나중에">
					</span> <br>
					<c:if test="${accountVo.isMine eq 1}">
					<div class="progress">
						<div class="progress-bar progress-bar-info" role="progressbar"
							aria-valuenow="${accountVo.exp}" aria-valuemin="${accountVo.minExp}" aria-valuemax="${accountVo.maxExp}"
							style="width: ${(accountVo.exp-accountVo.minExp)/(accountVo.maxExp)*100}%">
							<fmt:formatNumber value="${accountVo.exp/accountVo.maxExp}" type="percent"></fmt:formatNumber>
						</div>
					</div>
					</c:if>
				</div>
			</div>
			<div class="col-md-3" id="userGraph">
			
			</div>
			<div class="col-md-3" id="userBadge">
			
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
						<div class="review-content">
							<!-- js로 리뷰 수만큼 추가 할 것  -->
							<c:forEach items="${reviewVoList }" var="reviewVo">
								<div class="row reviewCnt">
									<c:if test="${reviewVo.editable eq 1}">
										<div class="editDeleteGroup btn-group" role="group">
											<input name="storeId" class="storeId" value=${reviewVo.store_id} style="display: none;">
											<input type="number" class="review-id"
												value=${reviewVo.review_id } style="display: none;">
											<button type="button" class="btn-edit btn btn-default">수정</button>
											<button type="button" class="btn-delete btn btn-default">삭제</button>
										</div>
									</c:if>
									<div class="reviewer-info col-md-2" onclick="location.href='/moca/stores/${reviewVo.store_id}'" style="cursor:pointer;">
										<div class="storeLogo-div">
											<!-- store logo 이미지 -->
											<c:if test="${empty reviewVo.storeLogoImg}">
												<img src="<c:url value="/resources/imgs/logoDefault.png"/>"
													alt="logo" class="img-circle" style="width: 100px;">
											</c:if>
											<c:if test="${not empty reviewVo.storeLogoImg}">
												<img src="<c:url value="${reviewVo.storeLogoImg }" />" alt="logo"
													class="img-circle" style="width: 100px;">
											</c:if>
										</div>
										<div class="storeName-div">
											<!-- store 이름 -->
											<span class="storeName">${reviewVo.storeName}</span>
										</div>
									</div>


									<div class="review-info col-md-8">
										<div class="row">
											<div class="reviewThumbnailGroup">
												<c:forEach items="${reviewVo.imageList}" var="reviewImg"
													varStatus="status">
													<div class="reviewThumbnail">
														<img src="${reviewImg.thumbnailUrl}" alt="Image"
															class="img-thumbnail" id="${reviewImg.uu_id}">
													</div>
												</c:forEach>
											</div>
											<div class="review-data">
												<div class="write-date-div">
													<label>작성일</label> <span class="reviewInfo-write-date">${reviewVo.writeDate }</span>
												</div>
												<div class="review-content-div">
													<label>리뷰 내용</label> <span
														class="reviewInfo-review-content more-review-content">${reviewVo.reviewContent }</span>
												</div>
												<span class="more-review-content-btn">더보기</span>
											</div>
											<div class="form-group like-hate">
												<div class="btn-group" data-toggle="buttons">
													<input type="number" class="review-id"
														value=${reviewVo.review_id } style="display: none;">
													<c:choose>
														<c:when test="${reviewVo.isLike==1 }">
															<button type="button"
																class="btn btn-primary like-btn clicked">좋아요</button>
														</c:when>
														<c:otherwise>
															<button type="button" class="btn btn-primary like-btn ">좋아요</button>
														</c:otherwise>
													</c:choose>
													<input type="number" class="like-count"
														value=${reviewVo.likeCount }>
													<c:choose>
														<c:when test="${reviewVo.isLike==-1 }">
															<button type="button"
																class="btn btn-primary hate-btn clicked">싫어요</button>
														</c:when>
														<c:otherwise>
															<button type="button" class="btn btn-primary hate-btn">싫어요</button>
														</c:otherwise>
													</c:choose>

													<input type="number" class="hate-count"
														value=${reviewVo.hateCount }>
												</div>
											</div>
										</div>
									</div>
									<div class="review-level col-md-2">
										<div class="taste-level-div">
											<label>맛</label> <span class="taste-level">${reviewVo.tasteLevel }</span>점
										</div>
										<div class="price-level-div">
											<label>가격</label> <span class="price-level">${reviewVo.priceLevel }</span>점
										</div>
										<div class="service-level-div">
											<label>서비스</label> <span class="service-level">${reviewVo.serviceLevel }</span>점
										</div>
										<div class="taste-level-div">
											<label>분위기</label> <span class="mood-level">${reviewVo.moodLevel }</span>점
										</div>
										<div class="taste-level-div">
											<label>편의성</label> <span class="convenience-level">${reviewVo.convenienceLevel }</span>점
										</div>
										<div class="taste-level-div">
											<label for="average_level">평균</label> <span
												class="average-level">${reviewVo.averageLevel }</span>점
										</div>
									</div>
									<br>
									<br>
									<br>
								</div>
							</c:forEach>
						</div>
						<div class="review-footer">
							<button id="moreReview">더보기</button>
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
	<!--followDiv  -->
	<div class="followInfo" id="followInfo">
		<img alt="basicProfile" src="<c:url value="/resources/imgs/basicProfile.png"/>" class="img-circle" style="width:10rem;"><br>
		<b><span id="nickName">별명</span></b><br>
		<small>Lv.<span id="accountLevel">3</span></small><br>
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
					<button type="button" class="btn btn-danger"
						id="deleteUserBtn" style="float: left;">회원탈퇴</button>
					<button type="button" id="updateBtn" data-dismiss="modal" class="btn btn-primary"
						>수정</button>
					<button type="button" data-dismiss="modal" class="btn">취소</button>
				</div>
			</div>
		</div>
	</div>
	
	<jsp:include page="../../resources/template/reviewModal.jsp" flush="true"></jsp:include>
</body>
</html>