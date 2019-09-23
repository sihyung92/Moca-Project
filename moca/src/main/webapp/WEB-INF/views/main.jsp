<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.css?ver=2"/>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.css"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
<style type="text/css">
	body{
		background-color: rgba(246,245,239,0.5);
		color: dimgray;
	}
/* body header */
	/* 템플릿 헤더 CSS(투명 설정 / 검색창 없애기) */
	#header .navbar{
		background-image: none;
		background-color:transparent;
		border: none;
		box-shadow: none;	
	}
	#header .navbar-header, #header .collapse{
		background-color: transparent;
	}
	#searchBar{
		display: none;
	}
	/* 메인 페이지 헤더 */
	#header{
		position: relative;
		height: 500px;
		background-image: url("resources/imgs/main_background5.jpg");
		background-size: cover;
	}
	#searchBar_main{								/* form 태그 */	
		font-size: 0;
		position: absolute;
		width: 500px;
		height: 50px;
		top: 70%;
		left: 50%;
   	 	transform: translate(-50%, -50%);
	}
	#searchBar_main #keyword_main{					/* 검색어 input 태그 */
		padding-inline-start: 20px;
		font-size: 20px;
		height: 50px;
		width: 100%;
		border-radius: 25px;
		border: 4px solid rgb(190,200,51);
	}
	#searchBar_main #keyword_main:focus{
		outline-color: lightgray;
	}
	#searchBar_main button{
		position: relative;
		height: 50px;
		top: -50px;
		float: right;		
		font-size: 23px;
		background-color: transparent;
		line-height: 25px;
	}
	#searchBar_main button:focus{
		outline: none !important;
	}
/* body content */	
	/* 모카픽 추천 캐러셀 */
	.mocaPick-template{
		display: none;
	}
	.mocaPick-container h4{
		font-weight: bold;
		text-indent: 5px;
		/* 	padding-inline-start: 5px; */
	}
	.mocaPick-container .bx-wrapper{
		border: none;
		box-shadow: none;
		margin-bottom: 40px;
		z-index: 3;
		border: rgba(236,235,229,1) 1px solid;
		border-radius: 2px;
		background-color: rgba(236,235,229,0.5);
	}	
	.bx-wrapper .bx-viewport .mocaPick .store{
	}
	.bx-wrapper .bx-viewport .mocaPick .store a{		
		color: dimgray;
	}
	.bx-wrapper .bx-viewport .mocaPick .store .mocaPick-storeInfo{
		width: 300px;
		position: absolute;
		z-index: 2;
		height: 50px;
		bottom: -50px;
		padding: 5px;
	}
	.mocaPick-storeInfo .mocaPick-storeName{
		font-size: 16px;
		font-weight: bold;
	}
	.mocaPick-storeInfo .mocaPick-averageLevel{
		font-size: 15px;
		font-weight: bold;
		color: rgb(198,161,83);
	}
	.mocaPick-storeInfo .mocaPick-cnt{
		font-size: 12px;
	}
	.bx-wrapper .bx-viewport .mocaPick .store .mocaPick-img-list{
		height: 200px;
		overflow:hidden;
	}
	.bx-wrapper .bx-viewport .mocaPick .store .mocaPick-img-list img{
		display: none;
		width: 100%;
		height: auto;
		position: relative;
		top: 50%;
		left: 50%;
		transform: translate(-50%,-50%);
	}
	.bx-wrapper .bx-viewport .mocaPick .store img:nth-child(1){
		display: block;
	}
	/* 인기 리뷰, 최근 리뷰 */
	#review-container h4{
		font-weight: bold;
		text-indent: 5px;
	}
	#review-container{
		margin-bottom: 40px;
		padding-left: 10px;
		padding-right: 10px;
	}
	#review-container>div{
		/* background-color: pink;*/
	}
	#bestReview, #recentReview{
		/* background-color: blue; */
		border: rgba(236,235,229,1) 1px solid;
		border-radius: 2px;
		overflow-y : scroll;
		height : 400px;
	}
	.review{
		background-color: rgba(236,235,229,0.5);
		padding: 10px;
		margin-bottom: 2px;
		overflow: hidden;
	}
	.review .review-img-profile{
		width:25px;
		height:25px;
		border-radius: 50%;
	}
	.review .review-img-list{
		font-size: 0;
	}	
	.review .review-img-list img{	
		display:inline-block;
		width:130px;
		height:130px;
		margin-top: 3px;
		margin-left: 10px; 
	}
	#review-container a{
		color: dimgray;
		font-weight: bold;
	    font-size: 20px;
	}
 	#review-container a:hover{
		text-decoration: none;		
	}
	.review-text-averageLevel{
		font-size: 19px;
		color: rgb(198,161,83);
	}
	.review-text-userInfo{
		font-size: 12px;
	}
	.review-text-content{
		font-size: 15px;
	}
/* 미디어 쿼리 */	
	@media (max-width: 768px){
		#header{
			height: 250px;
		}
		#searchBar_main{   	 	
			width: 80%;
		} 
		#review-container{
			margin-bottom: 40px;
		}
		#recentReview-container{
			margin-top: 40px;
		}
		#header .collapse, #searchBar{
			background-color: rgba(255,255,255,0.7);
			border: none;
		}
		#header #keyword{
			background-color: transparent;
		}
	}
</style>
<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
<script type="text/javascript">
	<c:set var="defaultImg"><c:url value="/resources/imgs/logo/horizontalLogo(letter).png"/></c:set>
	<c:set var="defaultThum"><c:url value="/resources/imgs/basicProfile.png"/></c:set>	
	//GeoLocation API에서 현재 위치의 위도&경도 얻기
	var lat, lng;	
	var slide;
	var idx=0;
    window.onload = function () {      	  	
        //헤더 fix 속성에 따른 body 패딩값 삭제
        $('div#header+div').css('padding-top', '10px');
    	//스크롤 위치에 따라 헤더 배경 토글
    	$(window).on("scroll", changeHeaderColor); 
		//스크롤 일정 이상 내려가면 추천 카페 데이터 추가	
    	$(window).on("scroll", updateData);
		//검색창 마우스 휠 이벤트
    	$('body').on('mousewheel', function(e){
            if($(window).width()<768 && e.originalEvent.wheelDelta > 0) {
            	$('#searchBar').hide();
            }
        });
        	
    	
    	//키워드 검사
		$('#searchBar_main button').click(function(){
			var keyword = $('#keyword_main').val();
			keyword = keyword.trim();		
			//검색어가 없거나 태그가 2개 이상일 때,			
			if(keyword=="" || keyword=="#" || keyword.indexOf('#') != keyword.lastIndexOf('#')){
				$('#keyword_main').val("");
				$('#keyword_main').attr('placeholder', '잘못된 키워드 입니다... :(');
				return false;
			}else{				
				$(this).parent().submit();
			}
		});
    	
   	 	//캐러셀(bxSlider) 시작    	 	
    	$('.mocaPick').bxSlider({
    		pager: false,
    		autoReload: true,
    		slideMargin: 1,
    		minSlides: 1,
    		maxSlides: 15,
    		moveSlides: 3,    		
    		slideWidth: 300,
    		onSliderLoad: function(){
        		$('.bx-viewport').css('height', '250px');
            },
    		onSliderResize: function(){
        		$('.bx-viewport').css('height', '250px');
            }
    	});     	
    	//캐러셀 mouseDown 이벤트(해당 카페 디테일 페이지로 이동)
    	$('.mocaPick .store a').on('mousedown', goDetail);        
        //캐러셀 mouseEnter: 이미지 슬라이드 & 오버레이 이벤트
       // $('.mocaPick .store a').on("mouseenter", mouseEnter);
        //캐러셀 mouesLeave: 원복
       // $('.mocaPick .store a').on("mouseleave", mouseLeave);
    };//onload() 끝  

    //이미지 클릭 시 디테일 페이지로 이동 이벤트
	function goDetail(){
		window.location.href=$(this).attr('href');
	}; 
    //캐러셀 mouseEnter: 이미지 슬라이드 & 오버레이 이벤트
    function mouseEnter(){
              var overlay = $(this).children('.overlay');
              overlay.show();
              var imgs = $(this).children('img');
              var i=0;
            	//이미지 슬라이드 함수
          	(function slideFunction(){
          		imgs.hide();
          		$(imgs[i]).show();
          		if(i==2) i=0; else i++;
          		slide = setTimeout(slideFunction, 500);
          	})();        
       };
       
     //캐러셀 mouesLeave: 원복
     function mouseLeave(){
         clearTimeout(slide);
 		$(this).children().hide();
 		var firstImg = $(this).children('img')[0];
 		$(firstImg).show();
     };
       
    //스크롤 이벤트
    function updateData(){     
        	var position = $(window).scrollTop();	//스크롤바 위치로 페이지 위치 판단
        	var updatePoint = $(document).height()*3/5; //데이터 추가 기준 세팅        	   
            if(position>updatePoint){
            	$(window).off("scroll", updateData);
            	var template = $('.mocaPick-template').clone();
            	template.removeClass("mocaPick-template");
    			$.ajax({
    				url:"getmorepicks/"+idx,
    				dataType:"json",
    				success:function(result){
        				idx++;
        				for(var listName in result){      
            				var mocaPick = $('<div class="mocaPick"></div>'); 
            				var list = result[listName];	//추천별 리스트 배열
            				//추천별 카페 리스트 HTML 생성
            				for(var i=0; i<list.length; i++){               		
            					var store = $(template).clone();
            					//카페 디테일 페이지 연결
            					$(store).children('a').attr('href', './stores/'+list[i].store_Id);
								//카페의 이미지 추가	
	            				var imgs = $(store).children('a').children('.mocaPick-img-list').children();		//mocaPick-img-list div의 이미지 태그 배열
		            			$(imgs[0]).attr('src', list[i].storeImg1);
		            			$(imgs[1]).attr('src', list[i].storeImg2);
		            			$(imgs[2]).attr('src', list[i].storeImg3);
		            			//디폴트 이미지, 이미지 정보, 타이틀 지정
	            				for(var j=0; j<3; j++){
		            				if($(imgs[j]).attr('src')==null){
		            					$(imgs[j]).attr('src', '${defaultImg}');
			            			}
		            				$(imgs[j]).attr('alt', list[i].name+'_main'+j);
	                				$(imgs[j]).attr('title', list[i].name); 
		            			}
		            			//카페 정보 추가 
		            			var info = $(store).children('a').children('.mocaPick-storeInfo');   
		            			$(info).children('.mocaPick-storeName').html(list[i].name+'&nbsp;&nbsp;');
		            			$(info).children('.mocaPick-averageLevel').text((list[i].averageLevel).toFixed(1));
		            			$(info).children('.mocaPick-viewCnt').text(list[i].viewCnt);
		            			$(info).children('.mocaPick-reviewCnt').text(list[i].reviewCnt); 
		            			$(info).children('.mocaPick-address').text(list[i].roadAddress);
		            			mocaPick.append($(store));	
                    		}
                    		//mocaPick.before('<h5>'+listName+'</h5>');	이건 왜 안되나요....푸
                    		if(listName.includes('#')){
								listName='<img style="height: 15px; width: 15px;" src="./resources/imgs/icons/tag.svg"/>'+listName.split("#")[1];
                        	}
                    		$('#mocaPick-container2').append('<h4>'+listName+'</h4>');	//카페 추천 타이틀 추가
                    		$('#mocaPick-container2').append(mocaPick);		//캐러셀 컨테이너에 추천 리스트 추가
                    		//캐러셀 적용
                    		$('.mocaPick').bxSlider({
                        		pager: false,
                        		autoReload: true,
                        		slideMargin: 1,
                        		minSlides: 1,
                        		maxSlides: 15,
                        		moveSlides: 3,    		
                        		slideWidth: 300,
                        		onSliderLoad: function(){
                            		$('.bx-viewport').css('height', '250px');
                                },
                        		onSliderResize: function(){
                            		$('.bx-viewport').css('height', '250px');
                                }
                        	});  
                    		//캐러셀 mouseDown 이벤트(해당 카페 디테일 페이지로 이동)
                    		$('.mocaPick .store a').off('mousedown', goDetail);
                        	$('.mocaPick .store a').on('mousedown', goDetail);
        				}
        				//기존 캐러셀 mouseEnter/Leave 이벤트 해제 & 추가
        				//$('.mocaPick li a').off("mouseenter", mouseEnter);
        				//$('.mocaPick li a').off("mouseleave", mouseLeave);
        				//$('.mocaPick li a').on("mouseenter", mouseEnter);
        				//$('.mocaPick li a').on("mouseleave", mouseLeave);
        				$(window).on("scroll", updateData);        			
    				},
    				error: function(e){
        				$(window).off("scroll", updateData);
        			}
    			});
            };
            pre_position=position;
    };      
    //스크롤 위치에 따라 헤더 배경색 변경
    function changeHeaderColor(e){        
    	var position = $(window).scrollTop();
    	var width = $(window).width();
    	if(width < 768){
			if(position > 188){
            	
            	$('#header .navbar').css('background-color', 'rgba(255,255,255, 1)');
            }else{
            	$('#header .navbar').css('background-color', 'transparent');
            }
        }else{
        	if(position > 438){
            	$('#searchBar').show();
            	$('#header .navbar').css('background-color', 'rgba(255,255,255, 1)');
            }else{
            	$('#searchBar').hide();
            	$('#header .navbar').css('background-color', 'transparent');
            }
        }    	
    };
    
	</script>
</head>
<body>
<div id="header">
	<jsp:include page="../../resources/template/header.jsp" flush="true"></jsp:include>
	<form id="searchBar_main" action="<c:url value="/stores"/>">
        <input type="text" name="keyword" id="keyword_main" placeholder="카페를 검색해보세요:D"/>	
  		<input type="hidden" name="filter" value="distance"/>
     	<button type="submit" class="btn btn-default">
     		<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="25" height="25" fill="none" stroke="currentcolor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
			    <circle cx="14" cy="14" r="12" />
			    <path d="M23 23 L30 30"  />
			</svg>
		</button>
    </form>
</div>
<div id="content" class="container-fluid">
<!-- <object class="svgtest" type="image/svg+xml" data="./resources/imgs/icons/search.svg"></object> -->
<!-- 카페 추천(mocaPick) 캐러셀-->	
	<div class="mocaPick-container">
	 	<c:forEach items="${storesList}" var="list" varStatus="status">
			<c:if test="${not empty list}">
				<c:set var="length" value="${fn:length(list)}"/>
				<c:set var="index" value="${status.index}"/>
				<c:set var="name" value="${listNames[index]}"/>
					<h4>${name}</h4>
					<div class="mocaPick">
						<c:forEach items="${list}" var="store" begin="0" end="${length-1}" > 		
						    <div class="store">
							   	<a href="./stores/${store.store_Id}">
							    	<div class="mocaPick-img-list">						    		
								    	<img src="${store.storeImg1}<c:if test="${store.storeImg1 eq null}">${defaultImg }</c:if>" alt="${store.name }_main1" title="${store.name}">
								    	<img src="${store.storeImg2}<c:if test="${store.storeImg2 eq null}">${defaultImg }</c:if>" alt="${store.name }_main2" title="${store.name}">
								    	<img src="${store.storeImg3}<c:if test="${store.storeImg3 eq null}">${defaultImg }</c:if>" alt="${store.name }_main3" title="${store.name}">
							    	</div>
									<div class="mocaPick-storeInfo">									
						     			<span class="mocaPick-storeName">${store.name}&nbsp;&nbsp;</span><span class="mocaPick-averageLevel"><fmt:formatNumber value="${store.averageLevel}" pattern="0.0"/></span><br/>			     			
						     			<svg id="i-eye" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="15" height="15" fill="none" stroke="dimgray" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
										   	<circle cx="17" cy="15" r="1" />
										    <circle cx="16" cy="16" r="6" />
										    <path d="M2 16 C2 16 7 6 16 6 25 6 30 16 30 16 30 16 25 26 16 26 7 26 2 16 2 16 Z" />
										</svg>
						     			<span class="mocaPick-cnt mocaPick-viewCnt">${store.viewCnt}</span>
							     		<svg id="i-edit" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="15" height="15" fill="none" stroke="dimgray" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
										    <path d="M30 7 L25 2 5 22 3 29 10 27 Z M21 6 L26 11 Z M5 22 L10 27 Z" />
										</svg>
							     		<span class="mocaPick-cnt mocaPick-reviewCnt">${store.reviewCnt}</span><br/>
						     			<%-- <span class="mocaPick-address">${store.roadAddress}</span> --%>					     			
					     			</div>
					     		</a>
							</div>
						</c:forEach>
					</div>
			</c:if>
		</c:forEach> 
	</div><!-- mocaPick 캐러셀 끝-->	
<!-- 인기 리뷰 / 최근 리뷰 시작 -->
	<c:if test="${not empty recentReviews }">
	<!-- <c:if test="${not empty bestReviews }"></c:if>	-->
		<div class="row" id="review-container">
			<!-- 인기 리뷰 -->
			<div id="bestReview-container" class="col-sx-12 col-md-6">	
				<h4>인기 리뷰&nbsp;<img style="height: 25px; width: 25px;" src="./resources/imgs/icons/compose.svg"/></h4>
				<div id="bestReview">
					<c:forEach items="${bestReviews }" var="bean">
						<div class="review">
							<a href="./stores/${bean.store_id}">
								<span class="review-text-storeName">${bean.storeName}&nbsp;</span>
								<span class="review-text-averageLevel">${bean.averageLevel}</span>
							</a><br/>
							&nbsp;<img class="review-img-profile" src="${bean.thumbnailImage }<c:if test="${bean.thumbnailImage eq null or bean.thumbnailImage eq ''}">${defaultThum }</c:if>" alt="${bean.nickName }"/>
							<span class="review-text-userInfo">${bean.nickName }&nbsp;&nbsp;&#124;&nbsp;&nbsp;</span>
							<svg  id="thumbs-up" xmlns="http://www.w3.org/2000/svg" width="13px" height="13px" viewBox="0 0 32 32" >
								<path fill="none" stroke="dimgray" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="
									M30,22.6c1.8-1.4,1.8-4.2,0-5.6c-0.1-0.1-0.1-0.1-0.1-0.2c0.3-0.7,0.3-1.5,0.1-2.2c-0.4-1.6-2-2.8-3.7-2.8c-2.5,0-4.9,0-7.4,0
									c-0.1,0-0.1,0-0.2,0c0.1-0.2,0.3-0.4,0.4-0.5c0.8-1,1.6-2.1,2.2-3.2c0.5-0.9,0.8-1.8,0.8-2.8c0.1-1.1-0.2-2.1-0.8-3.1
									c-0.4-0.5-0.8-0.9-1.5-1.1C19.6,1,19.3,1,19.1,1c-0.6-0.1-1.3-0.1-1.9,0.1c-0.4,0.1-0.6,0.4-0.7,0.7c0,0.2,0,0.3,0,0.5
									c0,0.4-0.1,0.7-0.1,1.1c-0.3,1.5-1,2.7-2,3.8c-1.9,2.2-3.9,4.2-5.8,6.3l0.1,15.3c1.1,0.4,2.1,0.8,3.2,1.2c2.1,0.6,4.2,0.9,6.3,0.9
									c2.1,0,4.2,0,6.3,0c1.1,0,2.1-0.3,2.9-1.1c0.8-0.7,1.3-1.6,1.2-2.6c0-0.1,0-0.2,0.1-0.3c1.4-1,1.9-2.7,1.3-4.3
									C29.9,22.7,29.9,22.6,30,22.6z"/>
								<path fill="none" stroke="dimgray" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="
									M8.5,13C6.5,13,3,13,0.9,13c0,5.8,0,11,0,16.8c2,0,5.6,0.1,7.6,0.1C8.5,20.8,8.5,16.5,8.5,13z"/>
							</svg>
							<span>${bean.likeCount}</span>
							<svg id="thumbs-down" xmlns="http://www.w3.org/2000/svg" width="13px" height="13px" viewBox="0 0 32 32">
								<path fill="none" stroke="dimgray" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="
									M30,9.4c1.8,1.4,1.8,4.2,0,5.6c-0.1,0.1-0.1,0.1-0.1,0.2c0.3,0.7,0.3,1.5,0.1,2.2c-0.4,1.6-2,2.8-3.7,2.8c-2.5,0-4.9,0-7.4,0
									c-0.1,0-0.1,0-0.2,0c0.1,0.2,0.3,0.4,0.4,0.5c0.8,1,1.6,2.1,2.2,3.2c0.5,0.9,0.8,1.8,0.8,2.8c0.1,1.1-0.2,2.1-0.8,3.1
									c-0.4,0.5-0.8,0.9-1.5,1.1c-0.3,0-0.5,0.1-0.8,0.1c-0.6,0.1-1.3,0.1-1.9-0.1c-0.4-0.1-0.6-0.4-0.7-0.7c0-0.2,0-0.3,0-0.5
									c0-0.4-0.1-0.7-0.1-1.1c-0.3-1.5-1-2.7-2-3.8c-1.9-2.2-3.9-4.2-5.8-6.3L8.6,3.1c1.1-0.4,2.1-0.8,3.2-1.2C13.9,1.3,16,1,18.1,1
									c2.1,0,4.2,0,6.3,0c1.1,0,2.1,0.3,2.9,1.1c0.8,0.7,1.3,1.6,1.2,2.6c0,0.1,0,0.2,0.1,0.3c1.4,1,1.9,2.7,1.3,4.3
									C29.9,9.3,29.9,9.4,30,9.4z"/>
								<path fill="none" stroke-width="2" stroke="dimgray" stroke-linecap="round" stroke-linejoin="round" d="
									M8.5,19C6.5,19,3,19,0.9,19c0-5.8,0-11,0-16.8c2,0,5.6-0.1,7.6-0.1C8.5,11.2,8.5,15.5,8.5,19z"/>
							</svg>
							<span>${bean.hateCount}&nbsp;&nbsp;&#124;&nbsp;&nbsp;</span>
							<span class="review-text-date"><small>${bean.writeDate }</small></span><br/>
							<c:if test="${not empty bean.imageList }">
								<div class="review-img-list">
									<c:forEach items="${bean.imageList }" var="img" varStatus="status" end="3">
									  	<img src="${img.url }" alt="${img.originName }">		  				  	
							  		</c:forEach>
								</div>
							</c:if>
							<span class="review-text-content col-md-12">${bean.reviewContent }</span>				
						</div>
					</c:forEach>
				</div>
			</div>
			<!-- 최신 리뷰 -->
			<div id="recentReview-container" class="col-sx-12 col-md-6">	
				<h4>최신 리뷰&nbsp;<img style="height: 25px; width: 25px;" src="./resources/imgs/icons/compose.svg"/></h4>
				<div id="recentReview">
					<c:forEach items="${recentReviews }" var="bean">
						<div class="review">
							<a href="./stores/${bean.store_id}">
								<span class="review-text-storeName">${bean.storeName}&nbsp;</span>
								<span class="review-text-averageLevel">${bean.averageLevel}</span>
							</a><br/>			
							&nbsp;<img class="review-img-profile" src="${bean.thumbnailImage }<c:if test="${bean.thumbnailImage eq null or bean.thumbnailImage eq ''}">${defaultThum }</c:if>" alt="${bean.nickName }"/>
							<span class="review-text-userInfo">${bean.nickName }&nbsp;&nbsp;&#124;&nbsp;&nbsp;</span>
							<svg  id="thumbs-up" xmlns="http://www.w3.org/2000/svg" width="13px" height="13px" viewBox="0 0 32 32" >
								<path fill="none" stroke="dimgray" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="
									M30,22.6c1.8-1.4,1.8-4.2,0-5.6c-0.1-0.1-0.1-0.1-0.1-0.2c0.3-0.7,0.3-1.5,0.1-2.2c-0.4-1.6-2-2.8-3.7-2.8c-2.5,0-4.9,0-7.4,0
									c-0.1,0-0.1,0-0.2,0c0.1-0.2,0.3-0.4,0.4-0.5c0.8-1,1.6-2.1,2.2-3.2c0.5-0.9,0.8-1.8,0.8-2.8c0.1-1.1-0.2-2.1-0.8-3.1
									c-0.4-0.5-0.8-0.9-1.5-1.1C19.6,1,19.3,1,19.1,1c-0.6-0.1-1.3-0.1-1.9,0.1c-0.4,0.1-0.6,0.4-0.7,0.7c0,0.2,0,0.3,0,0.5
									c0,0.4-0.1,0.7-0.1,1.1c-0.3,1.5-1,2.7-2,3.8c-1.9,2.2-3.9,4.2-5.8,6.3l0.1,15.3c1.1,0.4,2.1,0.8,3.2,1.2c2.1,0.6,4.2,0.9,6.3,0.9
									c2.1,0,4.2,0,6.3,0c1.1,0,2.1-0.3,2.9-1.1c0.8-0.7,1.3-1.6,1.2-2.6c0-0.1,0-0.2,0.1-0.3c1.4-1,1.9-2.7,1.3-4.3
									C29.9,22.7,29.9,22.6,30,22.6z"/>
								<path fill="none" stroke="dimgray" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="
									M8.5,13C6.5,13,3,13,0.9,13c0,5.8,0,11,0,16.8c2,0,5.6,0.1,7.6,0.1C8.5,20.8,8.5,16.5,8.5,13z"/>
							</svg>
							<span>${bean.likeCount}</span>
							<svg id="thumbs-down" xmlns="http://www.w3.org/2000/svg" width="13px" height="13px" viewBox="0 0 32 32">
								<path fill="none" stroke="dimgray" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" d="
									M30,9.4c1.8,1.4,1.8,4.2,0,5.6c-0.1,0.1-0.1,0.1-0.1,0.2c0.3,0.7,0.3,1.5,0.1,2.2c-0.4,1.6-2,2.8-3.7,2.8c-2.5,0-4.9,0-7.4,0
									c-0.1,0-0.1,0-0.2,0c0.1,0.2,0.3,0.4,0.4,0.5c0.8,1,1.6,2.1,2.2,3.2c0.5,0.9,0.8,1.8,0.8,2.8c0.1,1.1-0.2,2.1-0.8,3.1
									c-0.4,0.5-0.8,0.9-1.5,1.1c-0.3,0-0.5,0.1-0.8,0.1c-0.6,0.1-1.3,0.1-1.9-0.1c-0.4-0.1-0.6-0.4-0.7-0.7c0-0.2,0-0.3,0-0.5
									c0-0.4-0.1-0.7-0.1-1.1c-0.3-1.5-1-2.7-2-3.8c-1.9-2.2-3.9-4.2-5.8-6.3L8.6,3.1c1.1-0.4,2.1-0.8,3.2-1.2C13.9,1.3,16,1,18.1,1
									c2.1,0,4.2,0,6.3,0c1.1,0,2.1,0.3,2.9,1.1c0.8,0.7,1.3,1.6,1.2,2.6c0,0.1,0,0.2,0.1,0.3c1.4,1,1.9,2.7,1.3,4.3
									C29.9,9.3,29.9,9.4,30,9.4z"/>
								<path fill="none" stroke-width="2" stroke="dimgray" stroke-linecap="round" stroke-linejoin="round" d="
									M8.5,19C6.5,19,3,19,0.9,19c0-5.8,0-11,0-16.8c2,0,5.6-0.1,7.6-0.1C8.5,11.2,8.5,15.5,8.5,19z"/>
							</svg>
							<span>${bean.hateCount}&nbsp;&nbsp;&#124;&nbsp;&nbsp;</span>
							<span class="review-text-date"><small>${bean.writeDate }</small></span><br/>
							<c:if test="${not empty bean.imageList }">
								<div class="review-img-list">
									<c:forEach items="${bean.imageList }" var="img" varStatus="status" end="3">
								  		<img src="${img.url }" alt="${img.originName }">		  				  	
							  		</c:forEach>
								</div>
							</c:if>
							<span class="review-text-content col-md-12">${bean.reviewContent }</span>			
						</div>
					</c:forEach>
				</div>
			</div>
		</div>	
	</c:if><!-- 인기 리뷰 / 최근 리뷰 끝 -->	
<!-- 카페 추천(mocaPick) 캐러셀 추가 -->	
	<!-- 캐러셀 추가용 템플릿 -->
	<div class="store mocaPick-template">
		<a href="">
	    	<div class="mocaPick-img-list">
		    	<img src="" alt="" title="">
		    	<img src="" alt="" title="">
		    	<img src="" alt="" title="">
	    	</div>
			<div class="mocaPick-storeInfo">
	   			<span class="mocaPick-storeName"></span><span class="mocaPick-averageLevel"></span><br/>			     			
	   			<svg id="i-eye" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="15" height="15" fill="none" stroke="dimgray" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
				   	<circle cx="17" cy="15" r="1" />
				    <circle cx="16" cy="16" r="6" />
				    <path d="M2 16 C2 16 7 6 16 6 25 6 30 16 30 16 30 16 25 26 16 26 7 26 2 16 2 16 Z" />
				</svg>
	   			<span class="mocaPick-cnt mocaPick-viewCnt"></span>
	   			<svg id="i-edit" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" width="15" height="15" fill="none" stroke="dimgray" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
				    <path d="M30 7 L25 2 5 22 3 29 10 27 Z M21 6 L26 11 Z M5 22 L10 27 Z" />
				</svg>
	    			<span class="mocaPick-cnt mocaPick-reviewCnt"></span><br/>
	   			<!-- <span class="mocaPick-address"></span> -->
	   		</div>
   		</a>
	</div>
	<!-- 추가 캐러셀 등록할 컨테이너 -->
	<div class="mocaPick-container" id="mocaPick-container2">	    
	</div><!-- mocaPick 캐러셀 추가 끝-->
</div>
</body>
</html>
