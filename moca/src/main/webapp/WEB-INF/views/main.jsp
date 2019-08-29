<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html>
<head>
<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.css"/>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.css"/>
<style type="text/css">
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
</style>
<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
<script type="text/javascript">
	//GeoLocation API에서 현재 위치의 위도&경도 얻기
	var lat, lng;	
	var slide;
    window.onload = function () { 
    	//디폴트 위치 정보 지정(비트캠프 강남 센터! :p) 
    	lat = 37.4995011;			 //위도
        lng = 127.0291403;			//경도
        $('.lat').val(lat);
		$('.lng').val(lng); 		
    	//접속 브라우저의 웹 지오로케이션 지원 여부 판단  
        if (navigator.geolocation){             		       
            var options = { timeout: 2000, maximumAge: 3000, enableHighAccuracy: true};	//highAccuracy true: 모바일 기기는 GPS로 위치 정보 확인             
            navigator.geolocation.getCurrentPosition(sucCall, errCall, options);		//현재 위치 정보 얻기
        }
         /* $.ajax({
            url:"hits",
            dataType: "json",
        	success: function(data){
				hits=data;		
				console.log(hits[1].storeImg1);		
            }
         }); */
        $('.suggestion a li').mouseenter(function(){
            var overlay = $(this).children('div');
           // overlay.show();
            var imgs = $(this).children('img');
            var i=0;
          	//이미지 슬라이드 함수
        	(function slideFunction(){
        		imgs.hide();
        		$(imgs[i]).show();
        		if(i==2) i=0; else i++;
        		slide = setTimeout(slideFunction, 500);
        	})();        
        });
         
        $('.suggestion a li').mouseleave(function(){
            clearTimeout(slide);
			$(this).children().hide();
			var firstImg = $(this).children()[1];
			$(firstImg).show();
        });
    };
	
    //Success Callback(현재 위치 정보 저장)
    var sucCall = function (position) {
        lat = position.coords.latitude;	    //위도
        lng = position.coords.longitude;	//경도
		$('.lat').val(lat);
		$('.lng').val(lng);
    };

    // Error Callback(에러 메시지 출력)
    function errCall(error) {
    	tryAPIGeolocation();		//구글GeolocationAPI시도
    };

  //구글 GeolocationAPI Key값 받고, 실행
	var tryAPIGeolocation = function() {		
		$.ajax({
			url:"moneysaver/googleGeolocation",
			dataType: "text",
			method: "post",
			success: function(googleKey){
				jQuery.post(googleKey, function(success) {
			        apiGeolocationSuccess({coords: {latitude: success.location.lat, longitude: success.location.lng}});
			    }).fail(function(err) {
			        	switch (err.code) {
			            case err.PERMISSION_DENIED:
			            	alert("현재 위치 정보 접근이 차단되었습니다.\n정확한 검색을 원하시면 접근을 허용해주세요.");
			                break;  
			        	}  
			    });
			}
		});		
	};

 	//구글GeolocationAPI Success Callback
	var apiGeolocationSuccess = function(position) {
		lat = position.coords.latitude;	    //위도
	    lng = position.coords.longitude;	//경도
		$('.lat').val(lat);
		$('.lng').val(lng);
	};
    
	</script>
</head>
<body>
<div id="header">
			<jsp:include page="../../resources/template/header.jsp" flush="true"></jsp:include>
</div>
<div id="content" class="container-fluid">
	<c:if test="${not empty hitStores }">
		<c:set var="length" value="${fn:length(hitStores)}"/>
 		<div class="row suggestion">
			<div class="col-md-12">
				<h5>지금 뜨는 카페 <span class="glyphicon glyphicon-home" aria-hidden="true"></span></h5>
			</div>
			<div class="col-md-12 carousel slide" id="hitStores" data-ride="carousel">
			  <!-- Indicators -->
			  <ol class="carousel-indicators">
			    <li data-target="#hitStores" data-slide-to="0" class="active"></li>
			    <c:if test="${length gt 5}">
			   	 	<li data-target="#hitStores" data-slide-to="1"></li>
			    </c:if>
			    <c:if test="${length gt 10}">
			    	<li data-target="#hitStores" data-slide-to="2"></li>
			    </c:if>
			  </ol>		
			  <!-- Wrapper for slides -->
			  <div class="carousel-inner" role="listbox">
			    <div class="item active">
			     <ul class="item-inner" style="list-style:none">
			     	<c:forEach items="${hitStores}" var="bean" begin="0" end="4" > 
				     	<a href="./stores/${bean.store_Id }"><li style="float:left; width:300px; height:300px;border:black 1px solid;">
				     		<div style="width:300px; height:300px; background-color:#ffffff; opacity:0.6; filter: alpha(opacity=60); display:none;"></div>
				     		<img style="width:300px; height:300px;" src="${bean.storeImg1 }" alt="${bean.name }_main1">
				     		<img style="width:300px; height:300px; display:none;" src="${bean.storeImg2 }" alt="${bean.name }_main2">
				     		<img style="width:300px; height:300px; display:none;" src="${bean.storeImg3 }" alt="${bean.name }_main3">
				     	</li></a>
			     	</c:forEach>
			     </ul>	
			    </div>
			    <c:if test="${length gt 5}">
			    <div class="item">
			     <ul class="item-inner" style="list-style:none">
			     	<c:forEach items="${hitStores}" var="bean" begin="5" end="9"> 
				     	<a href="./stores/${bean.store_Id }"><li style="float:left; width:300px; height:300px;border:black 1px solid;">
				     		<img style="width:300px; height:300px;" src="${bean.storeImg1 }" alt="${bean.name }_main1">
				     		<img style="width:300px; height:300px; display:none;" src="${bean.storeImg2 }" alt="${bean.name }_main2">
				     		<img style="width:300px; height:300px; display:none;" src="${bean.storeImg3 }" alt="${bean.name }_main3">
				     	</li></a>
			     	</c:forEach> 
			     </ul>		
			    </div>
			    </c:if>     
			    <c:if test="${length gt 10}">	
				   <div class="item">		    
				     <ul class="item-inner" style="list-style:none">
				     	<c:forEach items="${hitStores}" var="bean" begin="10" end="12"> 
					     	<a href="./stores/${bean.store_Id }"><li style="float:left; width:300px; height:300px;border:black 1px solid;">
					     		<img style="width:300px; height:300px;" src="${bean.storeImg1 }" alt="${bean.name }_main1">
				     			<img style="width:300px; height:300px; display:none;" src="${bean.storeImg2 }" alt="${bean.name }_main2">
				     			<img style="width:300px; height:300px; display:none;" src="${bean.storeImg3 }" alt="${bean.name }_main3">
					     	</li></a>
				     	</c:forEach>
				     </ul>		     
				    </div> 
				</c:if> 	  		   
				  </div>	
			  <!-- Controls -->
			  <a class="left carousel-control" href="#hitStores" role="button" data-slide="prev">
			    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
			    <span class="sr-only">Previous</span>
			  </a>
			  <a class="right carousel-control" href="#hitStores" role="button" data-slide="next">
			    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
			    <span class="sr-only">Next</span>
			  </a>
			</div>
		</div>
	</c:if>
</div>
</body>
</html>