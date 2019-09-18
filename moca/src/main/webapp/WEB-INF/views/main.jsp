<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1", user-scalable=no">
<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.css"/>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.css"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
<style type="text/css">
/* Header */
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
		background-image: url("resources/imgs/background.jpg");
		background-size: cover;
	}
	#searchBar_main{
		font-size: 0;
		background-color: lightgray;
		position: absolute;
		top: 70%;
		left: 50%;
   	 	transform: translate(-50%, -50%);
	}
	.form-control{
		font-size: 20px;
		height: 50px;
		width: 500px;
		border-radius: 25px;
	}
	#searchBar_main button{
		font-size: 25px;
	}
/* Body */
	body{
		background-color: rgba(246,245,239,0.5);
	}
	/* 캐러셀 */
	.slider{
		width: 1300px;
	}
	.slider .store{
		background-color: pink;
		display: inline-block;
		border: black 1px solid;
	}	
	.carousel-control {
	  position: absolute;
	  top: 0;
	  bottom: 0;
	  left: 0;
	  width: 3%;
	  font-size: 20px;
	  color: #fff;
	  text-align: center;
	  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.6);
	  background-color: rgba(0, 0, 0, 0);
	  filter: alpha(opacity=50);
	  opacity: 0;
	}
	.mocaPick{
		background-color: red;	
	}
	.mocaPick .carousel{
		border: 2px aqua solid;
	}
	.mocaPick .carousel-inner{
		background-color: lavender;
	}
	.mocaPick .item{
		background-color: orange;
		border: 3px yellow solid;
		height: auto;
	}
	.mocaPick .item-content{
		display: inline-block;
		float: left;
 		width:20%;
		height:20%;
	}
	.mocaPick img{
 		width: 100%;
		height: 100%; 
		display:none;
		border: black solid 1px;
	}

	.mocaPick img:nth-child(2){
		display:block;
	}
	.overlay{
		background-color: rgba(0,0,0,0.5); 
		position: absolute;
		z-index: 2;
		color: white;
	}
	.overlay span{
		color: brown;
	}
	/* 인기 리뷰, 최근 리뷰 */
	#review-list{
		color: dimgray;
	}
	.bx-wrapper{
		position : static;
	}
	
	#bestReview-list, #recentReview-list{
		border: lightgray 1px solid;
		border-radius: 2px;
		overflow-y : scroll;
		height : 400px;
	}
	.review{
		background-color: rgba(236,235,229,1);
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
	#review-list a{
		color: dimgray;
		font-weight: bold;
	    font-size: 20px;
	}
 	#review-list a:hover{
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
</style>
<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="resources/js/jquery.bxslider-rahisified.js"></script>
<link rel="stylesheet" href="resources/css/jquery.bxslider.css">
<script type="text/javascript">
	//GeoLocation API에서 현재 위치의 위도&경도 얻기
	var lat, lng;	
	var slide;
    window.onload = function () {  
   	 	//bxSlider 시작 
    	$('.slider').bxSlider({
    		minSlides: 1,
    		maxSlides: 7,
    		moveSlides: 3,
    		slideWidth: 300
    	});       
        //캐러셀 mouseEnter: 이미지 슬라이드 & 오버레이 이벤트
        $('.mocaPick li a').on("mouseenter", mouseEnter);
        //캐러셀 mouesLeave: 원복
        $('.mocaPick li a').on("mouseleave", mouseLeave);
		//스크롤 일정 이상 내려가면 추천 카페 데이터 추가	
    	$(window).on("scroll", updateData);
    };//onload() 끝  
    
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
        	var updatePoint = $(document).height()*3/5;        	
            if(position>updatePoint){
            	$(window).off("scroll");
    			$.ajax({
    				url:"getmorepicks",
    				dataType:"html",
    				success:function(data){
        				$('body').append(data);
        				//기존 캐러셀 mouseEnter/Leave 이벤트 해제 & 추가
        				$('.mocaPick li a').off("mouseenter", mouseEnter);
        				$('.mocaPick li a').off("mouseleave", mouseLeave);
        				$('.mocaPick li a').on("mouseenter", mouseEnter);
        				$('.mocaPick li a').on("mouseleave", mouseLeave);
        				$(window).on("scroll", updateData);        			
    				},
    				error: function(e){
        				alert("에러콜백");
        				$(window).off("scroll");
        			}
    			});
            };
    };        
	</script>
</head>
<body>
<div id="header">
	<jsp:include page="../../resources/template/header.jsp" flush="true"></jsp:include>
	<form id="searchBar_main" class="form-inline" action="<c:url value="/stores"/>">
      <div class="form-group">
        <input type="text" name="keyword" id="keyword" class="form-control" placeholder="카페를 검색해보세요:D" size="50">	
  		<input type="hidden" name="filter" value="distance"/>
      </div>
      <button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
    </form>
</div>
<div id="content" class="container-fluid">
	<c:set var="defaultImg"><c:url value="/resources/imgs/reviewDefault.png"/></c:set>
	<c:set var="defaultThum"><c:url value="/resources/imgs/basicProfile.png"/></c:set>
<!-- 카페 추천 캐러샐(bxSlider)-->
 	<c:forEach items="${storesList}" var="list" varStatus="status" begin="0" end="0">
				<div class="row">
		<c:if test="${not empty list}">
			<c:set var="length" value="${fn:length(list)}"/>
			<c:set var="index" value="${status.index}"/>
			<c:set var="name" value="${listNames[index]}"/>
				<h5>${name}: 총 가게 ${length}개</h5>
					<div class="slider">
						<c:forEach items="${list}" var="store" begin="0" end="${length-1}" > 		
						    <div class="store col-md-3">
						    	<img src="${store.storeImg1}<c:if test="${store.storeImg1 eq null}">${defaultImg }</c:if>" alt="${store.name }_main1">
							</div>
						</c:forEach>
					</div>
		</c:if>
		<c:if test="${not empty list}">
			<c:set var="length" value="${fn:length(list)}"/>
			<c:set var="index" value="${status.index}"/>
			<c:set var="name" value="${listNames[index]}"/>
				<h5>${name}: 총 가게 ${length}개</h5>
					<div class="slider">
						<c:forEach items="${list}" var="store" begin="0" end="${length-1}" > 		
						    <div class="store col-md-3">
						    	<img src="${store.storeImg1}<c:if test="${store.storeImg1 eq null}">${defaultImg }</c:if>" alt="${store.name }_main1">
							</div>
						</c:forEach>
					</div>
		</c:if>
				</div>
	</c:forEach> 
<!-- 인기 리뷰 / 최근 리뷰 시작 -->
<c:if test="${not empty recentReviews }">
<!-- <c:if test="${not empty bestReviews }"></c:if>	-->
	<div class="row" id="review-list">
		<!-- 인기 리뷰 -->
		<div class="col-sx-12 col-md-6">	
			<h4>&nbsp;인기 리뷰</h4>
			<div id="bestReview-list">
				<c:forEach items="${bestReviews }" var="bean">
					<div class="review">
						<a href="./stores/${bean.store_id}">
							<span class="review-text-storeName">${bean.storeName}&nbsp;</span>
							<span class="review-text-averageLevel">${bean.averageLevel}</span>
						</a><br/>
						&nbsp;<img class="review-img-profile" src="${bean.thumbnailImage }<c:if test="${bean.thumbnailImage eq null}">${defaultThum }</c:if>" alt="${bean.nickName }"/>
						<span class="review-text-userInfo">${bean.nickName }&nbsp;&nbsp;&#124;&nbsp;&nbsp;</span>
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
		<div class="col-sx-12 col-md-6">	
			<h4>&nbsp;최신 리뷰</h4>
			<div id="recentReview-list">
				<c:forEach items="${recentReviews }" var="bean">
					<div class="review">
						<a href="./stores/${bean.store_id}">
							<span class="review-text-storeName">${bean.storeName}&nbsp;</span>
							<span class="review-text-averageLevel">${bean.averageLevel}</span>
						</a><br/>			
						&nbsp;<img class="review-img-profile" src="${bean.thumbnailImage }<c:if test="${bean.thumbnailImage eq null}">${defaultThum }</c:if>" alt="${bean.nickName }"/>
						<span class="review-text-userInfo">${bean.nickName }&nbsp;&nbsp;&#124;&nbsp;&nbsp;</span>
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
</c:if>
<br/><br/>
<!-- 인기 리뷰 / 최근 리뷰 끝 -->	
</div>
</body>
</html>
