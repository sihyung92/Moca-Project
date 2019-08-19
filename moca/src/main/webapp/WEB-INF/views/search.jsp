<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.List, com.kkssj.moca.model.entity.StoreVo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	#header{
		background-color:pink;
	}
	#search{
		text-align: center;
	}
	.links{
		border: 1px solid purple;
	}
	.label{
		background-color: white;
	}
	.center{
		color : black;
	}
	.seoul{
		border : 1px solid black;
	}
	.gyeonggi{
		border : 1px solid black;
	}
	.S_Region{
		display : none;
	}
	.G_Region{
		display : none;
	}
	
</style>
<script src="https://code.jquery.com/jquery-1.12.4.js" integrity="sha256-Qw82+bXyGq6MydymqBxNPYTaUXXq7c8v3CwiYwLLNXU=" crossorigin="anonymous"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e63ece9668927d2e8027037f0aeb06b5"></script>
<script type="text/javascript">
	var lat,lng;
		
    window.onload = function () {  
//카페 리스트 클릭 이벤트 / POST방식으로 Detail페이지 이동
        $('.links').click(function(){
           	$(this).children().first().submit();
        });
//지역 필터 클릭 이벤트
		$('.seoul').click(function(){
			$('.S_Region').toggle();
		})
		$('.gyeonggi').click(function(){
			$('.G_Region').toggle();
		});
//GeoLocation API에서 현재 위치의 위도&경도 얻기
        if (navigator.geolocation) // 브라우저에서 웹 지오로케이션 지원여부 판단
        {
           	//alert("GeoLocation API 를 지원하는 브라우저");
            // PositionOptions 객체 설정용
            var options = { timeout: 2000, maximumAge: 3000 };
            options.enableHighAccuracy = true;
            // 현재 위치정보 딱 한번 얻기
            navigator.geolocation.getCurrentPosition(sucCall, errCall, options);
        }
        else {
            alert("GeoLocation API 를 지원하지 않는 브라우저 입니다.");
        }
        
//카카오맵 API연결
        var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
        if(lat==null || lng==null){
                lat=37.4995011;
    			lng=127.0291403;
        }
        var options = { //지도를 생성할 때 필요한 기본 옵션
        	center: new kakao.maps.LatLng(lat, lng), //지도의 중심좌표.        	
        	level: 3 //지도의 레벨(확대, 축소 정도)
        };

        var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

     	// 지도를 재설정할 범위정보를 가지고 있을 LatLngBounds 객체를 생성합니다
		var bounds = new kakao.maps.LatLngBounds();    
		var i,marker;
		
		// 커스텀 오버레이에 표시할 내용입니다     
		// HTML 문자열 또는 Dom Element 입니다 
		 
	 	var listSize = ${fn:length(alist)};
	 	
		var latLngList = new Array();
		var nameList = new Array();
			<c:forEach items="${alist}" var="data">
			latLngList.push({'lat':'${data.yLocation}','lng':'${data.xLocation}'});
			nameList.push('${data.name}');
			</c:forEach>
		
		// 버튼을 클릭하면 아래 배열의 좌표들이 모두 보이게 지도 범위를 재설정합니다 
		for (i = 0; i < listSize; i++) {
			// 배열의 좌표들이 잘 보이게 마커를 지도에 추가합니다
			var position =new kakao.maps.LatLng(latLngList[i].lat,latLngList[i].lng);
			marker = new kakao.maps.Marker({ position : position});
			var content = '<div class ="label"><span class="left"></span><span class="center">'+
			nameList[i]+'</span><span class="right"></span></div>';
			var overlay = new kakao.maps.CustomOverlay({
			    content: content,
			    position: marker.getPosition()       
			});
			
		    // 마커에 이벤트를 등록하는 함수 만들고 즉시 호출하여 클로저를 만듭니다
		    // 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
		    (function(marker, overlay) {
		        // 마커에 mouseover 이벤트를 등록하고 마우스 오버 시 인포윈도우를 표시합니다 
		        kakao.maps.event.addListener(marker, 'mouseover', function() {
		        	overlay.setMap(map);
		        });	
	
	        	// 마커에 mouseout 이벤트를 등록하고 마우스 아웃 시 인포윈도우를 닫습니다
		        kakao.maps.event.addListener(marker, 'mouseout', function() {
		        	overlay.setMap(null); 
		        });
	   		})(marker, overlay);
		marker.setMap(map);
		// LatLngBounds 객체에 좌표를 추가합니다
		bounds.extend(position);
		}
		
		setBounds();
		
	   	function setBounds() {
	   	// LatLngBounds 객체에 추가된 좌표들을 기준으로 지도의 범위를 재설정합니다
	   	// 이때 지도의 중심좌표와 레벨이 변경될 수 있습니다
	   	map.setBounds(bounds);
	   	}        
    };

    //위도, 경도 얻기 Success Callback
    var sucCall = function (position) {
        // 위도, 경도 얻기
        lat = position.coords.latitude;	    //위도
        lng = position.coords.longitude;	//경도
		$('#lat').val(lat);
		$('#lng').val(lng);
		alert("lat: "+$('#lat').val()+", lng: "+$('#lng').val());
    };

    //위도, 경도 얻기 Error Callback
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
<h1>검색 페이지</h1>
<div id="header">
	<br/>
	<form action="search">
		<input type="hidden" name="x" id="lng"/>
		<input type="hidden" name="y" id="lat"/>
		<input type="hidden" name="filter" value="distance"/>
		키워드는 <input type="text" name="keyword"/>
		<button>입니당</button>
	</form>	
	<br/>
</div>
--------------------------------------------------------------------------------------------------------여기까지 header 아아아아--------------------------------------------------------------------------------------------------------
<br/><br/>
<div id="search">
	<form action="search">
		<input type="hidden" name="x" id="lng"/>
		<input type="hidden" name="y" id="lat"/>
		키워드는 <input type="text" name="keyword" value="${keyword}"/> 입니당
		<br/>
		<input type="radio" name="filter" value="averageLevel" <c:if test="${filter eq 'averageLevel'}">checked="checked"</c:if>><span>평점순</span>
		<input type="radio" name="filter" value="reviewCnt" <c:if test="${filter eq 'reviewCnt'}">checked="checked"</c:if>><span>리뷰순</span>
		<input type="radio" name="filter" value="viewCnt" <c:if test="${filter eq 'viewCnt'}">checked="checked"</c:if>><span>조회순</span>
		<input type="radio" name="filter" value="distance" <c:if test="${filter eq 'distance'}">checked="checked"</c:if>><span>거리순</span>
		<button>검색</button>
		${filter }

		<span class="seoul">서울</span>
		<div class="S_Region">
			<input type="radio" name="region" value="강남구"><span>강남</span>
			<input type="radio" name="region" value="강동구"><span>강동</span>
			<input type="radio" name="region" value="강북구"><span>강북</span>
			<input type="radio" name="region" value="강서구"><span>강북</span>
			<input type="radio" name="region" value="관악구"><span>관악</span>
			<input type="radio" name="region" value="광진구"><span>광진</span>
			<input type="radio" name="region" value="구로구"><span>구로</span>
			<input type="radio" name="region" value="금천구"><span>금천</span>
			<input type="radio" name="region" value="노원구"><span>노원</span>
			<input type="radio" name="region" value="도봉구"><span>도봉</span>
			<input type="radio" name="region" value="동대문구"><span>동대문</span>
			<input type="radio" name="region" value="마포구"><span>마포</span>
			<input type="radio" name="region" value="서대문구"><span>서대문</span>
			<input type="radio" name="region" value="서초구"><span>서초</span>
			<input type="radio" name="region" value="성동구"><span>성동</span>
			<input type="radio" name="region" value="성북구"><span>성북</span>
			<input type="radio" name="region" value="송파구"><span>송파</span>
			<input type="radio" name="region" value="양천구"><span>양천</span>
			<input type="radio" name="region" value="영등포구"><span>영등포</span>
			<input type="radio" name="region" value="용산구"><span>용산</span>
			<input type="radio" name="region" value="은평구"><span>은평</span>
			<input type="radio" name="region" value="종로구"><span>종로</span>
			<input type="radio" name="region" value="중구"><span>중구</span>
			<input type="radio" name="region" value="중랑"><span>중랑</span>
		</div>
		<span class="gyeonggi">경기</span>
		<div class="G_Region">
			<input type="radio" name="region" value="군포시"><span>군포시</span>
			<input type="radio" name="region" value="안양시"><span>안양시</span>
			<input type="radio" name="region" value="남양주시"><span>남양주시</span>
		</div>
	</form>	
</div>
<br/><br/>

<div id="map" style="width:500px;height:400px;"></div>
<h3>뭐가나올까?_?(결과 리턴-)</h3>
<hr/>
<div>
	${err }
	<c:forEach items="${alist}" var="bean" varStatus="status">
		<div class="links" id="${status.index}">
			<form action="store" method="post">
				<input type="hidden" name="store_Id" value="${bean.store_Id}">
				<input type="hidden" name="kakaoId" value="${bean.kakaoId}">
				<input type="hidden" name="name" value="${bean.name}"><span><strong>${bean.name }</strong></span><br/>
				<span><strong>평점:${bean.averageLevel} 리뷰수:${bean.reviewCnt} 조회수:${bean.viewCnt}</strong></span><br/>
				<input type="hidden" name="roadAddress" value="${bean.roadAddress}"><span>${bean.distance }m ${bean.roadAddress }</span><br/>
				<input type="hidden" name="address" value="${bean.address}">
				<input type="hidden" name="tel" value="${bean.tel}"><span>Tel: ${bean.tel }</span>
				<input type="hidden" name="category" value="${bean.category}">				
				<input type="hidden" name="url" value="${bean.url}">
				<input type="hidden" name="xLocation" value="${bean.xLocation}">
				<input type="hidden" name="yLocation" value="${bean.yLocation}">	
			</form>	
		</div>	
	</c:forEach>	
</div>	
</body>
</html>