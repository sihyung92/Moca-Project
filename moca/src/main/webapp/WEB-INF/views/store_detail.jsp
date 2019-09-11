<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>moca</title>
	<link href="https://fonts.googleapis.com/css?family=Nanum+Gothic|Noto+Sans+KR&display=swap" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/bootstrap-theme.css"/>" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/review.css"/>" />
	<style type="text/css">
		body{
			font-family: 'Noto Sans KR', sans-serif;
		}
		#likeFavoriteDiv{
			text-align: right;
		}
		#likeFavoriteDiv span{
			font-size:30px;
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
	    
	    .storeImgGroup .storeImgDeleteSpan{
	    	position : relative;
	    	left:-95px;
	    	top:-30px;
	    	cursor:pointer;
	    	background-color:rgb(255,255,255,0.5);
	    }
	    
	    /* 카페 관리자의 사진 수정 */
		.storeLogoGroup  .storeImg{
	    	display: inline-block;
	    }
	    
	    .storeLogoGroup  img{
	    	width:100px;
	    	height: 100px;
			object-fit: cover;
			overflow: hidden;
	    }
	    
	    .storeLogoGroup .storeImgDeleteSpan{
	    	position : relative;
	    	left:-95px;
	    	top:-30px;
	    	cursor:pointer;
	    	background-color:rgb(255,255,255,0.5);
	    }
	    
	    .levelGroup{
	    	margin:20px auto;
	    	text-align: center;
	    	width:100%;
	    }
		.levelGroup tr{
			width:100%;
			height:30px;
			line-height: 30px;
		}
		.levelGroup td{
			width:20%;
		}
		.review-header{
			background-color: #fffff5;
			padding: 20px;
			border-radius: 10px 20px;
			margin: 10px 0px;
		}
		#overAllLevel{
			text-align: center;
			height: 100%;
		}
		.overAllLevel-left .overAllLevel-right{
			margin-top: 30px;
		}
		#reviewModalBtn{
			text-align: center;
			margin: 30px auto;
			width:50%;
		}
<<<<<<< HEAD
		.progress-label {
		  float: left;
		  margin-right: 1em;
		}
		
		
		/*케러셀 부분*/
		.carousel-inner img {
			margin: 0px auto;
		}
		
		.carousel .carousel-inner img {
			width: 100%;
			height: 40rem;
			object-fit: cover;
			overflow: hidden;
		}
		
		#carousel-custom {
		    margin: 20px auto;
		    width: 100%;
		}
		
		#carousel-custom .carousel-indicators {
		    margin: 10px 0 0;
		    overflow: auto;
		    position: static;
		    text-align: left;
		    white-space: nowrap;
		    width: 100%;
		}
		
		#carousel-custom .carousel-indicators li {
		    background-color: transparent;
		    -webkit-border-radius: 0;
		    border-radius: 0;
		    display: inline-block;
		    height: auto;
		    margin: 0 !important;
		    width: auto;
		}
		#carousel-custom .carousel-indicators li img {
			width: 100px;
		    display: block;
		    opacity: 0.5;
		}
		#carousel-custom .carousel-indicators li.active img {
		    opacity: 1;
		}
		#carousel-custom .carousel-indicators li:hover img {
		    opacity: 0.75;
		}
		#carousel-custom .carousel-outer {
		    position: relative;
=======
		
		#storeAverageLevel{
			display : inline;
		}
		
		#storeSummaryDiv{
			font-size : 150%;
>>>>>>> 7cdbd310b6dbe760020fa4c3f8ad241f56ca8dc1
		}
}
	</style>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery-1.12.4.min.js"/>"> </script> 
	<script type="text/javascript" src="<c:url value="/resources/js/bootstrap.min.js"/>"> </script> 	
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f2a5eb7ec5f8dd26e0ee0fbf1c68a6fc&libraries=services"></script>
	<!-- 차트 -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>
	<!-- mocaReview -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaReview.js?ver=36"/>"></script>
	<!-- mocaStore -->
	<script type="text/javascript" src="<c:url value="/resources/js/mocaStore.js?ver=19"/>"></script>
	<script type="text/javascript" src="<c:url value="/resources/js/jquery.raty.js"/>"></script>
	<script type="text/javascript">
		//여러 파일을 가지고 있는 버퍼
		var fileBuffer;
		var fileListDiv;
		var removeThumbnailBtn;
		var newFileDiv;

		var methodType;	//ajax 통신에서 메서드 타입
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

		var toBeDeletedStoreLogoUrl ="";


		//나중에 삭제할 테스트 변수
		var test;

		var startLevel;

		$(document).ready(function() { 
			$(document).error(function(){
				console.log("오류");
			}); 
        }); 
	
		$(document).ready(function() {
			//카페 변수 바인딩
			likeStoreBtn = $('#likeStoreBtn');
			favoriteStoreBtn = $('#favoriteStoreBtn');
			storeId = $('#storeId').text();
			editStoreImgsBtn = $('#editStoreImgsBtn');
			storeImgswModal = $('#storeImgswModal');
			storeFiles = $('#storeFiles');

			bindRaty();
			$('#storeAverageLevel').raty({
				half : true,
				readOnly:   true,
				scoreName:  'storeAverageLevel',
				start : ${storeVo.averageLevel}
			});

			accountId = "${accountVo.account_id}" ///나중에 세션에서 값 사용
							
			//리뷰변수 바인딩
			bindReviewVariable();
			

			//리뷰 작성버튼 클릭시
 			fileBuffer = [];
		    $('#files').change(filesChange);
			
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
			likeHateButton.click(function(){
				bindLikeHateButtonEvent($(this));
			});
	         
			//리뷰 내용 더보기 style 변화
			callReviewDataMore();

			//storeInfo 참여하기 버튼 클릭시
			$('#updateStore').click(function() {
				$(this).attr('data-dismiss', "modal");
				updateStore(${storeVo.store_Id});
			});

			//리뷰 더보기 버튼을 눌렀을 때
			$('#moreReview').click(function(){
				if(reviewVoListLength==true){
					return false;
				}
				reviewMoreBtnClick('store');
			});

			//리뷰 저장 버튼 클릭시
			$(saveReviewBtn).click(function() {
				if(isCheckLevel()){
					tagCheckboxData2Tags();
					saveReview(fileBuffer);
				}else{
					alert("별점을 입력해주세요 ^0^")
				}
			})
			
			//수정 버튼 클릭시
			editBtn.click(function(){
				
				//파일 버퍼 내용 비우기
				fileBuffer = [];
				
				//리뷰 내용을 리뷰 모달로 옴기고 창 띄움
				reviewData2ReviewModal(this);
				
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

				initReviewLevel();

				transReviewAddMode();

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
			})

			//StoreImg 클래스 일 때 '카페에서 등록한 이미지 입니다'
			$('.StoreImg').append('<span>카페에서 등록한 이미지 입니다</span>');


			//리뷰 이미지 디테일 모달
			reviewImg.click(function(){
				//모달 활성화(+초기화)
				reviewsDetailModal.modal("show");

				//섬네일 url > 원본 url
				showDetailReviewImg(this);

				
				//데이터 값 전송
				
			})
			
			/////////////////////////////
			//store 대표 이미지 케러셀
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

			
			///////////////////////
			//카페 좋아요
			likeStoreBtn.click(function(){
				
				//좋아요를 누르지 않은 경우
				if(likeStoreBtn.hasClass('glyphicon-heart-empty')){
					//좋아요 추가
					methodType = 'POST';
					
				}else{//이전에 좋아요를 누른경우
					//좋아요에서 삭제
					methodType = 'DELETE';
					
				}

				$.ajax({
					type: methodType,
					url: '/moca/likeStore/' + accountId,
					data : {
						storeId : storeId
					},
					success: function() {
						likeStoreBtn.toggleClass('glyphicon-heart');
						likeStoreBtn.toggleClass('glyphicon-heart-empty')

						if(methodType == 'POST'){
							$('#storeLikeCount').text($('#storeLikeCount').text()*1+1)
						}else if(methodType == 'DELETE'){
							$('#storeLikeCount').text($('#storeLikeCount').text()*1-1)
						}
						
					},
					error: function(request,status,error) {
						respondHttpStatus(request.status);
					}
				})

			})

			////////////////////////////////
			//가고 싶은 카페
			favoriteStoreBtn.click(function(){
				//가고 싶은 카페 누르지 않은 경우
				if(favoriteStoreBtn.hasClass('glyphicon-star-empty')){
					//가고 싶은 카페에 추가
					methodType = 'POST';
					
				}else{//이전에 가고 싶은 카페를 누를 경우
					//가고 싶은 카페에서 삭제	
					methodType = 'DELETE';
								
				}
				$.ajax({
					type: methodType,
					url: '/moca/favoriteStore/' + accountId,
					data : {
						storeId : storeId
					},
					success: function() {
						favoriteStoreBtn.toggleClass('glyphicon-star')
						favoriteStoreBtn.toggleClass('glyphicon-star-empty')

						if(methodType == 'POST'){
							$('#storeFavoriteCount').text($('#storeFavoriteCount').text()*1+1)
						}else if(methodType == 'DELETE'){
							$('#storeFavoriteCount').text($('#storeFavoriteCount').text()*1-1)
						}
						
					},
					error: function(request,status,error) {
						respondHttpStatus(request.status);
					}
				})
			})
			
			//로고 아래에 있는 수정 버튼 클릭시
			$('#showEditStoreLogoBtn').click(function(){
				$('#storeLogowModal').modal("show");		

				//내용 비워줌
				$('.storeLogoGroup').html("")
				toBeDeletedStoreLogoUrl ="";

				//섬네일로 사용할 엘리먼트 클론
				var oldStoreLogo = $('#storeImgTemplate').clone('true');
				oldStoreLogo.removeAttr('id');
				oldStoreLogo.find('img').addClass('oldStoreLogo');
				oldStoreLogo.find('img').attr('src', $('#storeLogo')[0].src );
				$('.storeLogoGroup').append(oldStoreLogo);

				//기존의 클릭이벤트 재설정
				$('.storeImgDeleteSpan').unbind();
				$('.storeImgDeleteSpan').click(function(){					
					
					//기존 StoreLogo인 경우 
					if($(this.previousElementSibling).hasClass('oldStoreLogo')){
						toBeDeletedStoreLogoUrl = this.previousElementSibling.src
					}
					
					//해당 img를 포함하는 div 삭제
					this.parentElement.remove();					
					
				})
			})
			
			//로고 수정을 위한 모달에 있는 파일 선택을 누른경우
			$('#storeLogoFile').change(function(){
				var target = document.getElementById('storeLogoFile');

				// 저장된 로고에서 변경한 경우
				if($('.storeLogoGroup').find('img').hasClass('oldStoreLogo')){
					toBeDeletedStoreLogoUrl = $('.storeLogoGroup').find('img')[0].src
				}

				//내용 비워줌
				$('.storeLogoGroup').html("")

				//확장자 체크
				for(var i=0; i<target.files.length ; i++){
					var fileName = target.files[i].name
					var fileEx = fileName.slice(fileName.lastIndexOf(".")+1).toLowerCase()
					
					//이미지 형식인 경우만 받아 들임
					if(fileEx != "jpg" && fileEx != "png" &&  fileEx != "gif" &&  fileEx != "bmp"){
		                alert("파일은 (jpg, png, gif, bmp) 형식만 등록 가능합니다.");
		                return false;
		            }
				}
				
				$.each(target.files, function(index, file){
					URL.createObjectURL(file)
					var fileName = file.name;
					var newStoreLogo = $('#storeImgTemplate').clone('true');
					newStoreLogo.find('img').addClass('newStoreLogo')
					newStoreLogo.removeAttr('id')
					newStoreLogo.find('img').attr('src', URL.createObjectURL(file));
					$('.storeLogoGroup').append(newStoreLogo)
				})
				
			})
			
			//카페 로고 모달에서 수정 버튼 클릭시
			$('#editStoreLogoBtn').click(function(){
				//카페 이미지 로고 수정
				editStoreLogo()
			})

			
			//카페 대표 이미지 하단에 있는 수정 버튼 클릭시
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
				$('.storeImgDeleteSpan').unbind();
				$('.storeImgDeleteSpan').click(function(){					
					
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
					var fileEx = fileName.slice(fileName.lastIndexOf(".")+1).toLowerCase()
					
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
					oldStoreImgUrls = oldStoreImgUrls + "," + oldStoreImgs[i].src
				}
				
				//맨 앞에 , 문자 제거
				toBeDeletedStoreImgUrls = toBeDeletedStoreImgUrls.substring(1);
				oldStoreImgUrls = oldStoreImgUrls.substring(1);
				editStoreImg();
			})

			//평점을 입력 했을때 -> 평점 대로 5가지 점수를 메김
			$('#level').change(function(){
				$('.storeLevel').css('display','')
				$('.level').css('display','none')
				$('.storeLevel').find('select').val($('#level').val())
			})

			//스토어 review 전체 평균 별점
			 $('#store-level').raty({
				  half:true,
				  readOnly:  true,
				  size:       24,
				  starHalf:   'star-half-big.png',
				  starOff:    'star-off-big.png',
				  starOn:     'star-on-big.png',
				  start: ${storeVo.averageLevel}
			 });

			//스토어 5개의 막대바
			var levelCntVal = [${storeVo.level5Cnt}, ${storeVo.level4Cnt}, ${storeVo.level3Cnt}, ${storeVo.level2Cnt}, ${storeVo.level1Cnt}];
			new Chart(document.getElementById("bar-chart-horizontal"), {
			    type: 'horizontalBar',
			    data: {
			      labels: ["5", "4", "3", "2", "1"],
			      datasets: [
			        {
			          backgroundColor: ["#C6A153", "#C6A153","#C6A153","#C6A153","#C6A153"],
			          borderWidth : 0,
			          data: levelCntVal
			        }
			      ]
			    },
			    options: {
			      legend: { display: false },
			      scales: {
			    	    xAxes: [
			    	      {
			    	    	ticks: {
			    	    		beginAtZero: true,
			                    display: false,
			                    max: levelCntVal[0]+levelCntVal[1]+levelCntVal[2]+levelCntVal[3]+levelCntVal[4],
			                },
			    	        gridLines: {
			    	        	 color: 'rgba(0,0,0,0)'
			    	        }
			    	      }
			    	    ],
			    	    yAxes: [
			    	      {
			    	    	barThickness : 15,
			    	        gridLines: {
			    	          color: 'rgba(0,0,0,0)'
			    	        },
			    	        ticks: {
			    	          beginAtZero: true
			    	        }
			    	      }
			    	    ]
			    	  },
			      title: {
			        display: true,
			      },
			      gridLines: {
			          display: false
			      }
			    }
			});

		});

		//카페 이미지 로고 수정
		var editStoreLogo = function(){
			//delete한 썸네일 추가
			$('#delStoreLogo').val(toBeDeletedStoreLogoUrl);
			
			//파일 추가
			var form = $('#storeLogoForm')[0];

			var storeImgFormData = new FormData(form);
			
			storeImgFormData.delete('file');
			
			
			var storeImgFormObj = $(form).serializeObject();
			
			if(storeImgFormObj.delStoreLogo == ""){
				return false;
			}
			

			//ajax 통신 - post방식으로 추가
			$.ajax({
				type: 'POST',
				url: '/moca/storeLogo/'+storeImgFormObj.storeId,
				enctype : 'multipart/form-data',
				data: storeImgFormData,
				dataType : "json",
				contentType : false,  
				processData : false,
				cache : false,
				timeout : 600000,
				success: function(storeVo) {
					console.log('ajax 통신 성공');
					
					location.reload();
					
				},
				error: function(request,status,error) {
					respondHttpStatus(request.status);
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
								가고 싶은 카페<span id="favoriteStoreBtn" class="glyphicon glyphicon-star-empty" aria-hidden="true" ></span>	
							</c:if>
							<c:if test="${storeVo.isFavorite ne 0 }">
								가고 싶은 카페<span id="favoriteStoreBtn" class="glyphicon glyphicon-star" aria-hidden="true" ></span>	
							</c:if>					
						</div>

						<div id="storeTagDiv">
							<!-- 태그 -->
							<c:set var="tags" value="${fn:split(storeVo.tag,'#')}" />
							<c:forEach items="${tags}" var="tag">
								<c:if test="${tag ne ''}">
									<button type="button" class="btn btn-default btn-sm">#${tag}</button>
								</c:if>
							</c:forEach>
						</div>
						
						<!-- 로고 & 카페이름-->
						<!-- 이미지 호스팅 할 건지, 데이터 베이스에 넣을건지 -->
						<h1>
							<c:if test="${empty storeVo.logoImg}">
								<img id="storeLogo" src="<c:url value="/resources/imgs/logoDefault.png"/>" alt="logo" class="img-circle" style="width:100px; height:100px;">
							</c:if>
							<c:if test="${not empty storeVo.logoImg}">
								<img id="storeLogo" src="<c:url value="${storeVo.logoImg }" />" alt="logo" class="img-circle" style="width:100px; height:100px;">
							</c:if>
							&nbsp;${storeVo.name}
						</h1>
						<c:if test="${storeVo.isManager eq 1}">
							<button id="showEditStoreLogoBtn">수정</button>
							<span>내가 관리하는 카페 입니다.</span>	
												
						</c:if>
					</div>
				</div>
			</div>
<<<<<<< HEAD
			
=======
			<div id="storeSummaryDiv">
				<div class="row">
					<div class="col-md-2 col-md-offset-2">
						<div id="storeAverageLevelDiv">
							<div id="storeAverageLevel"></div><span>${storeVo.averageLevel}</span>
						</div>
					</div>
					<div class="col-md-2">
						<div id="storeReviewCountDiv">
							<span class="storeReviewCount">${storeVo.reviewCnt}</span>개의 리뷰
						</div>
					</div>
					<div class="col-md-2">
						<div id="storeLikeCountDiv">
							<span id="storeLikeCount">${storeVo.likeCnt}</span>명이 좋아하는
						</div>
					</div>
					<div class="col-md-2">
						<div id="storeFavoriteCountDiv">
							<span id="storeFavoriteCount">${storeVo.favoriteCnt}</span>명이 가고 싶어하는
						</div>
					</div>
				</div>
				<br><br>
			</div>
>>>>>>> 7cdbd310b6dbe760020fa4c3f8ad241f56ca8dc1
			<div class="row">
				<div class="col-md-8 col-md-offset-2">
					<!-- 갖고있는 이미지의 개수만큼  캐러셀 시작-->						

					<div id='carousel-custom' class='carousel slide' data-ride='carousel'>
					    <div class='carousel-outer'>
					        <!-- Wrapper for slides -->
					        <div class='carousel-inner'>
								<c:if test="${not empty StoreImgList}">
									<c:forEach items="${StoreImgList}" var="StoreImg" varStatus="status">
										<c:if test="${status.index eq 0}">
											<div class="item active <c:if test="${StoreImg.path eq 'store'}"><c:out value="StoreImg"></c:out></c:if>" >
										</c:if>
										<c:if test="${status.index ne 0}">
											<div class="item <c:if test="${StoreImg.path eq 'store'}"><c:out value="StoreImg"></c:out></c:if>" >
										</c:if>
										<img src="<c:url value="${StoreImg.url }" />" alt="..." class="d-block w-100">
							</div>
							</c:forEach>
							</c:if>
							<c:if test="${empty StoreImgList}">
								<img src="<c:url value="/resources/imgs/reviewDefault.png"/>" alt="..." class="d-block w-100">
							</c:if>
						

						<!-- Controls -->
				        <a class='left carousel-control' href='#carousel-custom' data-slide='prev'>
				            <span class='glyphicon glyphicon-chevron-left'></span>
				        </a>
				        <a class='right carousel-control' href='#carousel-custom' data-slide='next'>
				            <span class='glyphicon glyphicon-chevron-right'></span>
				        </a>
						</div>
						
						<!-- Indicators -->
						<ol class='carousel-indicators mCustomScrollbar'>
							<c:forEach items="${StoreImgList}" var="StoreImg" varStatus="status">
								<c:if test="${status.index eq 0}">
									<li data-target='#carousel-custom' data-slide-to="0" class="active"><img src="${StoreImg.thumbnailUrl}" alt=""/></li>
								</c:if>
								<c:if test="${status.index ne 0}">
									<li data-target='#carousel-custom' data-slide-to="${status.index }"><img src="${StoreImg.thumbnailUrl}" alt=""/></li>
								</c:if>
							</c:forEach>
						</ol>
					</div>
				</div>
				<!-- 갖고있는 이미지의 개수만큼  캐러셀 끝-->
				<c:if test="${storeVo.isManager eq 1}">
					<button id="editStoreImgsBtn">수정</button>
				</c:if>
			</div>
		</div>
		<div class="row">
			<br>
			<div class="col-md-4 col-md-offset-2">
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
									정보 수정
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div id="map" style="width:100%;height:261px;"></div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<h1>리뷰<span class="storeReviewCount">(${storeVo.reviewCnt})</span></h1>
				<div class="review-header">
					<!-- 리뷰  -->
					<div id="overAllLevel">
						<!-- 스토어 전체 리뷰 평점 -->
						<div class="row">
							<div class="col-md-6 overAllLevel-left">
								<span>종합 평점</span>
								<h3>${storeVo.averageLevel}</h3>
								<div id="store-level"></div>
								<table class="levelGroup">
								<tr>
									<td><span><b>맛</b></span></td>
									<td><span><b>가격</b></span></td>
									<td><span><b>분위기</b></span></td>
									<td><span><b>서비스</b></span></td>
									<td><span><b>편의성</b></span></td>
								</tr>
								<tr>
									<td><span>${storeVo.tasteLevel}</span></td>
									<td><span>${storeVo.priceLevel}</span></td>
									<td><span>${storeVo.moodLevel}</span></td>
									<td><span>${storeVo.serviceLevel}</span></td>
									<td><span>${storeVo.convenienceLevel}</span></td>
								</tr>
								</table>
							</div>
							<div class="col-md-6"> <!-- overAllLevel-right"> -->
							<!-- 
							 <c:set var="allLevelCnt" value="${storeVo.level5Cnt+storeVo.level4Cnt+storeVo.level3Cnt+storeVo.level2Cnt+storeVo.level1Cnt}" />
							<div>
								<span class="progress-label">5</span>
								<div class="progress">
								  <div class="progress-bar" role="progressbar" aria-valuenow="${storeVo.level5Cnt}" aria-valuemin="0" aria-valuemax="${allLevelCnt}" style="width:${(storeVo.level5Cnt/allLevelCnt)*100}%;">
								  ${(storeVo.level5Cnt/allLevelCnt)*100}%
								</div>
								</div>
							</div>
							<div>
								<span class="progress-label">4</span>
								<div class="progress">
								  <div class="progress-bar" role="progressbar" aria-valuenow="${storeVo.level4Cnt}" aria-valuemin="0" aria-valuemax="${allLevelCnt}" style="width: ${(storeVo.level4Cnt/allLevelCnt)*100}%;">
								  ${(storeVo.level4Cnt/allLevelCnt)*100}%
								  </div>
								</div>
							</div>
							<div>
								<span class="progress-label">3</span>
								<div class="progress">
								  <div class="progress-bar" role="progressbar" aria-valuenow="${storeVo.level3Cnt}" aria-valuemin="0" aria-valuemax="${allLevelCnt}" style="width: ${(storeVo.level3Cnt/allLevelCnt)*100}%;">
								  ${(storeVo.level3Cnt/allLevelCnt)*100}%
								  </div>
								</div>
							</div>
							<div>
								<span class="progress-label">2</span>
								<div class="progress">
								  <div class="progress-bar" role="progressbar" aria-valuenow="${storeVo.level2Cnt}" aria-valuemin="0" aria-valuemax="${allLevelCnt}" style="width: ${(storeVo.level2Cnt/allLevelCnt)*100}%;">
								  ${(storeVo.level2Cnt/allLevelCnt)*100}%
								  </div>
								</div>
							</div>
							<div>
								<span class="progress-label">1</span>
								<div class="progress">
								  <div class="progress-bar" role="progressbar" aria-valuenow="${storeVo.level1Cnt}" aria-valuemin="0" aria-valuemax="${allLevelCnt}" style="width: ${(storeVo.level1Cnt/allLevelCnt)*100}%;">
								  ${(storeVo.level1Cnt/allLevelCnt)*100}%
								  </div>
								</div>
							</div>
														 -->
								<canvas id="bar-chart-horizontal" width="800" height="450"></canvas>
							</div>
						</div>						
					</div>
				</div>
				<!-- Button trigger modal -->
				<div class="row text-center">
				<button type="button" class="btn btn-default" data-toggle="modal" id="reviewModalBtn">
					리뷰 작성
				</button>
				</div>
				<br><br>
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
							<div class="reviewer-info col-md-2" onclick="location.href='/moca/mypage/${reviewVo.account_id}'" style="cursor:pointer;">
								<div class="profile-div">
									<c:if test="${empty reviewVo.thumbnailImage}">
										<img class="accountProfile img-circle" src="<c:url value="/resources/imgs/basicProfile.png"/>" alt="profile" style="width:100px;">
									</c:if>
									<c:if test="${not empty reviewVo.thumbnailImage}">
										<img class="accountProfile img-circle"  src="<c:url value="${reviewVo.thumbnailImage }" />" alt="profile" style="width:100px;">
									</c:if>
								</div>
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
										<c:forEach items="${reviewVo.imageList}" var="reviewImg">
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
										<span class="more-review-content-btn">더보기</span>
									</div>
									<div class="review-tags-div">
										<c:forEach items="${reviewVo.tagMap}" var="i">
											<c:if test="${i.value eq 1}">
												<a class="review-tag" href="/moca/stores?keyword=%23${i.key }&filter=distance">#${i.key }</a>	
											</c:if>
										</c:forEach>
									</div>
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
				<c:if test="${fn:length(reviewVoList) ge 3}">
					<button id="moreReview">더보기</button>
				</c:if>
				</div>

			</div>
		</div>
	</div>
	</div>
	<div id="footer">
		<jsp:include page="../../resources/template/footer.jsp" flush="true"></jsp:include>
	</div>

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
								<input type="text" name="tel1" size="3" maxlength="3" pattern="[0-9]{3}" value="${fn:substring(storeVo.tel,0,fn:indexOf(storeVo.tel, '-'))}" />
								-
								<input type="text" name="tel2" size="4" maxlength="4" pattern="[0-9]{4}" value="${fn:substring(storeVo.tel,fn:indexOf(storeVo.tel, '-')+1,fn:indexOf(storeVo.tel, '-')+5)}" />
								-
								<input type="text" name="tel3" size="4" maxlength="4" pattern="[0-9]{4}" value="${fn:substring(storeVo.tel,fn:indexOf(storeVo.tel, '-')+6,fn:indexOf(storeVo.tel, '-')+10)}" />
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
							<input type="hidden" id="delStoreImg"  name="delStoreImg"/>
							<input type="hidden" id="oldStoreImg"  name="oldStoreImg"/>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
						<button type="button" class="btn btn-primary" id="editStoreImgBtn">수정</button>
					</div>
				</div>
			</div>
		</div>	
		
		<!-- 카페 로고 모달 -->
		<div class="modal fade" id="storeLogowModal" tabindex="-1" role="dialog" aria-labelledby="reviewModalLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title">
							${storeVo.name} 사진 로고 수정</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body" data-role="content">
						<form id="storeLogoForm">
							<input name="storeId" value=${storeVo.store_Id } style="display:none;" >
							<input name="managerId" value=${accountVo.account_id } style="display:none;" >
							<div class="form-group">
								<label for="picture-file">사진 선택</label>
								<input name="storeLogoFile" id="storeLogoFile" type="file"/>
							</div>
							<div class="storeLogoGroup">
							
							</div>
							<input type="hidden" id="delStoreLogo"  name="delStoreLogo"/>
						</form>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
						<button type="button" class="btn btn-primary" id="editStoreLogoBtn">수정</button>
					</div>
				</div>
			</div>
		</div>
		
		<!-- storeImg clone -->
		<div class="storeImg" id="storeImgTemplate">
			<img alt="Image">
			<span class="glyphicon glyphicon-remove storeImgDeleteSpan" aria-hidden="true"></span>
		</div>
						
	</c:if>
	<span id="accountId" style="display : none;">${accountVo.account_id }</span>
	
	<jsp:include page="../../resources/template/reviewElement.jsp" flush="true"></jsp:include>
	
</body>

</html>
