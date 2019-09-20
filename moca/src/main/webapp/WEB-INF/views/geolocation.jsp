<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="resources/css/loader.css">
<style type="text/css">
	html, body{
		/* height: 100%; */
	}
	
	#content{
		width:100%;
		text-align : center;
		margin-top : 30%;
		
	}
	
	.loader{
		position : absolute;
		left : 50%;
		top : 10%;
		transform: translateX(-50%);
		
	}
	#loader_info{
		position : absolute;
		margin : 0 auto;
		top:40%;
		left:50%;
		text-align:center;
		transform: translateX(-50%);
	}
	#loader_info img{
		height : 200px;
		width : auto;
	}

</style>
<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
//GeoLocation API에서 현재 위치의 위도&경도 얻기
	var lat, lng;	
    window.onload = function () {     	
    	//접속 브라우저의 웹 지오로케이션 지원 여부 판단  
        if (navigator.geolocation){             		       
            var options = { timeout: 2000, maximumAge: 3000, enableHighAccuracy: true};	//highAccuracy true: 모바일 기기는 GPS로 위치 정보 확인             
            navigator.geolocation.getCurrentPosition(sucCall,  errCall, options);		//현재 위치 정보 얻기
        }else{
        	tryAPIGeolocation();
        }
    };
	
    //Success Callback(현재 위치 정보 저장)
    var sucCall = function (position) {
        lat = position.coords.latitude;	    //위도
        lng = position.coords.longitude;	//경도        
		$('.lat').val(lat);
		$('.lng').val(lng);
		$('form').submit();
    };

    // Error Callback(에러 메시지 출력)
    function errCall(error) {
        if(error.code == 1){}		//사용자가 거부한 상태 -> 나중에 허용 거부 푸는 페이지에서 활용하기!
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
			    	$('.lat').val("37.497900");
					$('.lng').val("127.027637");
				   	alert("지역 정보를 가져올 수 없습니다... :( 강남역을 기준으로 검색합니다");		//이 부분 정리하기
			    	$('form').submit();
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
		$('form').submit();
	};
	</script>
</head>
<body>
<form class="navbar-form navbar-left">
    <div class="form-group">
          <input type="hidden" name="lng" class="lng"/>
		  <input type="hidden" name="lat" class="lat"/>		
   	</div>
</form>
<div class="loader">
Loading...
</div>
<div id="loader_info">
	<img src="resources/imgs/logo/verticalLogo(moca).png">
	<h4>. . .위치 정보를 받아오는 중입니다. . .</h4>
	<h4>정확한 검색 결과를 위해 위치 정보 수집을 허용해 주세요 :) </h4>
</div>
</body>
</html>