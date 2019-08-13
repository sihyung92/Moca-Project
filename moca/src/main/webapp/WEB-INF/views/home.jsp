<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<title>Home</title>
	<script src="https://code.jquery.com/jquery-1.12.4.js" integrity="sha256-Qw82+bXyGq6MydymqBxNPYTaUXXq7c8v3CwiYwLLNXU=" crossorigin="anonymous"></script>
	<script type="text/javascript">
	//GeoLocation API에서 현재 위치의 위도&경도 얻기
    window.onload = function () {
        // DOM 객체 얻기
        span = document.getElementById("display");
        //
        if (navigator.geolocation) // 브라우저에서 웹 지오로케이션 지원여부 판단
        {
            alert("GeoLocation API 를 지원하는 브라우저");
            // PositionOptions 객체 설정용
            var options = { timeout: 2000, maximumAge: 3000 };
            options.enableHighAccuracy = true;
            // 현재 위치정보 딱 한번 얻기
            navigator.geolocation.getCurrentPosition(sucCall, errCall, options);
        }
        else {
            alert("GeoLocation API 를 지원하지 않는 브라우저 입니다.");
        }
    };

    //Success Callback
    var sucCall = function (position) {
        // 위도, 경도 얻기
        var lat = position.coords.latitude;	    //위도
        var lng = position.coords.longitude;	//경도
		$('#lat').val(lat);
		$('#lng').val(lng);
    };

    // Error Callback
    function errCall(error) {
        switch (error.code) {
            case 1:
                alert("허용거부됨");
                break;
            case 2:
                alert("위치 확인 불가");
                break;
            case 3:
                alert("시간초과");
                break;
            case 0:
                alert("알 수 없는 오류");
                break;
            default:
                alert(error.message);
        }
    };
	</script>
</head>
<body>
<h1>메인 페이지</h1>
<form action="search">
	<input type="hidden" name="x" id="lng"/>
	<input type="hidden" name="y" id="lat"/>
	키워드는 <input type="text" name="keyword"/>
	<button>입니당</button>
</form>	
</body>
</html>
