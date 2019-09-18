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
		background-color: lightgray;
		position: absolute;
		top: 70%;
		left: 50%;
   	 	transform: translate(-50%, -50%);
	}
	#searchBar_main .form-control{					/* 검색어 input 태그 */
		font-size: 20px;
		height: 50px;
		width: 500px;
		border-radius: 25px;
	}
	#searchBar_main button{
		font-size: 25px;
	}
/* body content */	
	/* 모카픽 추천 캐러셀 */
	.mocaPick-list{
		color: dimgray;
	}	
	.mocaPick-list .bx-wrapper{
		border: none;
		box-shadow: none;
		margin-bottom: 50px;
		z-index: 3;
		border: lightgray 1px solid;
		border-radius: 2px;
		background-color: rgba(246,245,239,0.5);
	}
	.bx-wrapper .bx-viewport .mocaPick .store{
		height: 200px;		
	}	
	.bx-wrapper .bx-viewport .mocaPick .store .storeInfo{
		position: absolute;
		z-index: 2;
		height: 60px;
		bottom: -60px;
	}
	.storeInfo .mocaPick-storeName{
		font-size: 17px;
		font-weight: bold;
	}
	.storeInfo .mocaPick-averageLevel{
		font-size: 16px;
		color: rgb(198,161,83);
	}
	.bx-wrapper .bx-viewport .mocaPick .store img{
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
	#review-list{
		color: dimgray;
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
	
	@media (max-width: 768px){
		.bx-wrapper{
			margin-bottom: 20px;
		}
		#header{
			position: relative;
			height: 250px;
			background-image: url("resources/imgs/main_background5.jpg");
			background-size: cover;
		}
		#searchBar_main{
			font-size: 0;
			background-color: lightgray;
			position: absolute;
			top: 70%;
			left: 50%;
	   	 	transform: translate(-50%, -50%);
	   	 	width: 80%;
		} 
		#searchBar_main .form-control{
			font-size: 20px;
			height: 50px;
			width: 100%;
			border-radius: 25px;
		}
		#searchBar_main button{
			font-size: 25px;
		}
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
        $('div#header+div').css('padding-top', '10px');
        $(window).width();
   	 	//bxSlider 시작 
   	 	
    	$('.mocaPick').bxSlider({
    		pager: false,
    		autoReload: true,
    		//captions: true,
    		slideMargin: 1,
    		minSlides: 1,
    		maxSlides: 7,
    		moveSlides: 3,    		
    		slideWidth: 300,
    		onSliderLoad: function(){
        		$('.bx-viewport').css('height', '260px');
            },
    		onSliderResize: function(){
        		$('.bx-viewport').css('height', '260px');
            }
    	});     	
    	//캐러셀 mouseDown 이벤트(해당 카페 디테일 페이지로 이동)
    	$('.store').on('mousedown', function(){
        	store_id = $(this).children().first().attr('alt').split(" ")[0];
			window.location.href="./stores/"+store_id;
        });  
        //캐러셀 mouseEnter: 이미지 슬라이드 & 오버레이 이벤트
        $('.mocaPick li a').on("mouseenter", mouseEnter);
        //캐러셀 mouesLeave: 원복
        $('.mocaPick li a').on("mouseleave", mouseLeave);
		//스크롤 일정 이상 내려가면 추천 카페 데이터 추가	
    	$(window).on("scroll", updateData);
    	//스크롤 위치에 따라 헤더 배경 토글
    	$(window).on("scroll", changeHeaderColor);    	
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
    //스크롤 위치에 따라 헤더 배경색 변경
    function changeHeaderColor(){
    	var position = $(window).scrollTop();
    	var width = $(window).width();
    	if(width>768){
    		if(position > 438){
            	$('#searchBar').show();
            	$('#header .navbar').css('background-color', 'rgba(255,255,255, 1)');
            }else{
            	$('#searchBar').hide();
            	$('#header .navbar').css('background-color', 'transparent');
            }
        }else{
        	if(position > 188){
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
	<form id="searchBar_main" class="form-inline" action="<c:url value="/stores"/>">
      <div class="form-group">
        <input type="text" name="keyword" id="keyword_main" class="form-control" placeholder="카페를 검색해보세요:D"/>	
  		<input type="hidden" name="filter" value="distance"/>
      </div>
      <button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
    </form>
</div>
<div id="content" class="container-fluid">
	<c:set var="defaultImg"><c:url value="/resources/imgs/reviewDefault.png"/></c:set>
	<c:set var="defaultThum"><c:url value="/resources/imgs/basicProfile.png"/></c:set>
<!-- 카페 추천 캐러샐(bxSlider)-->
	<div class="mocaPick-list">
	 	<c:forEach items="${storesList}" var="list" varStatus="status">
			<c:if test="${not empty list}">
				<c:set var="length" value="${fn:length(list)}"/>
				<c:set var="index" value="${status.index}"/>
				<c:set var="name" value="${listNames[index]}"/>
					<h5>${name}: 총 가게 ${length}개</h5>
					<div class="mocaPick">
						<c:forEach items="${list}" var="store" begin="0" end="${length-1}" > 		
						    <div class="store">
						    	<img src="${store.storeImg1}<c:if test="${store.storeImg1 eq null}">${defaultImg }</c:if>" alt="${store.store_Id} ${store.name }_main1" title="${store.name} <fmt:formatNumber value="${store.averageLevel}" pattern="0.0"/>">
						    	<img src="${store.storeImg2}<c:if test="${store.storeImg2 eq null}">${defaultImg }</c:if>" alt="${store.store_Id} ${store.name }_main2">
						    	<img src="${store.storeImg3}<c:if test="${store.storeImg3 eq null}">${defaultImg }</c:if>" alt="${store.store_Id} ${store.name }_main3">
								<div class="storeInfo">
					     			<span class="mocaPick-storeName">${store.name}&nbsp;&nbsp;<span class="mocaPick-averageLevel"><fmt:formatNumber value="${store.averageLevel}" pattern="0.0"/></span></span><br/>			     			
					     			<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span><span>${store.viewCnt}</span>
						     		<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span><span>${store.reviewCnt}</span><br/>
					     			<%-- <span>${store.roadAddress}</span> --%>
				     			</div>
							</div>
						</c:forEach>
					</div>
			</c:if>
		</c:forEach> 
	</div>
<!-- 카페 추천 캐러샐(부트스트랩)-->
 <%-- 	<c:foreach items="${storeslist}" var="list" varstatus="status" begin="0" end="0">
		<c:if test="${not empty list}">		
			<c:set var="length" value="${fn:length(list)}"/>
			<c:set var="index" value="${status.index}"/>
			<c:set var="name" value="${listnames[index]}"/>
	 		<div class="mocapick">
				<h5>${name}</h5>
				<div class="carousel slide" id="mocapick_${index}" data-ride="carousel">
				  <!-- indicators -->
				  <ol class="carousel-indicators">
				    <li data-target="#mocapick_${index}" data-slide-to="0" class="active"></li>
				    <c:if test="${length gt 5}">
				   	 	<li data-target="#mocapick_${index}" data-slide-to="1"></li>
				    </c:if>
				    <c:if test="${length gt 10}">
				    	<li data-target="#mocapick_${index}" data-slide-to="2"></li>
				    </c:if>
				  </ol>		
				  <!-- wrapper for slides -->
				  <div class="carousel-inner" role="listbox">
				    <div class="item active">
				     	<c:foreach items="${list}" var="store" begin="0" end="4" > 					     	
					     	<div class="item-content"><a href="./stores/${store.store_id }">
					     		<div class="overlay">
					     			<div>
						     			<h4>${store.name}&nbsp;&nbsp;<span><fmt:formatnumber value="${store.averagelevel}" pattern="0.0"/></span></h4>					     			
						     			<h5>
						     				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>${store.viewcnt}
							     			<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>${store.reviewcnt}
							     		</h5>
						     			<h6>${store.roadaddress}</h6>
					     			</div>
					     		</div>
					     		<img src="${store.storeimg1}<c:if test="${store.storeimg1 eq null}">${defaultimg }</c:if>" alt="${store.name }_main1">
					     		<img src="${store.storeimg2}<c:if test="${store.storeimg2 eq null}">${defaultimg }</c:if>" alt="${store.name }_main2">
					     		<img src="${store.storeimg3}<c:if test="${store.storeimg3 eq null}">${defaultimg }</c:if>" alt="${store.name }_main3">					     	
					     	</a></div>					     	
				     	</c:foreach>
				    </div>
				    <c:if test="${length gt 5}">
				    <div class="item">
			    		<c:set var="end">9</c:set>
				     	<c:if test="${length lt 10}"><c:set var="end">${length-1 }</c:set></c:if>
				     	<c:foreach items="${list}" var="store" begin="${end-4 }" end="${end }">				     	
					     	<div class="item-content"><a href="./stores/${store.store_id }">
					     		<div class="overlay">
					     			<div>
						     			<h4>${store.name}&nbsp;&nbsp;<span><fmt:formatnumber value="${store.averagelevel}" pattern="0.0"/></span></h4>					     			
						     			<h5>
						     				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>${store.viewcnt}
							     			<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>${store.reviewcnt}
							     		</h5>
						     			<h6>${store.roadaddress}</h6>
					     			</div>
					     		</div>
					     		<img src="${store.storeimg1}<c:if test="${store.storeimg1 eq null}">${defaultimg }</c:if>" alt="${store.name }_main1">
					     		<img src="${store.storeimg2}<c:if test="${store.storeimg2 eq null}">${defaultimg }</c:if>" alt="${store.name }_main2">
					     		<img src="${store.storeimg3}<c:if test="${store.storeimg3 eq null}">${defaultimg }</c:if>" alt="${store.name }_main3">					     	
					     	</a></div>					     	
				     	</c:foreach>				     
				    </div>
				    </c:if>     
				    <c:if test="${length gt 10}">	
					   <div class="item">
				     		<c:foreach items="${list}" var="store" begin="${length-5 }" end="${length-1 }"> 					     	
					     	<div class="item-content"><a href="./stores/${store.store_id }">
					     		<div class="overlay">
					     			<div>
						     			<h4>${store.name}&nbsp;&nbsp;<span><fmt:formatnumber value="${store.averagelevel}" pattern="0.0"/></span></h4>					     			
						     			<h5>
						     				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>${store.viewcnt}
							     			<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>${store.reviewcnt}
							     		</h5>
						     			<h6>${store.roadaddress}</h6>
					     			</div>
					     		</div>
					     		<img src="${store.storeimg1}<c:if test="${store.storeimg1 eq null}">${defaultimg }</c:if>" alt="${store.name }_main1">
					     		<img src="${store.storeimg2}<c:if test="${store.storeimg2 eq null}">${defaultimg }</c:if>" alt="${store.name }_main2">
					     		<img src="${store.storeimg3}<c:if test="${store.storeimg3 eq null}">${defaultimg }</c:if>" alt="${store.name }_main3">					     	
					     	</a></div>					     	
				     		</c:foreach>						   	
					    </div> 
					</c:if> 	  		   
				</div>	
				  <!-- controls -->
				  <a class="left carousel-control" href="#mocapick_${index}" role="button" data-slide="prev">
				    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
				    <span class="sr-only">previous</span>
				  </a>
				  <a class="right carousel-control" href="#mocapick_${index}" role="button" data-slide="next">
				    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
				    <span class="sr-only">next</span>
				  </a>
				</div>
			</div>
		</c:if>
	</c:foreach>
<br/><br/> --%>
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
