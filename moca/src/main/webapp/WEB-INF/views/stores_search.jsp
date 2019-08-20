<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.List, com.kkssj.moca.model.entity.StoreVo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
//카페 리스트 클릭 이벤트(POST방식으로 디테일 페이지 이동)
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
	    //디폴트 위치 정보 지정(비트캠프 강남 센터! :p) 
    	lat = 37.4995011;			 //위도
        lng = 127.0291403;			//경도
        $('.lat').val(lat);
		$('.lng').val(lng); 		
    	//접속 브라우저의 웹 지오로케이션 지원 여부 판단  
        if (navigator.geolocation){             		       
            var options = { timeout: 2000, maximumAge: 3000, enableHighAccuracy: true};	//highAccuracy true: 모바일 기기는 GPS로 위치 정보 확인             
            navigator.geolocation.getCurrentPosition(sucCall, errCall, options);		//현재 위치 정보 얻기
        }else {
        	//브라우저가 지오로케이션 지원하지 않을 때
        	$('#header form').after("<span><small><strong>현재 위치 정보를 지원하지 않는 브라우저 입니다.</strong><br/>(강남역을 기준으로 검색됩니다.)</small></span>");          
        }
        if($('.lat').val()!=37.4995011 || $('.lng').val()!=127.0291403){
        	$('#header form').after("<span><small><strong>위치 정보 디폴트!</strong><br/>(강남역을 기준으로 검색됩니다.)</small></span>");          
        }

//카카오맵 API연결
		//1. 카카오 맵 객체 생성
		    var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
		    var options = {
		    	center: new kakao.maps.LatLng(lat, lng), //지도의 중심 좌표        	
		    	level: 3 	//지도 축척
		    };
		    var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

		 //2. 핀(Marker), 오버레이(팝업 정보 패널) 객체 생성 전처리
			var bounds = new kakao.maps.LatLngBounds();  //LatLngBounds객체 생성: 좌표가 다른 여러 핀에 대한 맵 바운더리 재설정
			//자바 List -> 자바스크립트 Array로 변환(x, y, name 정보만) 
			var alist = new Array();
			<c:forEach items="${alist}" var="data">
				alist.push({'lat':'${data.yLocation}','lng':'${data.xLocation}', 'name':"${data.name}"});
			</c:forEach>

		//3. 핀, 오버레이 객체 생성 & 맵 객체에 추가
			for (var i = 0; i < alist.length ; i++) {
				//핀(Marker)객체 생성
				var position =new kakao.maps.LatLng(alist[i].lat,alist[i].lng);
				var marker = new kakao.maps.Marker({ position : position});
				//커스텀 오버레이 객체 생성
				var content = '<div class ="label"><span class="left"></span><span class="center">'+
				alist[i].name+'</span><span class="right"></span></div>';			
				var overlay = new kakao.maps.CustomOverlay({
				    content: content,
				    position: marker.getPosition()       
				});			
			    // 핀에 마우스 이벤트 적용(오버레이 토글 클로저 생성 및 실행)
			    (function(marker, overlay) {
			        // 핀에 mouseover 이벤트(지도에 오버레이 객체 팝업)
			        kakao.maps.event.addListener(marker, 'mouseover', function() {
			        	overlay.setMap(map);
			        });		
		        	// 핀에 mouseout 이벤트(지도에서 오버레이 객체 제거)
			        kakao.maps.event.addListener(marker, 'mouseout', function() {
			        	overlay.setMap(null); 
			        });
		   		})(marker, overlay);
			marker.setMap(map);	//맵 객체에 생성한 마커 등록
			bounds.extend(position);	//LatLngBounds객체에 핀의 위치 등록
			}
			
		//4. 지도의 바운더리 재설정(LatLngBounds 객체 이용)
			map.setBounds(bounds); 
    };
    
  //Success Callback(현재 위치 정보 저장)
    var sucCall = function (position) {
        lat = position.coords.latitude;	    //위도
        lng = position.coords.longitude;	//경도
		$('.lat').val(lat);
		$('.lng').val(lng);
		$('#warning_geo').html("");
    };

    // Error Callback(에러 메시지 출력)
    function errCall(error) {
        switch (error.code) {
            case error.PERMISSION_DENIED:
            	$('#warning_geo strong').html("현재 위치 정보에 대한 접근이 거부되었습니다.");     
                break;
            case error.POSITION_UNAVAILABLE:
            	$('#warning_geo strong').html("위치 확인이 불가능합니다.");
            	break;
            default:	//error.UNKNOWN_ERROR, error.TIMEOUT, default
            	$('#warning_geo strong').html("현재 위치 정보 받아오기에 실패했습니다.");            
           		break;
        }
    };   
	</script>	
</head>
<body>
<h1>stores_search</h1>
<div id="header">
	<br/>
	<form action="stores">
		<input type="hidden" name="x" class="lng"/>
		<input type="hidden" name="y" class="lat"/>		
		<input type="hidden" name="filter" value="distance"/>
		키워드는 <input type="text" name="keyword"/>
		<button>입니당</button>
	</form>
	<br/>
</div>
--------------------------------------------------------------------------------------------------------여기까지 header 아아아아--------------------------------------------------------------------------------------------------------
<br/><br/>
<div id="content">
	<div id="search">
		<span id="warning_geo">
			<small>
				<strong>현재 위치 정보를 허용해주세요.</strong>
				<br/>
				(현재 위치 정보가 없을 시, 강남역을 기준으로 검색됩니다.)
			</small>
		</span>
		<form action="stores">
			<input type="hidden" name="x" class="lng"/>
			<input type="hidden" name="y" class="lat">
			키워드는 <input type="text" name="keyword" value="${keyword}"/> 입니당
			<div id="filter_sort" class="filter">
				<input type="radio" name="filter" value="averageLevel" <c:if test="${filter eq 'averageLevel'}">checked="checked"</c:if>><span>평점순</span>
				<input type="radio" name="filter" value="reviewCnt" <c:if test="${filter eq 'reviewCnt'}">checked="checked"</c:if>><span>리뷰순</span>
				<input type="radio" name="filter" value="viewCnt" <c:if test="${filter eq 'viewCnt'}">checked="checked"</c:if>><span>조회순</span>
				<input type="radio" name="filter" value="distance" <c:if test="${filter eq 'distance'}">checked="checked"</c:if>><span>거리순</span>
			</div>
			<div id="filter_region" class="filter">
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
			</div>
			<button>검색</button>	
		</form>	
	</div>
	<span id="warning_wrongKeyword">${wrongKeyword }</span>
	<span id="warning_noResult"><c:if test="${alist[0] eq null and wrongKeyword eq null}">검색 결과가 없습니다</c:if></span>
	<hr/>
	<div id="result_stores">		
		<c:forEach items="${alist}" var="bean" varStatus="status">
			<div class="links">
				<form action="stores" method="post">
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
	<div id="map" style="width:500px;height:400px;"></div>
</div>
</body>
</html>