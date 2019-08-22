<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.List, com.kkssj.moca.model.entity.StoreVo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
//지역 검색 시, 장소명으로 재검색 이벤트
		$('#re_search').click(function(){
			$('#search form input[name="keyword"]').attr("name", "");
			$('#search form').append('<input type="hidden" name="keyword" value="\'${keyword}\'"/>');
			$('#search form').submit();
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
        	$('#warning_geo strong').html("현재 위치 정보를 지원하지 않는 브라우저 입니다.");          
        }

//카카오맵 API연결
		//1. 카카오 맵 객체 생성
		<c:if test="${not empty alist}">	//검색 결과 없으면 지도 만들지말자~~~~
		    var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
		    var options = {
		    	center: new kakao.maps.LatLng(lat, lng), //지도의 중심 좌표        	
		    	level: 3 	//지도 축척
		    };
		    var map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

		    //내 위치 마커 이미지 옵션
		    var imageSrc = 'https://moca-pictures.s3.ap-northeast-2.amazonaws.com/logo/pin_person.png'  ; 
		    var imageSize = new kakao.maps.Size(40, 40);
		  //  var imageOption = {offset: new kakao.maps.Point(27, 69)};
			var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);
			var markerPosition = new kakao.maps.LatLng(lat, lng);
			//내 위치 마커 생성
			var marker = new kakao.maps.Marker({
			    position: markerPosition, 
			    image: markerImage,
			    map: map,
			    zIndex: 3
			});   		

		 //2. 핀(Marker), 오버레이(팝업 정보 패널) 객체 생성 전처리
			var bounds = new kakao.maps.LatLngBounds();  //LatLngBounds객체 생성: 좌표가 다른 여러 핀에 대한 맵 바운더리 재설정
			//자바 List -> 자바스크립트 Array로 변환(x, y, name 정보만) 
			var alist = new Array();
			<c:forEach items="${alist}" var="data">
				alist.push({'lat':${data.yLocation},'lng':${data.xLocation}, 'store_Id': ${data.store_Id}, 'name':"${data.name}", 'roadAddress': '${data.roadAddress}', 'tel':'${data.tel }', 'tasteLevel':${data.tasteLevel},'priceLevel':${data.priceLevel}, 'serviceLevel':${data.serviceLevel}, 'moodLevel':${data.moodLevel}, 'convenienceLevel':${data.convenienceLevel}, 'logoImg':'${data.logoImg}'});
			</c:forEach>

		//3. 핀, 오버레이 객체 생성 & 맵 객체에 추가
			for (var i = 0; i < alist.length ; i++) {
				//핀(Marker)객체 생성
				var position =new kakao.maps.LatLng(alist[i].lat,alist[i].lng);
				var marker = new kakao.maps.Marker({ position : position, clickable: false});
				//오버레이 객체 생성
				var content = '<div class= "overlay" style="background-color:white;width: 300px"><div class ="logo"><img width="70px" height="50px" ';
				if(alist[i].logoImg==""){
					content+='src="https://moca-pictures.s3.ap-northeast-2.amazonaws.com/logo/MoCA-logo.png"/>';
				}else{
					content+='src="'+alist[i].logoImg+'"/>';					
				}
				content+='</div><div class="top">'+alist[i].name+'</div><div class="center">'+alist[i].roadAddress+'<br/>'+alist[i].tel;	
				if(alist[i].store_Id){
					content+='<br/>맛'+alist[i].tasteLevel+' 가격'+alist[i].priceLevel+' 분위기'+alist[i].moodLevel+' 서비스'+alist[i].serviceLevel+' 편의성'+alist[i].convenienceLevel;
				}
				content+='</div><div class="bottom"></div></div>'; 
				
				var overlay = new kakao.maps.InfoWindow({
				    content: content,
				    position: marker.getPosition(),
				    zIndex: 4     
				});			
				
			    // 핀에 마우스 이벤트 적용(오버레이 토글 클로저 생성 및 실행)
			    (function(marker, overlay) {
			        // 핀에 mouseover 이벤트(지도에 오버레이 객체 팝업)
			        kakao.maps.event.addListener(marker, 'mouseover', function() {
				        overlay.open(map, marker);
			        });		
		        	// 핀에 mouseout 이벤트(지도에서 오버레이 객체 제거)
			        kakao.maps.event.addListener(marker, 'mouseout', function() {
				        overlay.close();
			        });
		   		})(marker, overlay);
			marker.setMap(map);	//맵 객체에 생성한 마커 등록
			bounds.extend(position);	//LatLngBounds객체에 핀의 위치 등록
			}
			
		//4. 지도의 바운더리 재설정(LatLngBounds 객체 이용)
			map.setBounds(bounds);
		</c:if> 
    };//onload 끝-
    
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
            	$('#warning_geo strong').html("위치 정보 접근 거부 🙄 ...............정....정확한 검색을 위해 허....허용..을..");     
                break;
            case error.POSITION_UNAVAILABLE:
            	$('#warning_geo strong').html("위치 확인이 불가능합니다. 🙄  🙄 ");
            	break;
            default:	//error.UNKNOWN_ERROR, error.TIMEOUT, default
            	$('#warning_geo strong').html("현재 위치 정보 받아오기에 실패했습니다.");            
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
<div id="content">
	<br/><br/><br/><br/>
	<div id="warning_geo">
		<strong>정확한 검색을 위해 위치 정보 접근을 허용해주세요:)</strong><br/>
		<small>(현재 위치 정보가 없을 시, 강남역을 기준으로 검색됩니다!)</small>
	</div>
	<div id="search">		
		<form action="stores">
			<input type="hidden" name="x" class="lng"/>
			<input type="hidden" name="y" class="lat">
			키워드는 <input type="text" name="keyword" value="${keyword}"/> 입니당
			<div id="filter_sort" class="filter">
				<input type="radio" name="filter" value="averageLevel" <c:if test="${filter eq 'averageLevel'}">checked="checked"</c:if>><span>평점순</span>
				<input type="radio" name="filter" value="reviewCnt" <c:if test="${filter eq 'reviewCnt'}">checked="checked"</c:if>><span>리뷰순</span>
				<input type="radio" name="filter" value="viewCnt" <c:if test="${filter eq 'viewCnt'}">checked="checked"</c:if>><span>조회순</span>
				<input type="radio" name="filter" value="distance" <c:if test="${filter eq 'distance'}"> checked="checked"</c:if>><span>거리순</span>
			</div>
			<div id="filter_region" class="filter">
				<span class="seoul">서울</span>
				<div class="S_Region">
					<input type="radio" name="region" value="강남"><span>강남구</span>
					<input type="radio" name="region" value="강동"><span>강동구</span>
					<input type="radio" name="region" value="강북"><span>강북구</span>
					<input type="radio" name="region" value="강서"><span>강북구</span>
					<input type="radio" name="region" value="관악"><span>관악구</span>
					<input type="radio" name="region" value="광진"><span>광진구</span>
					<input type="radio" name="region" value="구로"><span>구로구</span>
					<input type="radio" name="region" value="금천"><span>금천구</span>
					<input type="radio" name="region" value="노원"><span>노원구</span>
					<input type="radio" name="region" value="도봉"><span>도봉구</span>
					<input type="radio" name="region" value="동대문"><span>동대문</span>
					<input type="radio" name="region" value="마포"><span>마포구</span>
					<input type="radio" name="region" value="서대문"><span>서대문구</span>
					<input type="radio" name="region" value="서초"><span>서초구</span>
					<input type="radio" name="region" value="성동"><span>성동구</span>
					<input type="radio" name="region" value="성북"><span>성북구</span>
					<input type="radio" name="region" value="송파"><span>송파구</span>
					<input type="radio" name="region" value="양천"><span>양천구</span>
					<input type="radio" name="region" value="영등포"><span>영등포구</span>
					<input type="radio" name="region" value="용산"><span>용산구</span>
					<input type="radio" name="region" value="은평"><span>은평구</span>
					<input type="radio" name="region" value="종로"><span>종로구</span>
					<input type="radio" name="region" value="서울 중구"><span>중구</span>
					<input type="radio" name="region" value="중랑"><span>중랑구</span>
				</div>
				<span class="gyeonggi">경기</span>
				<div class="G_Region">
					<input type="radio" name="region" value="군포"><span>군포시</span>
					<input type="radio" name="region" value="안양"><span>안양시</span>
					<input type="radio" name="region" value="남양주"><span>남양주시</span>
				</div>
			</div>
			<button>검색</button><br/>
			<c:if test="${not empty msg_changedFilter}">원하는 결과가 없나요? ${keyword }를 장소명으로 <a id="re_search" href="#">재검색</a>해보세요😉</c:if>		
		</form>	
	</div>
	<div id="warning_box">
		<span id="warning_wrongKeyword"><strong>${msg_wrongKeyword }</strong></span><br/>
		<span id="warning_keywordEx"><small>${msg_keywordEx }</small></span>
		<span id="warning_noResult"><c:if test="${alist[0] eq null and wrongKeyword eq null}">검색 결과가 없습니다</c:if></span>
	</div>
	<div id="result_stores">
		<span id="warning_changedFilter"><small>${msg_changedFilter}</small></span>
		<c:forEach items="${alist}" var="bean" varStatus="status">
			<c:if test="${bean.distance ge 1000.0}"><fmt:formatNumber var="distance" value="${bean.distance/1000}" pattern="#.0km"></fmt:formatNumber></c:if>
			<c:if test="${bean.distance lt 1000.0}"><fmt:formatNumber var="distance" value="${bean.distance}" pattern="#m"></fmt:formatNumber></c:if>
			<div class="links">
				<form action="stores" method="post">
					<input type="hidden" name="store_Id" value="${bean.store_Id}">
					<input type="hidden" name="kakaoId" value="${bean.kakaoId}">
					<input type="hidden" name="name" value="${bean.name}"><span><strong>${bean.name }</strong></span><br/>
					<span><strong>평점:${bean.averageLevel} 리뷰수:${bean.reviewCnt} 조회수:${bean.viewCnt}</strong></span><br/>
					<input type="hidden" name="roadAddress" value="${bean.roadAddress}"><span>${distance} ${bean.roadAddress }</span><br/>
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
	<c:if test="${not empty alist }">
		<div id="map" style="width:500px;height:400px;"></div>
	</c:if>
</div>
</body>
</html>