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
	/* 최근 리뷰2 */
	.recentReviews img{
		width:30px;
		height:30px;
		border-radius: 50%;
	}
	.recentReviews .review{
		background-color: lightgray;
		margin: 1px;
	}
	/* 인기 리뷰 */
	.panel-heading img{
		width:30px;
		height:30px;
		border-radius: 50%;
	}
	.panel-body .panel-body h3{
		color: brown;
	}
	.panel-heading h3{
		display : inline-block;
	}
	.panel-heading h4{
		margin-left : 5px;
		display : inline-block;
		color: orange;
	}
	.review-img-list a{
		display:inline-block;
		width:130px;
		height:130px;
	}
	.review-img-list a img{
		width:120px;
		height:120px;
	}
	#content>.panel-default {
		overflow : scroll;
		height : 400px;
	}
	
</style>
<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
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
		<c:if test="${not empty list}">
			<c:set var="length" value="${fn:length(list)}"/>
			<c:set var="index" value="${status.index}"/>
			<c:set var="name" value="${listNames[index]}"/>
				<h5>${name}: 총 가게 ${length}개</h5>
				<div class="slider row">
					<c:forEach items="${list}" var="store" begin="0" end="${length-1}" > 		
					    <div class="store col-md-3">
					    	<img src="${store.storeImg1}<c:if test="${store.storeImg1 eq null}">${defaultImg }</c:if>" alt="${store.name }_main1">
						</div>
					</c:forEach>
				</div>
		</c:if>
	</c:forEach> 


<!-- 카페 추천 캐러샐(부트스트랩)-->
	<c:forEach items="${storesList}" var="list" varStatus="status" begin="0" end="0">
		<c:if test="${not empty list}">		
			<c:set var="length" value="${fn:length(list)}"/>
			<c:set var="index" value="${status.index}"/>
			<c:set var="name" value="${listNames[index]}"/>
	 		<div class="mocaPick">
				<h5>${name}</h5>
				<div class="carousel slide" id="mocaPick_${index}" data-ride="carousel">
				  <!-- Indicators -->
				  <ol class="carousel-indicators">
				    <li data-target="#mocaPick_${index}" data-slide-to="0" class="active"></li>
				    <c:if test="${length gt 5}">
				   	 	<li data-target="#mocaPick_${index}" data-slide-to="1"></li>
				    </c:if>
				    <c:if test="${length gt 10}">
				    	<li data-target="#mocaPick_${index}" data-slide-to="2"></li>
				    </c:if>
				  </ol>		
				  <!-- Wrapper for slides -->
				  <div class="carousel-inner" role="listbox">
				    <div class="item active">
				     	<c:forEach items="${list}" var="store" begin="0" end="4" > 					     	
					     	<div class="item-content"><a href="./stores/${store.store_Id }">
					     		<%-- <div class="overlay">
					     			<div>
						     			<h4>${store.name}&nbsp;&nbsp;<span><fmt:formatNumber value="${store.averageLevel}" pattern="0.0"/></span></h4>					     			
						     			<h5>
						     				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>${store.viewCnt}
							     			<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>${store.reviewCnt}
							     		</h5>
						     			<h6>${store.roadAddress}</h6>
					     			</div>
					     		</div> --%>
					     		<img src="${store.storeImg1}<c:if test="${store.storeImg1 eq null}">${defaultImg }</c:if>" alt="${store.name }_main1">
					     		<img src="${store.storeImg2}<c:if test="${store.storeImg2 eq null}">${defaultImg }</c:if>" alt="${store.name }_main2">
					     		<img src="${store.storeImg3}<c:if test="${store.storeImg3 eq null}">${defaultImg }</c:if>" alt="${store.name }_main3">					     	
					     	</a></div>					     	
				     	</c:forEach>
				    </div>
				    <c:if test="${length gt 5}">
				    <div class="item">
			    		<c:set var="end">9</c:set>
				     	<c:if test="${length lt 10}"><c:set var="end">${length-1 }</c:set></c:if>
				     	<c:forEach items="${list}" var="store" begin="${end-4 }" end="${end }">				     	
					     	<div class="item-content"><a href="./stores/${store.store_Id }">
					     		<%-- <div class="overlay">
					     			<div>
						     			<h4>${store.name}&nbsp;&nbsp;<span><fmt:formatNumber value="${store.averageLevel}" pattern="0.0"/></span></h4>					     			
						     			<h5>
						     				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>${store.viewCnt}
							     			<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>${store.reviewCnt}
							     		</h5>
						     			<h6>${store.roadAddress}</h6>
					     			</div>
					     		</div> --%>
					     		<img src="${store.storeImg1}<c:if test="${store.storeImg1 eq null}">${defaultImg }</c:if>" alt="${store.name }_main1">
					     		<img src="${store.storeImg2}<c:if test="${store.storeImg2 eq null}">${defaultImg }</c:if>" alt="${store.name }_main2">
					     		<img src="${store.storeImg3}<c:if test="${store.storeImg3 eq null}">${defaultImg }</c:if>" alt="${store.name }_main3">					     	
					     	</a></div>					     	
				     	</c:forEach>				     
				    </div>
				    </c:if>     
				    <c:if test="${length gt 10}">	
					   <div class="item">
				     		<c:forEach items="${list}" var="store" begin="${length-5 }" end="${length-1 }"> 					     	
					     	<div class="item-content"><a href="./stores/${store.store_Id }">
					     		<%-- <div class="overlay">
					     			<div>
						     			<h4>${store.name}&nbsp;&nbsp;<span><fmt:formatNumber value="${store.averageLevel}" pattern="0.0"/></span></h4>					     			
						     			<h5>
						     				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>${store.viewCnt}
							     			<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>${store.reviewCnt}
							     		</h5>
						     			<h6>${store.roadAddress}</h6>
					     			</div>
					     		</div> --%>
					     		<img src="${store.storeImg1}<c:if test="${store.storeImg1 eq null}">${defaultImg }</c:if>" alt="${store.name }_main1">
					     		<img src="${store.storeImg2}<c:if test="${store.storeImg2 eq null}">${defaultImg }</c:if>" alt="${store.name }_main2">
					     		<img src="${store.storeImg3}<c:if test="${store.storeImg3 eq null}">${defaultImg }</c:if>" alt="${store.name }_main3">					     	
					     	</a></div>					     	
				     		</c:forEach>						   	
					    </div> 
					</c:if> 	  		   
				</div>	
				  <!-- Controls -->
				  <a class="left carousel-control" href="#mocaPick_${index}" role="button" data-slide="prev">
				    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
				    <span class="sr-only">Previous</span>
				  </a>
				  <a class="right carousel-control" href="#mocaPick_${index}" role="button" data-slide="next">
				    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
				    <span class="sr-only">Next</span>
				  </a>
				</div>
			</div>
		</c:if>
	</c:forEach>
	
<!-- 인기 리뷰 -->
<c:if test="${not empty bestReviews }">
	<div class="col-md-12">
		<h5>금주의 인기리뷰<span class="glyphicon glyphicon-home" aria-hidden="true"></span>
			<form action="reviewboard/best">
			  	<input type="submit" class="btn btn-default" value="상세보기"/>
		  	</form>
		</h5>
	</div>
	<div class="row panel panel-default col-md-12">
	  <div class="panel-body">
	  	<c:forEach items="${bestReviews }" var="bean">
			<div class="panel panel-default col-md-12">
			 <div class="panel-heading">
			    <h3 class="panel-title"><img src="${bean.thumbnailImage }<c:if test="${bean.thumbnailImage eq null}">${defaultThum }</c:if>" alt="${bean.nickName }"/>LV${bean.accountLevel}☕️ ${bean.nickName }</h3><h4>${bean.averageLevel}</h4>
			    <p><span class="glyphicon glyphicon-thumbs-up" aria-hidden="true">${bean.likeCount}</span><span class="glyphicon glyphicon-thumbs-down" aria-hidden="true">${bean.hateCount}</span></p>
			  </div>
			  <div class="panel-body">
			  	<h3>${bean.storeName }</h3>
			 	<p><small>${bean.writeDate }</small></p>
			  	<h4>${bean.reviewContent }</h4>
				<c:if test="${not empty bean.imageList }">
			  	<div class="review-img-list">
			  	<c:forEach items="${bean.imageList }" var="imgList" varStatus="status">			  	
		  	    <a href="#" class="thumbnail">
				  	<img src="${imgList.url }" alt="${imgList.originName }">		  	
			    </a>			  	
			  	</c:forEach>
			  	</div>
			  	</c:if>		  	
			  </div>
			</div>
		</c:forEach>
	  </div>
	</div>
</c:if>	
<!-- 최신 리뷰 -->
<c:if test="${not empty recentReviews }">
	<div class="col-md-12">
		<h5>최신 리뷰<span class="glyphicon glyphicon-home" aria-hidden="true"></span>
			<form action="reviewboard/recent">
		  	<input type="submit" class="btn btn-default" value="상세보기"/>
		  	</form>
	  	</h5>
	</div>
	<div class="row recentReviews">
		<c:forEach items="${recentReviews }" var="bean">
			<div class="review col-md-8 col-md-offset-1">
				<h3>${bean.storeName}</h3>				
				<img src="${bean.thumbnailImage }<c:if test="${bean.thumbnailImage eq null}">${defaultThum }</c:if>" alt="${bean.nickName }"/>
				${bean.nickName } Lv${bean.accountLevel}
				<c:forEach begin="1" end="${bean.averageLevel}">★</c:forEach>
				 ${bean.writeDate }
				<h4>${bean.reviewContent }</h4>
			</div>
		</c:forEach>
	</div>
	<div class="row panel panel-default col-md-12">
	  <div class="panel-body">
	  	<c:forEach items="${recentReviews }" var="bean">	  	
			<div class="panel panel-default col-md-12">
			 <div class="panel-heading">
			    <h3 class="panel-title"><img src="${bean.thumbnailImage }<c:if test="${bean.thumbnailImage eq null}">${defaultThum }</c:if>" alt="${bean.nickName }"/>LV${bean.accountLevel}☕️ ${bean.nickName } </h3><h4>${bean.averageLevel}</h4>
			    <p><span class="glyphicon glyphicon-thumbs-up" aria-hidden="true">${bean.likeCount}</span><span class="glyphicon glyphicon-thumbs-down" aria-hidden="true">${bean.hateCount}</span></p>
			  </div>
			  <div class="panel-body">
			  	<h3>${bean.storeName }</h3>
			 	<p><small>${bean.writeDate }</small></p>
			  	<h4>${bean.reviewContent }</h4>
			  	<c:if test="${not empty bean.imageList }">
			  	<div class="review-img-list">
			  	<c:forEach items="${bean.imageList }" var="imgList" varStatus="status">
			  	    <a href="#" class="thumbnail">
					  	<img src="${imgList.url }" alt="${imgList.originName }">		  	
				    </a>			  	
			  	</c:forEach>
			  	</div>
			  	</c:if>
			  </div>
			</div>
		</c:forEach>
	  </div>
	</div>
</c:if>
</div>
</body>
</html>
