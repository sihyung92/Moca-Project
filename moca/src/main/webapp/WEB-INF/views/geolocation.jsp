<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
//GeoLocation API에서 현재 위치의 위도&경도 얻기
	var lat, lng;	
    window.onload = function () {     	
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
		$('form').submit();
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
		$('form').submit();
	};
	</script>
</head>
<body>
	<form class="navbar-form navbar-left">
	    <div class="form-group">
	          <input type="hidden" name="x" class="lng"/>
			  <input type="hidden" name="y" class="lat"/>		
	   	</div>
	</form>
</body>
</html>