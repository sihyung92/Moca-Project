<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.css"/>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.css"/>
<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
<script type="text/javascript">
	//GeoLocation API에서 현재 위치의 위도&경도 얻기
	var lat, lng;	
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

    };

    //Success Callback(현재 위치 정보 저장)
    var sucCall = function (position) {
        lat = position.coords.latitude;	    //위도
        lng = position.coords.longitude;	//경도
		$('.lat').val(lat);
		$('.lng').val(lng);
    	cafesNearBy();
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
		cafesNearBy();
	};
	
	function cafesNearBy(){
	 	$.ajax({
			url:"near",
			data : {"x":lng,"y":lat},
			dataType: "JSON",
			method: "get",
			error: function(){
				$('.cafesNearBy').remove();
				console.log('근처카페추천 비동기 실패했당..');
			},
			success: function(data){
				var length=$(data).length;
				$(data).each(function(idx,ele){
					if(ele.storeImg1==null){
						ele.storeImg1='';
					}
					
					if(idx<5){
						$('#carousel-example-generic .item:nth-child(1) .item-inner')
						.append('<a href="stores/'+ele.store_Id+'"><li style="float:left; width:300px; height:300px;">'
						+'<img width="300px" height="300px" src="'+ele.storeImg1+'" alt="디폴트이미지소스"></li></a>');	     	
					}else if(idx<10){
						$('#carousel-example-generic .item:nth-child(2) .item-inner')
						.append('<a href="stores/'+ele.store_Id+'"><li style="float:left; width:300px; height:300px;">'
						+'<img width="300px" height="300px" src="'+ele.storeImg1+'" alt="디폴트이미지소스"></li></a>');	     	
					}else{
						$('#carousel-example-generic .item:nth-child(3) .item-inner')
						.append('<a href="stores/'+ele.store_Id+'"><li style="float:left; width:300px; height:300px;">'
						+'<img width="300px" height="300px" src="'+ele.storeImg1+'" alt="디폴트이미지소스"></li></a>');	     	
					}
				});
				
				if(length==0){
					$('.cafesNearBy').remove();
				}else if(length<5){
					$('.carousel-inner>.item').not('.item:first-child').remove();
					$('.carousel-indicators li').not('li:first-child').remove();
					$('.carousel-control').remove();
					$('.cafesNearBy').show()
				}else if(length<10){
					$('.carousel-inner>.item:last-child').remove();
					$('.carousel-indicators li:last-child').remove();
					$('.cafesNearBy').show()
				}
			}
		});
	};
	</script>
</head>
<body>
<div id="header">
			<jsp:include page="../../resources/template/header.jsp" flush="true"></jsp:include>
</div>
<div id="content" class="container-fluid">
	<div class="row cafesNearBy" style="display:hidden;">
		<div class="col-md-12">
			<h5>주변 추천 카페 <span class="glyphicon glyphicon-home" aria-hidden="true"></span></h5>
		</div> 
		<div class="col-md-12 carousel slide" id="carousel-example-generic" data-ride="carousel" style="height:300px;">
		  <!-- Indicators -->
		  <ol class="carousel-indicators">
		    <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
			<li data-target="#carousel-example-generic" data-slide-to="1"></li>
		    <li data-target="#carousel-example-generic" data-slide-to="2"></li>
		  </ol>
		
		  <!-- Wrapper for slides -->
		  <div class="carousel-inner" role="listbox" >
		    <div class="item active" style="text-align:center;">
		     <ul class="item-inner" style="list-style:none; text-align:center;">
		     </ul>
		    </div>
		    <div class="item" style="text-align:center;">
		     <ul class="item-inner" style="list-style:none; text-align:center;">
		     </ul>
		    </div>
		    <div class="item" style="text-align:center;">
		     <ul class="item-inner" style="list-style:none; text-align:center;">
		     </ul>
		    </div>
		  </div>
				  <!-- Controls -->
		  <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
		    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
		    <span class="sr-only">Previous</span>
		  </a>
		  <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
		    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
		    <span class="sr-only">Next</span>
		  </a>
		</div>
	</div>
</div>
</body>
</html>