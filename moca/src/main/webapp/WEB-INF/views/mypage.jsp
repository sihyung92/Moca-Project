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
	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> 	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- mocaReview -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaReview.js?ver=14"/>"></script>
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
	
	$(document).ready(function() { 
		/////////////////내가 쓴글 관리 시작//////////////
		//변수 바인딩
		bindReviewVariable();

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
						<div class="review-content">
							<!-- js로 리뷰 수만큼 추가 할 것  -->
							<c:forEach items="${reviewVoList }" var="reviewVo">
								<div class="row reviewCnt">
									<c:if test="${reviewVo.editable eq 1}">
										<div class="editDeleteGroup btn-group" role="group">
											<input name="storeId" class="storeId" value=${reviewVo.storeId} style="display: none;">
											<input type="number" class="review-id"
												value=${reviewVo.review_id } style="display: none;">
											<button type="button" class="btn-edit btn btn-default">수정</button>
											<button type="button" class="btn-delete btn btn-default">삭제</button>
										</div>
									</c:if>
									<div class="reviewer-info col-md-2">
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
	
	<jsp:include page="../../resources/template/reviewModal.jsp" flush="true"></jsp:include>
</body>
</html>
