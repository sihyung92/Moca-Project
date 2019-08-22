<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<title>Home</title>
	<style type="text/css">
	#header{
		background-color:pink;
	}
	</style>
<script src="https://code.jquery.com/jquery-1.12.4.js" integrity="sha256-Qw82+bXyGq6MydymqBxNPYTaUXXq7c8v3CwiYwLLNXU=" crossorigin="anonymous"></script>
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
    };

    // Error Callback(에러 메시지 출력)
    function errCall(error) {
        switch (error.code) {
            case error.PERMISSION_DENIED:
            	alert("현재 위치 정보 접근이 차단되었습니다.\n정확한 검색을 원하시면 접근을 허용해주세요.");
                break;           
        }
    };
	</script>
</head>
<body>
<div id="header">
	<form action="stores">
		<input type="hidden" name="x" class="lng"/>
		<input type="hidden" name="y" class="lat"/>		
		<input type="hidden" name="filter" value="distance"/>
		키워드는 <input type="text" name="keyword"/>
		<button>입니당</button>
	</form>		
	<br/>
</div>
</body>
</html>
