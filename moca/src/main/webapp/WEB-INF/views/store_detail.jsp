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
	<style type="text/css">
		#likeFavoriteDiv{
			text-align: right;
		}
		#likeFavoriteDiv span{
			font-size:30px;
		}
		.carousel-inner img {
			margin: 0px auto;
		}
		
		.carousel .carousel-inner img {
			width: 100%;
			height: 20rem;
			object-fit: cover;
			overflow: hidden;
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
		
		
		/* 카페 관리자의 사진 수정 */
		.storeImgGroup  .storeImg{
	    	display: inline-block;
	    }
	    
	    .storeImgGroup  img{
	    	width:100px;
	    	height: 100px;
			object-fit: cover;
			overflow: hidden;
	    }
	    
	    .storeImgGroup .StoreImgDeleteSpan{
	    	position : relative;
	    	left:-95px;
	    	top:-30px;
	    	cursor:pointer;
	    	background-color:rgb(255,255,255,0.5);
	    }
		
}
	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> 	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- 차트 -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
	<!-- mocaReview -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaReview.js?ver=11"/>"></script>
	<!-- mocaStore -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaStore.js"/>"></script>
	<script type="text/javascript">
		//여러 파일을 가지고 있는 버퍼
		var fileBuffer;
		var fileListDiv;
		var removeThumbnailBtn;
		var newFileDiv;
		var fileBuffer;

		var likeStoreBtn;
		var favoriteStoreBtn;
		var storeId;
		var accountId;
		
		var editStoreImgsBtn;
		var storeImgswModal;
		var storeImgs;
		var toBeDeletedStoreImgUrls;
		var oldStoreImgUrls ="";
		var storeFiles; //storeImg 수정 모달에서 file input


		//나중에 삭제할 테스트 변수
		var test;

	
		$(document).ready(function() {
			//카페 변수 바인딩
			likeStoreBtn = $('#likeStoreBtn');
			favoriteStoreBtn = $('#favoriteStoreBtn');
			storeId = $('#storeId').text();
			editStoreImgsBtn = $('#editStoreImgsBtn');
			storeImgswModal = $('#storeImgswModal');
			storeFiles = $('#storeFiles');
			

			accountId = "${accountVo.account_id}" ///나중에 세션에서 값 사용
							
			//리뷰변수 바인딩
			bindReviewVariable();
			

			//리뷰 작성버튼 클릭시
 			fileBuffer = [];
		    //수정을 눌렀을 때와 입력을 눌렀을 때 파일 입력 개수의 차이
			$('#files').change(function(){
			    const target = document.getElementsByName('file');

				//이미 리뷰섬네일 그룹이 있을때 > 이미지가 있는 수정
				if($(this).next().attr('class')=='reviewThumbnailGroup'){
					fileListDiv = $(this).next();

					//이미지를 추가하는게 처음일때
					if(fileBuffer.length==0){
						//내가 이전에 올린 파일의 갯수
						maxNumForAdd = $(fileListDiv).children().find('.oldThumbnail').filter(':visible').length
					}
			    }else{//리뷰 등록 or 이미지가 없는 리뷰 수정
			    	$(this).parent().append('<div class="reviewThumbnailGroup"></div>');
			    	fileListDiv = $(this).next();

			    	//내가 이전에 올린 파일의 갯수
			    	maxNumForAdd = 0;
				}


				//파일 버퍼에 있는 파일수 + 이전에 올린 파일의 갯수가 10 이상 or  선택을 10개 이상했을때
				if((fileBuffer.length*1)+maxNumForAdd>10 || (target[0].files.length*1)>10){
					alert("파일은 10개까지만 등록가능합니다.");
					return false;
				}else{
			        //파일 버퍼에 선택한 파일을 넣는다.
			        Array.prototype.push.apply(fileBuffer, target[0].files);
			        var newFileDiv = '';

			        //선택한 파일의 인덱스와 파일
			        $.each(target[0].files, function(index, file){
			            const fileName = file.name;
			            newFileDiv += '<div class="file newThumbnail reviewThumbnail" style="width:121px">';
			            newFileDiv += '<img src="'+URL.createObjectURL(file)+'" alt="Image">'
			            newFileDiv += '<span class="glyphicon glyphicon-remove removeThumbnailBtn"onclick="deleteReviewImg(this)" aria-hidden="true" style="position:relative; left:-95px; top:-30px; cursor:pointer; background-color:rgb(255,255,255,0.5);"></span>';
			            newFileDiv += '</div>';
			            const fileEx = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
			            if(fileEx != "jpg" && fileEx != "png" &&  fileEx != "gif" &&  fileEx != "bmp"){
			                alert("파일은 (jpg, png, gif, bmp) 형식만 등록 가능합니다.");
			                resetFile();
			                return false;
			            }
			        });
				}
		        
//		        $(fileListDiv).html($(fileListDiv).html()+newFileDiv);
		        $(fileListDiv).append(newFileDiv);
			    if((fileBuffer.length*1)+maxNumForAdd>10){
					alert("파일은 10개까지만 등록가능합니다.");
					//10개가 넘은 경우 넘은 파일 입력된 이미지랑 filebuffer에서 삭제
					$.each(target[0].files, function(index, file){
						var num = 0;
						if(index==0){
							num = fileBuffer.length-index;
						}
						fileBuffer.splice(fileBuffer.length-1, 1);
						$('#files').next().children().last().remove();
					});
				}
				
		 
		    });

			
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

			//리뷰 3개씩 끊어서 가져오기
			$('.reviewCnt').hide();
			reviewCnt(quotient,remainder,callNum);
	         
			//리뷰 내용 더보기 style 변화
			callReviewDataMore();
			
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

			//storeInfo 참여하기 버튼 클릭시
			$('#updateStore').click(function() {
				$(this).attr('data-dismiss', "modal");
				updateStore(${storeVo.store_Id});
			});

			//리뷰 더보기 버튼을 눌렀을 때
			$('#moreReview').click(function(){
					callNum += 1;
					//console.log("더보기"+quotient+":"+remainder+":"+callNum);
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
				reviewData2ReviewModal(this);
				reviewModal.find('#saveReviewBtn').css('display','none')
				reviewModal.find('#editReviewBtn').css('display','')
				$('#reviewModal').modal("show");		//리뷰 모달창 show
							
			})
			
			
			//리뷰 수정 버튼 클릭시
			editReviewBtn.click(function(){
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
				console.log(reviewTodelete);
				$('#confirm').modal({ backdrop: 'static', keyboard: false })
		        .one('click', '#delete', function() {
		        	reviewTodelete.remove();
					deleteReview(reviewId);
		        });
			})

			//StoreImg 클래스 일 때 '카페에서 등록한 이미지 입니다'
			$('.StoreImg').append('<span>카페에서 등록한 이미지 입니다</span>');


			//리뷰 디테일 모달
			reviewImg.click(function(){
				//모달 활성화(+초기화)
				reviewsDetailModal.modal("show");
				

				//섬네일 url > 원본 url
				showDetailReviewImg(this);

				
				//데이터 값 전송
				
			})

			$('#preReviewImgBtn').click(function(){
				if(detailImgIdx > 0){
					detailImgIdx =detailImgIdx-1;
				}else{
					detailImgIdx = 0;
				}
				showDetailReviewImg(reviewThumbnailGroup.find('img').eq(detailImgIdx)[0]);
				
			})

			$('#nextReviewImgBtn').click(function(){
				if(detailImgIdx < detailImgsSize-1){
					detailImgIdx =detailImgIdx+1;
				}else{
					detailImgIdx = detailImgsSize-1;
				}
				showDetailReviewImg(reviewThumbnailGroup.find('img').eq(detailImgIdx)[0]);
			})

			
			
			likeStoreBtn.click(function(){
				//좋아요를 누르지 않은 경우
				if(likeStoreBtn.hasClass('glyphicon-heart-empty')){

					//좋아요 추가
					$.ajax({
						type: 'POST',
						url: '/moca/likeStore/' + accountId,
						data : {
							storeId : storeId
						},
						success: function() {
							likeStoreBtn.removeClass('glyphicon-heart-empty')
							likeStoreBtn.addClass('glyphicon-heart')
							
						},
						error: function() {

						}
					})		

				}else{//좋아요를 누른경우

					//좋아요에서 삭제
					$.ajax({
						type: 'DELETE',
						url: '/moca/likeStore/' + accountId,
						data : {
							storeId : storeId
						},
						success: function() {
							likeStoreBtn.removeClass('glyphicon-heart')
							likeStoreBtn.addClass('glyphicon-heart-empty')
							
						},
						error: function() {

						}
					})

				}

			})

			favoriteStoreBtn.click(function(){
				//즐겨찾기를 누르지 않은 경우
				if(favoriteStoreBtn.hasClass('glyphicon-star-empty')){

					//즐겨 찾기에 추가
					$.ajax({
						type: 'POST',
						url: '/moca/favoriteStore/' + accountId,
						data : {
							storeId : storeId
						},
						success: function() {
							favoriteStoreBtn.removeClass('glyphicon-star-empty')
							favoriteStoreBtn.addClass('glyphicon-star')
							
						},
						error: function() {
						}
					})

					

				}else{//즐겨찾기를 누른경우

					//즐겨 찾기에서 삭제
					$.ajax({
						type: 'DELETE',
						url: '/moca/favoriteStore/' + accountId,
						data : {
							storeId : storeId
						},
						success: function() {
							favoriteStoreBtn.removeClass('glyphicon-star')
							favoriteStoreBtn.addClass('glyphicon-star-empty')
							
						},
						error: function() {
						}
					})

					
				}
			})

			editStoreImgsBtn.click(function(){
				storeImgswModal.modal("show");

				//삭제될 카페 이미지 주소 초기화
				toBeDeletedStoreImgUrls = ""

				//파일 버퍼 초기화
				fileBuffer = [];

				//카페에서 등록된 이미지
				storeImgs = $('.StoreImg');

				//내용 비워줌
				$('.storeImgGroup').html("")

				//카페에서 등록한 이미지를 모달로
				for(var idx=0; idx<storeImgs.size() ; idx++){
					var oldStoreImg = $('#storeImgTemplate').clone('true');
					oldStoreImg.removeAttr('id')
					oldStoreImg.find('img').addClass('oldStoreImg')
					oldStoreImg.find('img').attr('src', storeImgs[idx].getElementsByTagName('img')[0].src );
					$('.storeImgGroup').append(oldStoreImg)
				}

				//기존의 클릭이벤트 제거
				$('.StoreImgDeleteSpan').unbind();
				$('.StoreImgDeleteSpan').click(function(){					
					
					test = this;
					//newStoreImg인 경우 
					if($(this.previousElementSibling).hasClass('newStoreImg')){
						//fileBuffer에서 제거
						//fileBuffer에서 제거할 newStoreImg의 index = 제거한 이미지의 index - oldStoreImg의 갯수
						fileBuffer.splice($(this).parent().index()-$('.oldStoreImg').size(),1);
					}else{// oldStoreImg인 경우
						//삭제될 이미지 url에 추가
						toBeDeletedStoreImgUrls = toBeDeletedStoreImgUrls +","+ this.previousElementSibling.src
					}
					
					//해당 img를 포함하는 div 삭제
					this.parentElement.remove();					
					
				})
				
			})

			storeFiles.change(function(){
				var target = document.getElementById('storeFiles');

				//가지고 온 갯수를 통해 최대 갯수비교
				var storeImgSize = $('.storeImgGroup .storeImg').size();

				//3개 이상인지 체크
				if(target.files.length +storeImgSize >3){
					alert("파일은 3개까지만 등록가능합니다.");
					return false;
				}

				//확장자 체크
				for(var i=0; i<target.files.length ; i++){
					var fileName = target.files[i].name
					var fileEx = fileName.slice(fileName.indexOf(".")+1).toLowerCase()
					
					//이미지 형식인 경우만 받아 들임
					if(fileEx != "jpg" && fileEx != "png" &&  fileEx != "gif" &&  fileEx != "bmp"){
		                alert("파일은 (jpg, png, gif, bmp) 형식만 등록 가능합니다.");
		                return false;
		            }
				}

				//fileBuffer에 추가 
				Array.prototype.push.apply(fileBuffer, target.files);
				
				$.each(target.files, function(index, file){
					URL.createObjectURL(file)
					var fileName = file.name;
					var newStoreImg = $('#storeImgTemplate').clone('true');
					newStoreImg.find('img').addClass('newStoreImg')
					newStoreImg.removeAttr('id')
					newStoreImg.find('img').attr('src', URL.createObjectURL(file));
					$('.storeImgGroup').append(newStoreImg)
				})
				
			})

			//수정 버튼을 눌렀을때
			$('#editStoreImgBtn').click(function(){
				//oldStoreImg
				var oldStoreImgs = $('.oldStoreImg')
				for(var i=0 ; i < oldStoreImgs.length; i++){
					oldStoreImgUrls = oldStoreImgUrls + ","+oldStoreImgs[0].src
				}
				
				//맨 앞에 , 문자 제거
				toBeDeletedStoreImgUrls = toBeDeletedStoreImgUrls.substring(1);
				oldStoreImgUrls = oldStoreImgUrls.substring(1);
				console.log(fileBuffer,toBeDeletedStoreImgUrls )
				editStoreImg();
			})

		});
		/*
		$('#files').focus(function(e){
			if((fileBuffer.length*1)>10 || (target[0].files.length*1)>10){
				e.preventDefault();
				e.stopPropagation();
			alert("파일은 10개까지만 등록가능합니다.");
		}
 		});
		*/

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
						<span id="storeId" style= "display: none;">${storeVo.store_Id }</span>
						<div id="likeFavoriteDiv">
							<c:if test="${storeVo.isLike eq 0 }">
								좋아요<span id="likeStoreBtn" class="glyphicon glyphicon-heart-empty" aria-hidden="true" ></span>
							</c:if>
							<c:if test="${storeVo.isLike ne 0 }">
								좋아요<span id="likeStoreBtn" class="glyphicon glyphicon-heart" aria-hidden="true" ></span>
							</c:if>
						
							<c:if test="${storeVo.isFavorite eq 0 }">
								즐겨찾기<span id="favoriteStoreBtn" class="glyphicon glyphicon-star-empty" aria-hidden="true" ></span>	
							</c:if>
							<c:if test="${storeVo.isFavorite ne 0 }">
								즐겨찾기<span id="favoriteStoreBtn" class="glyphicon glyphicon-star" aria-hidden="true" ></span>	
							</c:if>					
						</div>

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
						<c:if test="${storeVo.isManager eq 1}">
							<span>내가 관리하는 카페 입니다.</span>						
						</c:if>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-4 col-md-offset-2">
					<!-- 갖고있는 이미지의 개수만큼  캐러셀 시작-->
					<div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
						<!-- Indicators -->
						<ol class="carousel-indicators">
							<c:forEach items="${StoreImgList}" var="StoreImg" varStatus="status">
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
								<c:if test="${not empty StoreImgList}">
									<c:forEach items="${StoreImgList}" var="StoreImg" varStatus="status">
										<c:if test="${status.index eq 0}">
											<div class="item active <c:if test="${StoreImg.path eq 'store'}"><c:out value="StoreImg"></c:out></c:if>" >
										</c:if>
										<c:if test="${status.index ne 0}">
											<div class="item <c:if test="${StoreImg.path eq 'store'}"><c:out value="StoreImg"></c:out></c:if>" >
										</c:if>
										<img src="<c:url value="${StoreImg.url }" />" alt="..." class="d-block w-100">
										<div class="carousel-caption">...</div>
							</div>
							</c:forEach>
							</c:if>
							<c:if test="${empty StoreImgList}">
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
				<c:if test="${storeVo.isManager eq 1}">
					<button id="editStoreImgsBtn">수정</button>
				</c:if>
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
								<small id="lastInfoUpdate" style="display:block; margin-top:1em; color:lightgray;">
								<i>
									${storeInfoHistory}
								</i>
								</small>
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
					<button type="button" class="btn btn-primary" data-toggle="modal" id="reviewModalBtn">
						리뷰 작성
					</button>
					<br><br>
				</div>
				<div class="review-content">
					<!-- js로 리뷰 수만큼 추가 할 것  -->
					<c:forEach items="${reviewVoList }" var="reviewVo">
						<div class="row reviewCnt">
							<c:if test="${reviewVo.editable eq 1}">
								<div class="editDeleteGroup btn-group" role="group">
									<input type="number" class="review-id" value=${reviewVo.review_id } style="display: none;">
									<button type="button" class="btn-edit btn btn-default">수정</button>
									<button type="button" class="btn-delete btn btn-default">삭제</button>
								</div>
							</c:if>
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
								<div class="row">
									<div class="reviewThumbnailGroup">
										<c:forEach items="${reviewVo.imageList}" var="reviewImg" varStatus="status">
											<div class="reviewThumbnail">
												<img src="${reviewImg.thumbnailUrl}" alt="Image" class="img-thumbnail" id="${reviewImg.uu_id}">
											</div>
										</c:forEach>
									</div>
									<div class="review-data">
									<div class="write-date-div">
										<label>작성일</label>
										<span class="reviewInfo-write-date">${reviewVo.writeDate }</span>
									</div>
									<div class="review-content-div">
										<label>리뷰 내용</label>
										<span class="reviewInfo-review-content more-review-content">${reviewVo.reviewContent }</span>
									</div>
									<span class="more-review-content-btn">더보기</span>
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
							</div>
							<div class="review-level col-md-2">
								<div class="taste-level-div">
									<label>맛</label>
									<span class="taste-level">${reviewVo.tasteLevel }</span>점
								</div>
								<div class="price-level-div">
									<label>가격</label>
									<span class="price-level">${reviewVo.priceLevel }</span>점
								</div>
								<div class="service-level-div">
									<label>서비스</label>
									<span class="service-level">${reviewVo.serviceLevel }</span>점
								</div>
								<div class="taste-level-div">
									<label>분위기</label>
									<span class="mood-level">${reviewVo.moodLevel }</span>점
								</div>
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
					<button id="moreReview">더보기</button>
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
			<input type="number" style="display: none;" class="review-id" >
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
			<div class="reviewThumbnailGroup">
			</div>
			<div class="review-data">
				<div class="write-date-div">
					<label>작성일</label>
					<span class="reviewInfo-write-date"></span>
				</div>
				<div class="review-content-div">
					<label>리뷰 내용</label>
					<span class="reviewInfo-review-content"></span>
				</div>
				<span class="more-review-content-btn">더보기</span>
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
				<span class="taste-level"></span>점
			</div>
			<div class="price-level-div">
				<label>가격</label>
				<span class="price-level"></span>점
			</div>
			<div class="service-level-div">
				<label>서비스</label>
				<span class="service-level"></span>점
			</div>
			<div class="taste-level-div">
				<label>분위기</label>
				<span class="mood-level"></span>점
			</div>
			<div class="taste-level-div">
				<label>편의성</label>
				<span class="convenience-level"></span>점
			</div>
			<div class="taste-level-div">
				<label for="average_level">평균</label>
				<span class="average-level"></span >점
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
							<!-- <input type="file" name="file" id="picture-file" multiple="multiple"> --><!-- 다중으로 입력 하는 방법을 생각해야 할듯 -->
							<input multiple="multiple" name="file" id="files" type="file"/>
							
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
	
	<!-- 삭제 확인 모달 -->
	<div id="confirm" class="modal fade" aria-hidden="true" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" >
		<div class="modal-dialog" role="document">
			<div class="modal-content">
		<div class="modal-body">정말 삭제하시겠습니까?</div>
		<div class="modal-footer">
			<button type="button" data-dismiss="modal" class="btn btn-danger"
				id="delete">삭제</button>
			<button type="button" data-dismiss="modal" class="btn">취소</button>
		</div>
		</div>
		</div>
	</div>
	
	<!-- 리뷰 이미지 디테일 -->
	<div id="reviewsDetailModal" class="modal fade" tabindex="-1">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	      </div>
	      <div id= "reviewDetailDiv" class="modal-body">
	        <p>원본 이미지</p>
	      </div>
	      
	      
	      <div class="leftRightBtns">
	        <button id="preReviewImgBtn" type="button" class="btn btn-default" aria-label="Left Align">
			  <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
			</button>
	        <button id="nextReviewImgBtn" type="button" class="btn btn-default" aria-label="Left Align">
			  <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
			</button>
			<div id="reviewThumbnailGroup" class="reviewThumbnailGroup">
				
			</div>
	      </div>
	    </div><!-- /.modal-content -->
	</div><!-- /.modal -->
	
	
	<c:if test="${storeVo.isManager eq 1}">
		<!-- 카페 Manager 모달 -->
		<div class="modal fade" id="storeImgswModal" tabindex="-1" role="dialog" aria-labelledby="reviewModalLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">
							${storeVo.name} 사진 수정</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body" data-role="content">
						<form id="storeImgForm">
							<input name="storeId" value=${storeVo.store_Id } style="display:none;" >
							<input name="managerId" value=${accountVo.account_id } style="display:none;" >
							<div class="form-group">
								<label for="picture-file">사진 선택</label>
								<input multiple="multiple" name="storeFiles" id="storeFiles" type="file"/>
							</div>
							<div class="storeImgGroup">
							
							</div>
							<input type="hidden" class="delStoreImg"  name="delStoreImg"/>
							<input type="hidden" class="oldStoreImg"  name="oldStoreImg"/>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
						<button type="button" class="btn btn-primary" id="editStoreImgBtn">수정</button>
					</div>
				</div>
			</div>
		</div>	
		
		<!-- storeImg clone -->
		<div class="storeImg" id="storeImgTemplate">
			<img alt="Image">
			<span class="glyphicon glyphicon-remove StoreImgDeleteSpan" aria-hidden="true"></span>
		</div>
						
	</c:if>
	<span id="accountId" style="display : none;">${accountVo.account_id }</span>
</body>

</html>
