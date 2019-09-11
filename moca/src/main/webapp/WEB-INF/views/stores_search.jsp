<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.List, com.kkssj.moca.model.entity.StoreVo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
<title>Insert title here</title>
<style type="text/css">
	/*
		body에 padding-top줘야함 - header fixed된 후.
	*/
	#searchBar{
		display: none;
	}
	#search{
		text-align: center;
		background-image: url("resources/imgs/store3.jpg");
	}
	#keyword2{
		width : 500px;
		height : 50px;
	}
	#filter_sort>span{
		color : white;
	}
	.links{
		border: 1px solid purple;
	}
	.links img{
		display : inline-block;
		margin : 0 auto;
		width: 300px;
		height: 300px;
	}
	.label{
		background-color: white;
	}
	.center{
		color : black;
	}
	#filter_region>span{
		border : 1px solid black;
	}
	.region_list{
		display : none;
	}
	.seoul{
		display : inline-block;
	}
	span.seoul{
		background-color : yellow;
	}
	.warning{
		text-align: center;
	}
	#page{
		display : none;
		text-align: center;
	}
</style>
<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.css"/>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.css"/>
<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e63ece9668927d2e8027037f0aeb06b5"></script>
<script type="text/javascript">
 	var lat=${y};
 	var lng=${x};
 	var map, overlayList, bounds, pageNum;
 	var markers = new Array();
    window.onload = function () {  
    	 //키워드 검사
		$('#searchBtn2').click(function(){
			var keyword = $('#keyword2').val();
			keyword = keyword.trim();		
			//검색어가 없거나 태그가 2개 이상일 때,			
			if(keyword=="" || keyword=="#" || keyword.indexOf('#') != keyword.lastIndexOf('#')){
				$('#keyword2').val("");
				$('#keyword2').attr('placeholder', '잘못된 키워드 입니다... :(');
				return false;
			}else{				
				$(this).parent().submit();
			}
		});
//카페 리스트 클릭 이벤트(POST방식으로 디테일 페이지 이동)
        $('.links').on("click",toDetail);
        $('#filter_region>span.seoul').attr('target','target');
//지역 필터 -> 지역1(도 / 광역시) 클릭 이벤트
		$('#filter_region>span').click(function(){
			$('#filter_region>span').css('background-color','white');
			$('#filter_region>span').removeAttr('target');
			$(this).attr('target','target');
			$(this).css('background-color','yellow');
			$('.region_list').hide();
			$('.'+$(this).attr('class')).show();
		});
		
//지역 필터 -> 지역2(시 / 구) 클릭 이벤트 
		$('#filter_region input[type="radio"]').click(function() {
			$('#filter_region input[type="radio"]').not(this).attr('checked',false);
			$(this).attr('checked', !$(this).attr('checked'));
		});
		
//지역 필터 모달 적용버튼 클릭이벤트
		$('#region_modal_btn').click(function(){
			var cls = $('#filter_region>span[target="target"]').attr('class');
			var region1 = $('#filter_region div.'+cls+'').children('input[type=hidden]').val();
			var region2 = $('#filter_region input[checked="checked"]').val();
			console.log(cls+' '+region1 +' '+ region2);
			if(region1!=undefined && region2==undefined){
				$('#region1').removeAttr('disabled');
				$('#region2').attr('disabled',true);
				$('#region1').val(region1);
			}else if(region2!=undefined){
				$('#region1').add('#region2').removeAttr('disabled');
				$('#region1').val(region1);
				$('#region2').val(region2);
			}else{
				$('#region1').add('#region2').attr('disabled',true);
			}
			$('#region_modal').modal('hide');
		});
		
//지역 검색 시, 장소명으로 재검색 이벤트
		$('#re-search').click(function(){
			$('#search form input[name="keyword"]').attr("name", "");
			$('#search form').append('<input type="hidden" name="keyword" value="\'${keyword}\'"/>');
			$('#search form').submit();
		});
		createMap();
		<c:if test="${not empty storeList}">
		var totalCount = $('.links').size()-1; //총 가게수, paging 함수내에서 인덱스로 활용되기때문에 -1
		paging(totalCount, 1); //
		</c:if>
    };//onload 끝-

    //리스트 클릭 이벤트
    function toDetail(){
        //구글에서 리뷰/별점 데이터 받아오기 테스트 중
	/* var input = $(this).find('.name').val()+" "+$(this).find('.roadAddress').val();
         $.ajax({                
			url:"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input="+input+"&inputtype=textquery&type=cafe&fields=place_id,name,rating&key=",
			dataType:"JSON",
			success:function(data){					
				console.log(data);
			} 
        }); */
       	$(this).children().first().submit();
    }
  
	//카카오 맵 생성(API연결)
	var createMap = function(){
	<c:if test="${not empty storeList}">	//검색 결과 없으면 지도 만들지말자~~~~
		//1. 카카오 맵 객체 생성
	    var container = document.getElementById('map'); //지도를 담을 영역의 DOM 레퍼런스
	    var mapCenter = new kakao.maps.LatLng(lat, lng);//지도의 중심 좌표   = 현재 위치
	    var options = {
	    	center: mapCenter,      	
	    	level: 3 	//지도 축척
	    };
	    map = new kakao.maps.Map(container, options); //지도 생성 및 객체 리턴

	    //2. 내 위치 핀(Marker) 객체 생성
	    var imageSrc = 'https://moca-pictures.s3.ap-northeast-2.amazonaws.com/logo/pin_person.png'; 	//내 위치 핀 이미지 파일
	    var imageSize = new kakao.maps.Size(40, 40);	//내 위치 핀 이미지 사이즈 지정
	  //var imageOption = {offset: new kakao.maps.Point(27, 69)};
		var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);	//내 위치 핀 이미지 객체 생성
		//내 위치 핀 생성
		var marker = new kakao.maps.Marker({
		    position: mapCenter, 	//내 위치 핀 = 현재 위치 = 지도 중심 좌표
		    image: markerImage,
		    map: map,
		    zIndex: 3
		});   		

		//자바 List -> 자바스크립트 Array로 변환(x, y, name 정보만) 
		overlayList = new Array();
		<c:forEach items="${requestScope.storeList}" var="data">
			overlayList.push({'lat':${data.yLocation},'lng':${data.xLocation}, 'store_Id': ${data.store_Id}, 'name':"${data.name}", 'roadAddress': '${data.roadAddress}', 'tel':'${data.tel }', 'tasteLevel':${data.tasteLevel},'priceLevel':${data.priceLevel}, 'serviceLevel':${data.serviceLevel}, 'moodLevel':${data.moodLevel}, 'convenienceLevel':${data.convenienceLevel}, 'logoImg':'${data.logoImg}'});
		</c:forEach>
		
		var createElements = function(){
	 		//3. 검색 결과 storeList의 가게들 핀(Marker), 오버레이(팝업 정보 패널) 객체 생성 전처리
			bounds = new kakao.maps.LatLngBounds();  //LatLngBounds객체 생성: 좌표가 다른 여러 핀에 대한 맵 바운더리 재설정
			//4. 핀, 오버레이 객체 생성 & 맵 객체에 추가
			markers=[];
			for (var i = 0; i < overlayList.length ; i++) {
				//핀(Marker)객체 생성
				var position =new kakao.maps.LatLng(overlayList[i].lat,overlayList[i].lng);
				var marker = new kakao.maps.Marker({ position : position, clickable: false});
				markers[i] = marker;
				//오버레이 객체 생성
				var content = '<div class= "overlay" style="background-color:white;width: 300px"><div class ="logo"><img width="70px" height="50px" ';
				if(overlayList[i].logoImg=="" || overlayList[i].logoImg==null){
					content+='src="https://moca-pictures.s3.ap-northeast-2.amazonaws.com/logo/MoCA-logo.png"/>';
				}else{
					content+='src="'+overlayList[i].logoImg+'"/>';					
				}
				content+='</div><div class="top">'+overlayList[i].name+'</div><div class="center">'+overlayList[i].roadAddress+'<br/>'+overlayList[i].tel;	
				if(overlayList[i].store_Id){
					content+='<br/>맛'+overlayList[i].tasteLevel+' 가격'+overlayList[i].priceLevel+' 분위기'+overlayList[i].moodLevel+' 서비스'+overlayList[i].serviceLevel+' 편의성'+overlayList[i].convenienceLevel;
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
			bounds.extend(position);	//LatLngBounds객체에 핀의 위치 등록
			}	//for문 끝-
		};
		createElements();
		//5. 지도의 바운더리 재설정(LatLngBounds 객체 이용)
		map.setBounds(bounds);
		
		//맵 중심 좌표 변경 이벤트
	//	$('#map').css({'position':'relative','z-index':0});
		kakao.maps.event.addListener(map, 'center_changed', function() {
		    $('#map_re-search').show().css({'position':'relative','top':'-30px','left':'40%','z-index':2});
		});
		//지도 내 재검색 기능
		$('#map_re-search').click(function(){
			var location = map.getBounds();
			var center = map.getCenter();
			var rect = location.ea +','+ location.la +','+ location.ja +','+ location.ka;		
			$.ajax({	//비동기로 받아오기
				url: "re-search",
				dataType: "json",
				data: {"filter":"${filter}", "keyword":"${keyword}", "rect": rect, "y":center.getLat(), "x": center.getLng()},
				statusCode: {
				    418: function(data) {
					    console.log(data);
					    data=data.responseJSON;
					    if(data!=""){
					    	reload_map(data);
							paging(data.length, 1);
						    map.setBounds(bounds);	
						}else{
							alert("검색 결과 없습니다");	//////여기 수정해야되-------
						}					    							
				    }
				},
				success: function(data){
					if(data.length==0){
						$('#warning_noResult').text("검색 결과가 없습니다");
						$('#page').hide();
					}
					reload_map(data);
					paging(data.length, 1);
				}
			});	
		});		

		function reload_map(data){
			overlayList=[];
			var template = $($('.links')[0]).clone();
			$('.links').remove();
			$(data).each(function(idx, ele){			
				var store = template.clone();
				$(store).addClass('page-'+idx);
				var inputs = $(store.children()[0]).children('input');
				$(inputs[0]).val(ele.store_Id);
				$(inputs[1]).val(ele.kakaoId);
				$(inputs[2]).val(ele.name);
				$(inputs[3]).val(ele.roadAddress);
				$(inputs[4]).val(ele.address);
				$(inputs[5]).val(ele.tel);
				$(inputs[6]).val(ele.category);
				$(inputs[7]).val(ele.url);
				$(inputs[8]).val(ele.xLocation);
				$(inputs[9]).val(ele.yLocation);
				$(store.children()[0]).find('img').attr('alt', ele.name + '대표이미지');
				if(ele.storeImg1)
					$(store.children()[0]).find('img').attr('src', ele.storeImg1);
				var spans = $(store.children()[0]).children('span');
				$(spans[0]).html("<strong>"+ele.name+"</strong>");
				$(spans[1]).html("<strong>평점:"+ele.averageLevel+" 리뷰수:"+ele.reviewCnt+" 조회수:"+ele.viewCnt+"</strong>");
				var distance;
				if(ele.distance>=1000){
					distance = (ele.distance/1000).toFixed(1)+"km";
				}else if(ele.distance==null){
					distance="";
				}else{
					distance = (ele.distance*1).toFixed(0)+"m";
				}
				$(spans[2]).text(distance + ele.roadAddress);
				$(store).appendTo('#result_stores').show();
				$('#page').appendTo('#result_stores');
				overlayList.push({'lat':ele.yLocation,'lng':ele.xLocation, 'store_Id': ele.store_Id, 'name':ele.name, 'roadAddress': ele.roadAddress, 'tel':ele.tel, 'tasteLevel':ele.tasteLevel,'priceLevel':ele.priceLevel, 'serviceLevel':ele.serviceLevel, 'moodLevel':ele.moodLevel, 'convenienceLevel':ele.convenienceLevel, 'logoImg':ele.logoImg});
			});
			$('.links').on("click",toDetail);
			setMarkers(null);
			createElements();			
		};    
		</c:if>
	};
	
//카카오맵 핀 삽입(map),제거(null) 함수
	function setMarkers(map) {
	    for (var i = 0; i < markers.length; i++) {
	        markers[i].setMap(map);
	    }            
	}
	
//페이지 바 추가, 페이지에 해당하는 가게 노출 및 지도 처리
	function paging(totalCount,currentPage){
		$('.links').hide(); //일단 가게 다 숨겨
		$('.pagination>li').not($('.pagination>li:first')).not($('.pagination>li:last')).remove(); //페이지 바 초기화
		console.log('paging 시작, count는 '+totalCount);
		var countList = 10; //한 페이지에 들어갈 가게 수
		var countPage = 10; //페이지 바에 들어갈 수 있는 최대 페이지 수
		var totalPage = Math.floor(totalCount / countList); //총 페이지
		var startPage = (Math.floor((currentPage - 1)/10)) * 10 +1; //시작페이지
		
		var endPage =  startPage + countPage - 1; //마지막페이지
		//console.log('paging 도중, totalPage='+totalPage+' startPage='+startPage+' endPage='+endPage)
		if (totalCount % countList > 0) {
		    totalPage++;
		}
		
		if (endPage > totalPage) {
		    endPage = totalPage;
		}
		
		for (var i = startPage; i <= endPage; i++) {
			if(i==startPage)
				$('.pagination>li:last').before('<li class="page-'+i+' active"><a>'+i+'</a></li>');
			else
				$('.pagination>li:last').before('<li class="page-'+i+'"><a>'+i+'</a></li>');
		}
		
		var goPage = function(){
			if(!pageNum)
				pageNum = $(this).children('a').text();
			$('.pagination>li').removeClass('active');
			$('li.page-'+pageNum).addClass('active');
			var divPage= 'page-'+pageNum;
			//console.log('page 클릭 이벤트, 페이지 넘버:'+pageNum+' divPage : '+divPage);
			$('.links').hide();
			setMarkers(null);
			bounds = new kakao.maps.LatLngBounds();
			for(var i = (pageNum*countList)-countList; i <= pageNum*countList-1; i++){
				if(i==totalCount)break;
				//console.log('i count : '+ i);
				//console.log('i번째 markers의 index : '+markers[i]);
				$('div.page-'+i).show();
				bounds.extend(markers[i].getPosition());
				markers[i].setMap(map);
			}
			map.setBounds(bounds);
			var prev = $('.pagination>li:first');
			var next = $('.pagination>li:last');
			
			var clickPrev=function(){
				pageNum = $('.pagination>li.active>a').text();
				pageNum--;
				goPage();
				
			}
			
			var clickNext=function(){
				pageNum = $('.pagination>li.active>a').text();
				pageNum++;
				goPage();
			}
			
			if(pageNum==1){
				prev.addClass('disabled');
				prev.off('click');
			}else{
				prev.removeClass('disabled');
				prev.off('click').click(clickPrev);
			}
			
			if(pageNum==endPage){
				next.addClass('disabled');
				next.off('click');
			}else{
				next.removeClass('disabled');
				next.off('click').click(clickNext);
			}	
			pageNum=null;
		}
		
		$('.pagination>li').not($('.pagination>li:first')).not($('.pagination>li:last')).on("click",goPage);
		$('.pagination>li:nth-child(2)').click();
		$('#page').show();
	};
	
	</script>	
</head>
<body>
<div class="modal fade" id="region_modal" tabindex="-1" role="dialog" data-backdrop="static" aria-labelledby="gridSystemModalLabel"><!--modal start -->
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">지역선택</h4>
      </div>
      <div class="modal-body">
        <div class="row">
        	<div id="filter_region" class="filter">
				<span class="seoul">서울</span>
				<span class="gyeonggi">경기</span>
				<span class="sejong">세종</span>
				<span class="gangwon">강원도</span>
				<span class="gyeongsangbuk-do">경상북도</span>
				<span class="gyeongsangnam-do">경상남도</span>
				<span class="gwangju">광주</span>
				<span class="daegu">대구</span>
				<span class="daejeon">대전</span>
				<span class="busan">부산</span>
				<span class="ulsan">울산</span>
				<span class="incheon">인천</span>
				<span class="jeollanam-do">전라남도</span>
				<span class="jeollabuk-do">전라북도</span>
				<!-- 제주도 지역 더 세분화 할지?? -->
				<span class="jeju">제주도</span>
				<span class="chungcheongbuk-do">충청북도</span>
				<span class="chungcheongnam-do">충청남도</span>
				<div class="region_list seoul">
					<input type="hidden" name="region" value="서울"/>
					<input type="radio" name="region" value="강남"><span>강남구</span>
					<input type="radio" name="region" value="강동"><span>강동구</span>
					<input type="radio" name="region" value="강북"><span>강북구</span>
					<input type="radio" name="region" value="강서"><span>강서구</span>
					<input type="radio" name="region" value="관악"><span>관악구</span>
					<input type="radio" name="region" value="광진"><span>광진구</span>
					<input type="radio" name="region" value="구로"><span>구로구</span>
					<input type="radio" name="region" value="금천"><span>금천구</span>
					<input type="radio" name="region" value="노원"><span>노원구</span>
					<input type="radio" name="region" value="도봉"><span>도봉구</span>
					<input type="radio" name="region" value="동대문"><span>동대문구</span>
					<input type="radio" name="region" value="동작"><span>동작구</span>
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
					<input type="radio" name="region" value="중구"><span>중구</span>
					<input type="radio" name="region" value="중랑"><span>중랑구</span>
				</div>
				<div class="region_list gyeonggi">
					<input type="hidden" name="region" value="경기도"/>
					<input type="radio" name="region" value="가평"><span>가평군</span>
					<input type="radio" name="region" value="고양"><span>고양시</span>
					<input type="radio" name="region" value="과천"><span>과천시</span>
					<input type="radio" name="region" value="광명"><span>광명시</span>
					<input type="radio" name="region" value="광주"><span>광주시</span>
					<input type="radio" name="region" value="구리"><span>구리시</span>
					<input type="radio" name="region" value="군포"><span>군포시</span>
					<input type="radio" name="region" value="김포"><span>김포시</span>
					<input type="radio" name="region" value="남양주"><span>남양주시</span>
					<input type="radio" name="region" value="동두천"><span>동두천시</span>
					<input type="radio" name="region" value="부천"><span>부천시</span>
					<input type="radio" name="region" value="성남"><span>성남시</span>
					<input type="radio" name="region" value="수원"><span>수원시</span>
					<input type="radio" name="region" value="시흥"><span>시흥시</span>
					<input type="radio" name="region" value="안산"><span>안산시</span>
					<input type="radio" name="region" value="안성"><span>안성시</span>
					<input type="radio" name="region" value="안양"><span>안양시</span>
					<input type="radio" name="region" value="양주"><span>양주시</span>
					<input type="radio" name="region" value="양평"><span>양평군</span>
					<input type="radio" name="region" value="여주"><span>여주시</span>
					<input type="radio" name="region" value="연천"><span>연천군</span>
					<input type="radio" name="region" value="오산"><span>오산시</span>
					<input type="radio" name="region" value="용인"><span>용인시</span>
					<input type="radio" name="region" value="의왕"><span>의왕시</span>
					<input type="radio" name="region" value="의정부"><span>의정부시</span>
					<input type="radio" name="region" value="이천"><span>이천시</span>
					<input type="radio" name="region" value="파주"><span>파주시</span>
					<input type="radio" name="region" value="평택"><span>평택시</span>
					<input type="radio" name="region" value="포천"><span>포천시</span>
					<input type="radio" name="region" value="하남"><span>하남시</span>
					<input type="radio" name="region" value="화성"><span>화성시</span>
				</div>
				<div class="region_list sejong">
					<input type="hidden" name="region" value=""/>
					<input type="radio" name="region" value="세종"><span>세종시</span>
				</div>
				<div class="region_list gangwon">
					<input type="hidden" name="region" value="강원도"/>
					<input type="radio" name="region" value="강릉"><span>강릉시</span>
					<input type="radio" name="region" value="고성"><span>고성군</span>
					<input type="radio" name="region" value="동해"><span>동해시</span>
					<input type="radio" name="region" value="삼척"><span>삼척시</span>
					<input type="radio" name="region" value="속초"><span>속초시</span>
					<input type="radio" name="region" value="양구"><span>양구군</span>
					<input type="radio" name="region" value="양양"><span>양양군</span>
					<input type="radio" name="region" value="영월"><span>영월군</span>
					<input type="radio" name="region" value="원주"><span>원주시</span>
					<input type="radio" name="region" value="인제"><span>인제군</span>
					<input type="radio" name="region" value="정선"><span>정선군</span>
					<input type="radio" name="region" value="철원"><span>철원군</span>
					<input type="radio" name="region" value="춘천"><span>춘천시</span>
					<input type="radio" name="region" value="태백"><span>태백시</span>
					<input type="radio" name="region" value="평창"><span>평창군</span>
					<input type="radio" name="region" value="홍천"><span>홍천군</span>
					<input type="radio" name="region" value="화천"><span>화천군</span>
					<input type="radio" name="region" value="횡성"><span>횡성군</span>
				</div>
				<div class="region_list gyeongsangbuk-do">
					<input type="hidden" name="region" value="경상북도"/>
					<input type="radio" name="region" value="경산"><span>경산시</span>
					<input type="radio" name="region" value="경주"><span>경주시</span>
					<input type="radio" name="region" value="고령"><span>고령군</span>
					<input type="radio" name="region" value="구미"><span>구미시</span>
					<input type="radio" name="region" value="군위"><span>군위군</span>
					<input type="radio" name="region" value="김천"><span>김천시</span>
					<input type="radio" name="region" value="문경"><span>문경시</span>
					<input type="radio" name="region" value="봉화"><span>봉화군</span>
					<input type="radio" name="region" value="상주"><span>상주시</span>
					<input type="radio" name="region" value="성주"><span>성주군</span>
					<input type="radio" name="region" value="안동"><span>안동시</span>
					<input type="radio" name="region" value="영덕"><span>영덕군</span>
					<input type="radio" name="region" value="양양"><span>양양군</span>
					<input type="radio" name="region" value="영주"><span>영주시</span>
					<input type="radio" name="region" value="영천"><span>영천시</span>
					<input type="radio" name="region" value="예천"><span>예천군</span>
					<input type="radio" name="region" value="울릉"><span>울릉군</span>
					<input type="radio" name="region" value="울진"><span>울진군</span>
					<input type="radio" name="region" value="의성"><span>의성군</span>
					<input type="radio" name="region" value="청도"><span>청도군</span>
					<input type="radio" name="region" value="청송"><span>청송군</span>
					<input type="radio" name="region" value="칠곡"><span>칠곡군</span>
					<input type="radio" name="region" value="포항"><span>포항시</span>
				</div>
				<div class="region_list gyeongsangnam-do">
					<input type="hidden" name="region" value="경상남도"/>
					<input type="radio" name="region" value="거제"><span>거제시</span>
					<input type="radio" name="region" value="거창"><span>거창군</span>
					<input type="radio" name="region" value="고성"><span>고성군</span>
					<input type="radio" name="region" value="김해"><span>김해시</span>
					<input type="radio" name="region" value="남해"><span>남해군</span>
					<input type="radio" name="region" value="밀양"><span>밀양시</span>
					<input type="radio" name="region" value="사천"><span>사천시</span>
					<input type="radio" name="region" value="산청"><span>산청군</span>
					<input type="radio" name="region" value="양산"><span>양산시</span>
					<input type="radio" name="region" value="의령"><span>의령군</span>
					<input type="radio" name="region" value="진주"><span>진주시</span>
					<input type="radio" name="region" value="창녕"><span>창녕군</span>
					<input type="radio" name="region" value="창원"><span>창원시</span>
					<input type="radio" name="region" value="통영"><span>통영시</span>
					<input type="radio" name="region" value="하동"><span>하동군</span>
					<input type="radio" name="region" value="함안"><span>함안군</span>
					<input type="radio" name="region" value="함양"><span>함양군</span>
					<input type="radio" name="region" value="합천"><span>합천군</span>
				</div>
				<div class="region_list gwangju">
					<input type="hidden" name="region" value="광주"/>
					<input type="radio" name="region" value="광산"><span>광산구</span>
					<input type="radio" name="region" value="동구"><span>동구</span>
					<input type="radio" name="region" value="서구"><span>서구</span>
					<input type="radio" name="region" value="남구"><span>남구</span>
					<input type="radio" name="region" value="북구"><span>북구</span>
				</div>
				<div class="region_list daegu">
					<input type="hidden" name="region" value="대구"/>
					<input type="radio" name="region" value="달서"><span>달서구</span>
					<input type="radio" name="region" value="달성"><span>달성군</span>
					<input type="radio" name="region" value="수성"><span>수성구</span>
					<input type="radio" name="region" value="중구"><span>중구</span>
					<input type="radio" name="region" value="동구"><span>동구</span>
					<input type="radio" name="region" value="서구"><span>서구</span>
					<input type="radio" name="region" value="남구"><span>남구</span>
					<input type="radio" name="region" value="북구"><span>북구</span>
				</div>
				<div class="region_list daejeon">
					<input type="hidden" name="region" value="대전"/>
					<input type="radio" name="region" value="유성"><span>유성구</span>
					<input type="radio" name="region" value="대덕"><span>대덕구</span>
					<input type="radio" name="region" value="중구"><span>중구</span>
					<input type="radio" name="region" value="동구"><span>동구</span>
					<input type="radio" name="region" value="서구"><span>서구</span>
				</div>
				<div class="region_list busan">
					<input type="hidden" name="region" value="부산"/>
					<input type="radio" name="region" value="강서"><span>강서구</span>
					<input type="radio" name="region" value="금정"><span>금정구</span>
					<input type="radio" name="region" value="기장"><span>기장군</span>
					<input type="radio" name="region" value="동래"><span>동래구</span>
					<input type="radio" name="region" value="부산진"><span>부산진구</span>
					<input type="radio" name="region" value="사상"><span>사상구</span>
					<input type="radio" name="region" value="사하"><span>사하구</span>
					<input type="radio" name="region" value="수영"><span>수영구</span>
					<input type="radio" name="region" value="연제"><span>연제구</span>
					<input type="radio" name="region" value="영도"><span>영도구</span>
					<input type="radio" name="region" value="해운대"><span>해운대구</span>
					<input type="radio" name="region" value="중구"><span>중구</span>
					<input type="radio" name="region" value="동구"><span>동구</span>
					<input type="radio" name="region" value="서구"><span>서구</span>
					<input type="radio" name="region" value="남구"><span>남구</span>
					<input type="radio" name="region" value="북구"><span>북구</span>
				</div>
				<div class="region_list ulsan">
					<input type="hidden" name="region" value="울산"/>
					<input type="radio" name="region" value="울주"><span>울주군</span>
					<input type="radio" name="region" value="중구"><span>중구</span>
					<input type="radio" name="region" value="남구"><span>남구</span>
					<input type="radio" name="region" value="동구"><span>동구</span>
					<input type="radio" name="region" value="북구"><span>북구</span>
				</div>				
				<div class="region_list incheon">
					<input type="hidden" name="region" value="인천"/>
					<input type="radio" name="region" value="강화"><span>강화군</span>
					<input type="radio" name="region" value="계양"><span>계양구</span>
					<input type="radio" name="region" value="남동"><span>남동구</span>
					<input type="radio" name="region" value="미추홀"><span>미추홀구</span>
					<input type="radio" name="region" value="부평"><span>부평구</span>
					<input type="radio" name="region" value="연수"><span>연수구</span>
					<input type="radio" name="region" value="옹진"><span>옹진군</span>
					<input type="radio" name="region" value="중구"><span>중구</span>
					<input type="radio" name="region" value="동구"><span>동구</span>
					<input type="radio" name="region" value="서구"><span>서구</span>
				</div>				
				<div class="region_list jeollanam-do">
					<input type="hidden" name="region" value="전라남도"/>
					<input type="radio" name="region" value="강진"><span>강진군</span>
					<input type="radio" name="region" value="고흥"><span>고흥군</span>
					<input type="radio" name="region" value="곡성"><span>곡성군</span>
					<input type="radio" name="region" value="광양"><span>광양시</span>
					<input type="radio" name="region" value="구례"><span>구례군</span>
					<input type="radio" name="region" value="나주"><span>나주시</span>
					<input type="radio" name="region" value="담양"><span>담양군</span>
					<input type="radio" name="region" value="목포"><span>목포시</span>
					<input type="radio" name="region" value="무안"><span>무안군</span>
					<input type="radio" name="region" value="보성"><span>보성군</span>
					<input type="radio" name="region" value="순천"><span>순천시</span>
					<input type="radio" name="region" value="신안"><span>신안군</span>
					<input type="radio" name="region" value="여수"><span>여수시</span>
					<input type="radio" name="region" value="영광"><span>영광군</span>
					<input type="radio" name="region" value="영암"><span>영암군</span>
					<input type="radio" name="region" value="완도"><span>완도군</span>
					<input type="radio" name="region" value="장성"><span>장성군</span>
					<input type="radio" name="region" value="장흥"><span>장흥군</span>
					<input type="radio" name="region" value="진도"><span>진도군</span>
					<input type="radio" name="region" value="함평"><span>함평군</span>
					<input type="radio" name="region" value="해남"><span>해남군</span>
					<input type="radio" name="region" value="화순"><span>화순군</span>
				</div>				
				<div class="region_list jeollabuk-do">
					<input type="hidden" name="region" value="전라북도"/>
					<input type="radio" name="region" value="고창"><span>고창군</span>
					<input type="radio" name="region" value="군산"><span>군산시</span>
					<input type="radio" name="region" value="김제"><span>김제시</span>
					<input type="radio" name="region" value="남원"><span>남원시</span>
					<input type="radio" name="region" value="무주"><span>무주군</span>
					<input type="radio" name="region" value="부안"><span>부안군</span>
					<input type="radio" name="region" value="순창"><span>순창군</span>
					<input type="radio" name="region" value="완주"><span>완주군</span>
					<input type="radio" name="region" value="익산"><span>익산시</span>
					<input type="radio" name="region" value="임실"><span>임실군</span>
					<input type="radio" name="region" value="장수"><span>장수군</span>
					<input type="radio" name="region" value="전주"><span>전주시</span>
					<input type="radio" name="region" value="정읍"><span>정읍시</span>
					<input type="radio" name="region" value="진안"><span>진안군</span>
				</div>				
				<div class="region_list jeju">
					<input type="hidden" name="region" value="제주도"/>
					<input type="radio" name="region" value="제주"><span>제주시</span>
					<input type="radio" name="region" value="서귀포"><span>서귀포시</span>
				</div>				
				<div class="region_list chungcheongbuk-do">
					<input type="hidden" name="region" value="충청북도"/>
					<input type="radio" name="region" value="괴산"><span>괴산군</span>
					<input type="radio" name="region" value="단양"><span>단양군</span>
					<input type="radio" name="region" value="보은"><span>보은군</span>
					<input type="radio" name="region" value="영동"><span>영동군</span>
					<input type="radio" name="region" value="옥천"><span>옥천군</span>
					<input type="radio" name="region" value="음성"><span>음성군</span>
					<input type="radio" name="region" value="제천"><span>제천시</span>
					<input type="radio" name="region" value="증평"><span>증평군</span>
					<input type="radio" name="region" value="진천"><span>진천군</span>
					<input type="radio" name="region" value="청주"><span>청주시</span>
					<input type="radio" name="region" value="충주"><span>충주시</span>
				</div>				
				<div class="region_list chungcheongnam-do">
					<input type="hidden" name="region" value="충청남도"/>
					<input type="radio" name="region" value="계룡"><span>계룡시</span>
					<input type="radio" name="region" value="공주"><span>공주시</span>
					<input type="radio" name="region" value="금산"><span>금산군</span>
					<input type="radio" name="region" value="논산"><span>논산시</span>
					<input type="radio" name="region" value="당진"><span>당진시</span>
					<input type="radio" name="region" value="보령"><span>보령시</span>
					<input type="radio" name="region" value="부여"><span>부여군</span>
					<input type="radio" name="region" value="서산"><span>서산시</span>
					<input type="radio" name="region" value="서천"><span>서천군</span>
					<input type="radio" name="region" value="아산"><span>아산시</span>
					<input type="radio" name="region" value="예산"><span>예산군</span>
					<input type="radio" name="region" value="천안"><span>천안시</span>
					<input type="radio" name="region" value="청양"><span>청양군</span>
					<input type="radio" name="region" value="태안"><span>태안군</span>
					<input type="radio" name="region" value="홍성"><span>홍성군</span>
				</div>				
			</div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" id="region_modal_btn">필터 적용!</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<div id="header">
		<jsp:include page="../../resources/template/header.jsp" flush="true"></jsp:include>
</div>
<div id="content" class="container-fluid">
	<div id="search" class="row">		
		<form class="form-inline" action="stores">
			<input type="text" name="keyword" class="form-control" id="keyword2" placeholder="Search" value="${keyword}"/>
			<button id="searchBtn2" class="btn btn-default" type="submit">검색</button><br/>
			<div id="filter_sort" class="filter">
				<input type="radio" name="filter" value="averageLevel" <c:if test="${filter eq 'averageLevel'}">checked="checked"</c:if>><span>평점순</span>
				<input type="radio" name="filter" value="reviewCnt" <c:if test="${filter eq 'reviewCnt'}">checked="checked"</c:if>><span>리뷰순</span>
				<input type="radio" name="filter" value="viewCnt" <c:if test="${filter eq 'viewCnt'}">checked="checked"</c:if>><span>조회순</span>
				<input type="radio" name="filter" value="distance" <c:if test="${filter eq 'distance'}"> checked="checked"</c:if>><span>거리순</span>
				<!-- 모달 트리거 버튼-->
				<button type="button" class="btn btn-default btn-sm" data-toggle="modal" data-target="#region_modal">지역 필터</button>
			</div>
			<input type="hidden" name="region" id="region1" disabled="disabled"/>
			<input type="hidden" name="region" id="region2" disabled="disabled"/>
			<c:if test="${not empty msg_changedFilter}">원하는 결과가 없나요? ${keyword }를 장소명으로 <a id="re-search" href="#">재검색</a>해보세요😉</c:if>		
		</form>	
	</div>
	<div class="warning">
		<span id="warning_geo">
			<strong>정확한 검색을 위해 위치 정보 접근을 허용해주세요:)</strong><br/>
			<small>(현재 위치 정보가 없을 시, 강남역을 기준으로 검색됩니다!)</small>
		</span>		
	</div>
	<div class="row">			
		<c:if test="${not empty storeList }">
			<div id="mapContainer" class="col-xs-12 col-md-6" style="background-color:lightblue">
				<div id="map" style="height:600px;"></div>
				<button id="map_re-search" class="btn btn-default" style="display:none">이 지역에서 재검색</button>	
			</div>			
		</c:if>
		<div id="result_stores" class="col-xs-12 col-md-6" style="background-color:lavender">
			<div class="warning">
				<span id="warning_changedFilter"><small>${msg_changedFilter}</small></span>
				<span id="warning_noResult"><c:if test="${storeList[0] eq null}">검색 결과가 없습니다</c:if></span>
			</div>			
			<div style="display:none" class="links col-xs-6 col-md-6">
					<form action="stores" method="post">
						<img alt="대표 이미지" src="resources/imgs/storeImgDefault.png"><br/>
						<input type="hidden" name="store_Id" value="">
						<input type="hidden" name="kakaoId" value="">
						<input type="hidden" class="name" name="name" value=""><span><strong></strong></span><br/>
						<span><strong></strong></span><br/>
						<input type="hidden" class="roadAddress" name="roadAddress" value=""><span></span><br/>
						<input type="hidden" name="address" value="">
						<input type="hidden" name="tel" value=""><span></span>
						<input type="hidden" name="category" value="">				
						<input type="hidden" name="url" value="">
						<input type="hidden" name="xLocation" value="">
						<input type="hidden" name="yLocation" value="">	
					</form>	
			</div>
			<div class= row>	
			<c:forEach items="${storeList}" var="bean" varStatus="status">
				<c:if test="${bean.distance ge 1000.0}"><fmt:formatNumber var="distance" value="${bean.distance/1000}" pattern="#.0km"></fmt:formatNumber></c:if>
				<c:if test="${bean.distance lt 1000.0}"><fmt:formatNumber var="distance" value="${bean.distance}" pattern="#m"></fmt:formatNumber></c:if>
				<div class="links col-xs-6 col-md-6 page-${status.index }">
					<form action="stores" method="post">
						<img alt="${bean.name} 대표 이미지" src="${bean.storeImg1}<c:if test="${bean.storeImg1 eq null}">resources/imgs/storeImgDefault.png</c:if>"/><br/>
						<input type="hidden" name="store_Id" value="${bean.store_Id}">
						<input type="hidden" name="kakaoId" value="${bean.kakaoId}">
						<input type="hidden" class="name" name="name" value="${bean.name}"><span><strong>${bean.name }</strong></span><br/>
						<span><strong>평점:${bean.averageLevel} 리뷰수:${bean.reviewCnt} 조회수:${bean.viewCnt}</strong></span><br/>
						<input type="hidden" class="roadAddress" name="roadAddress" value="${bean.roadAddress}"><span>${distance} ${bean.roadAddress }</span><br/>
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
			<nav id="page" aria-label="Page navigation">
			  <ul class="pagination">
			    <li>
			      <a aria-label="Previous">
			        <span aria-hidden="true">&laquo;</span>
			      </a>
			    </li>
			    <li>
			      <a aria-label="Next">
			        <span aria-hidden="true">&raquo;</span>
			      </a>
			    </li>
			  </ul>
			</nav>					
		</div>		
	</div>			
</div>
</body>
</html>