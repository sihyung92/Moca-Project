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
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.css"/>
<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.css"/>
<style type="text/css">
	@font-face { font-family: 'NanumGothic';
		src: url('resources/fonts/NanumGothic.eot');
		src: url('resources/fonts/NanumGothic.eot') format('embedded-opentype'),
			url('resources/fonts/NanumGothic.woff') format('woff');
	}
	html, body{
		height : 100%;
	}
	
	input:focus,
	select:focus,
	textarea:focus,
	button:focus,
	a:focus{
	    outline-color: rgba(0,0,0,0.2);
	}
	button:active{
	    outline: none !important;
	}
	#header{
		background-size: cover;
	}
	#searchBar{
		display: none;
	} 
	#search{
		font-family : "NanumGothic", sans-serif;
		text-align: center;
		padding-top:82px;
	}
	#search p {
		padding-top : 5px;
	}
	#search .form-inline{
		display : inline-table;
	}

	#search #searchBtn2{
		position : absolute;
		right : 3%;
		background-color : transparent;
	}
	
	#keyword2{
	    background: white;
	    border-radius: 22px;
	    border : 1px solid lightgray;
	    font-size: 18px;
	    line-height: 21px;
	    padding-inline-start: 20px;
        bottom: 0;
	    top: 0;
		width : 100%;
		height : 40px;
	}
	#filter_sort{
		padding-top : 10px;
	}
	#filter_sort btn{
		font-family : "NanumGothic", sans-serif;
	}
	#content{
		background-color: rgba(246,245,239,0.5);
	}
	
	#mapContainer{
		padding-top : 10px;
	}
	
	#mapContainer button{
		font-family : "NanumGothic",sans-serif;
	}
	
	#mapContainer #map{
		height : 600px;
	}
	
	.overlay{
		font-family: "NanumGothic",sans-serif;
		width: 300px;
		padding : 2px;
	}
	
	.overlay .center{
		font-size : 8pt;
	}
	
	.bold{
		font-weight : bold; 
	}
	#result_stores{
		margin-top: 6px;
	}
	.links_container{
		font-family: "NanumGothic",sans-serif;
		text-align : center;
	}
	
	.links{
		cursor : pointer;
		overflow : hidden;
		padding : 3px 0px 3px;
		width : 100%;
		margin : 5px 0px 5px;
		text-align : center;
	    background-color: #fff;
	    box-shadow: 1px 1px 2px 1px lightgrey;
	}
	
	.links img{
		margin : 0 auto;
		display : inline-block;
		overflow : hidden;
		width: 100%;
		height: 150px;
		object-fit: contain;
	}
	
	.links .span_roadAddress, span.bold {
		overflow : hidden;
		white-space : nowrap;
	}
	.links .span_viewCnts{
		display : inline;
	}
	
	.score{
		margin-top : 1px;
		padding : 0px 1px;
		display : inline-block;
		color : orange;
		border : 1px solid orange;
	}
	
	.label{
		background-color: white;
	}
	.center{
		color : black;
	}
	
	#filter_region .region_list div.btn{
		margin-top : 5px;
	}
	
	#filter_region .region_list{
		display : none;
	}
	
	#filter_region .region_list.seoul{
		display : block;
	}
	
	.warning{
		text-align: center;
		margin : 0 auto;
		font-family: "NanumGothic",sans-serif;
		font-size : 28px;
	}
	
	#page{
		display : none;
		text-align: center;
	}
	.pagination > li > a, .pagination > li > span{
	color :#775218;
	background-color :  rgba(246,245,239,0.1);
	}
	.pagination > li > a:hover, .pagination > li > span:hover{
		color :#775218;
	}
	.pagination > .disabled > span, .pagination > .disabled > span:hover,
	.pagination > .disabled > span:focus, .pagination > .disabled > a,
	.pagination > .disabled > a:hover, .pagination > .disabled > a:focus{
		color : #775218;
		background-color :  rgba(246,245,239,0.1);
	}
	.pagination > .active > a, .pagination > .active > span, 
	.pagination > .active > a:hover, .pagination > .active > span:hover, 
	.pagination > .active > a:focus, .pagination > .active > span:focus{
		background-color: #A48437;
	    border-color: #A48437;
	}

	.nav-pills > li > a{
	    color: #775218;
	}
	
	.nav-pills > li.active > a, .nav-pills > li.active > a:hover, .nav-pills > li.active > a:focus {
	    color: #fff;
	    background-color: #A48437;
	}
	
	@media (max-width:991px){
		.links img{
			height : 200px;
		}
		#mapContainer #map{
			height : 50%;
			min-height : 200px;
		}
	}
	@media (max-width:450px){
		.links{
			font-size : 10px;
		}
	}
</style>
<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
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

//지역 필터 -> 지역1(도 / 광역시) 클릭 이벤트
		$('#filter_region ul li').click(function(){
			$('#filter_region ul li').removeClass('active');
			$(this).addClass('active');
			$('.region_list').hide();
			$('.'+$(this).attr('class').split(' ')[0]).show();
		});
//지역 필터 -> 지역2(시 / 구) 클릭 이벤트 
		$('.region_list div').click(function() {
			if($(this).hasClass('active')){
				$(this).removeClass('active');
			}else{
			$('.region_list div').removeClass('active');
			$(this).addClass('active');
			}
		});
		
//지역 필터 모달 적용버튼 클릭이벤트
		$('#region_modal_btn').click(function(){
			var cls = $('#filter_region ul li.active').attr('class').split(' ')[0];
			var region1 = $('#filter_region div.'+cls+'').children('input[type=hidden]').val();
			var region2 = $('#filter_region .region_list div.active').attr('value');
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
			$('#search form').append('<input type="hidden" name="keyword" value="\'${keyword}\'"/>');
			$('#search form').submit();
		});
		createMap();
		<c:if test="${not empty storeList}">
		var totalCount = $('.links_container').size()-1; //총 가게수, paging 함수내에서 인덱스로 활용되기때문에 -1
		paging(totalCount, 1); //
		</c:if>

		$(window).on('scroll', showHeaderSearch);
		$(window).on('resize', mapResize);
		mapResize();
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
				var content = '<div class= "overlay media"><div class ="logo media-left media-middle"><img width="70px" height="50px" ';
				if(overlayList[i].logoImg=="" || overlayList[i].logoImg==null){
					content+='src="resources/imgs/logo/circleLogo.png"/>';
				}else{
					content+='src="'+overlayList[i].logoImg+'"/>';					
				}
				content+='</div><div class="media-body"><div class="top bold">'+overlayList[i].name+'</div><div class="center">'+overlayList[i].roadAddress+'<br/>'+overlayList[i].tel;	
				if(overlayList[i].store_Id){
					content+='<br/><p class="text-info">맛'+overlayList[i].tasteLevel+' 가격'+overlayList[i].priceLevel+' 분위기'+overlayList[i].moodLevel+' 서비스'+overlayList[i].serviceLevel+' 편의성'+overlayList[i].convenienceLevel+'</p>';
				}
				content+='</div><div class="bottom"></div></div></div>'; 
				
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
			        kakao.maps.event.addListener(marker, 'click', function(){
			        	
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
		    $('#map_re-search').show().css({'position':'relative','top':'-50px','left':'50%','z-index':'2','transform':'translateX(-50%)'});
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
							$('#warning_noResult').text("검색 결과가 없습니다😥");
						}					    							
				    }
				},
				success: function(data){
					if(data.length==0){
						$('#warning_noResult').text("검색 결과가 없습니다😥");
						$('#page').hide();
					}
					reload_map(data);
					paging(data.length, 1);
				}
			});	
		});		

		function reload_map(data){
			overlayList=[];
			var template = $($('.links_container')[0]).clone();
			$('.links_container').remove();
			$(data).each(function(idx, ele){			
				var store = template.clone();
				$(store).addClass('page-'+idx);
				var inputs = $(store).children().children().children('input');
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
				$($(store).children()[0]).find('img').attr('alt', ele.name + '대표이미지');
				if(ele.storeImg1)
					$($(store).children()[0]).find('img').attr('src', ele.storeImg1);
				var spans = $($(store).children()[0]).find('span');
				console.log(spans);
				$(spans[0]).html(ele.name);
				$(spans[1]).html(ele.averageLevel);
				$(spans[2]).html(ele.reviewCnt);
				$(spans[3]).html(ele.viewCnt);
				var distance;
				if(ele.distance>=1000){
					distance = (ele.distance/1000).toFixed(1)+"km";
				}else if(ele.distance==null){
					distance="";
				}else{
					distance = (ele.distance*1).toFixed(0)+"m";
				}
				$(spans[4]).text(distance +" "+ ele.roadAddress);
				$(store).appendTo('#result_stores .row').show();
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
	
//페이지 바 추가, 페이지에 해당하는 가게 노출 및 지도 처리f
	function paging(totalCount,currentPage){
		$('.links_container').hide(); //일단 가게 다 숨겨
		$('.pagination>li').not($('.pagination>li:first')).not($('.pagination>li:last')).remove(); //페이지 바 초기화
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
			$('.links_container').hide();
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
			$('html, body').animate( { scrollTop : 112 }, 200 );
		}
		
		$('.pagination>li').not($('.pagination>li:first')).not($('.pagination>li:last')).on("click",goPage);
		$('.pagination>li:nth-child(2)').click();
		$('#page').show();
	};
    //스크롤 위치에 따라 헤더 searchBar show / hide
    function mapResize(){
    	var width = $(window).width();
    	if(width<992){
			var mapHeight = $(window).height()*1/2;
			$('#map').css('height', mapHeight);
    	}else{
			$('#map').css('height', '600px');
    	}
    }
    
    function showHeaderSearch(){
    	var position = $(window).scrollTop();
    	var width = $(window).width();
    	if(width>991){
    		if(position > 113){
            	$('#searchBar').show();
            }else{
            	$('#searchBar').hide();
            }
        }else{
        	if(position > 99){
            	$('#searchBar').show();
            }else{
            	$('#searchBar').hide();
            }
        }
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
        	<div id="filter_region" class="filter col-md-offset-1 col-md-10">
        		<ul class="nav nav-pills">
				  <li class="seoul active" role="presentation"><a>서울</a></li>
				  <li class="gyeonggi" role="presentation"><a>경기</a></li>
				  <li class="sejong" role="presentation"><a>세종</a></li>
				  <li class="gangwon" role="presentation"><a>강원</a></li>
				  <li class="gyeongsangbuk-do" role="presentation"><a>경상북도</a></li>
				  <li class="gyeongsangnam-do" role="presentation"><a>경상남도</a></li>
				  <li class="gwangju" role="presentation"><a>광주</a></li>
				  <li class="daegu" role="presentation"><a>대구</a></li>
				  <li class="daejeon" role="presentation"><a>대전</a></li>
				  <li class="busan" role="presentation"><a>부산</a></li>
				  <li class="ulsan" role="presentation"><a>울산</a></li>
				  <li class="incheon" role="presentation"><a>인천</a></li>
				  <li class="jeollanam-do" role="presentation"><a>전라남도</a></li>
				  <li class="jeollabuk-do" role="presentation"><a>전라북도</a></li>
				  <li class="jeju" role="presentation"><a>제주도</a></li>
				  <li class="chungcheongbuk-do" role="presentation"><a>충청북도</a></li>
				  <li class="chungcheongnam-do" role="presentation"><a>충청남도</a></li>
				</ul>
				<div class="region_list seoul">
					<input type="hidden" name="region" value="서울"/>
					<div class="btn btn-default" value="강남">강남구</div>
					<div class="btn btn-default" value="강동">강동구</div>
					<div class="btn btn-default" value="강북">강북구</div>
					<div class="btn btn-default" value="강서">강서구</div>
					<div class="btn btn-default" value="관악">관악구</div>
					<div class="btn btn-default" value="광진">광진구</div>
					<div class="btn btn-default" value="구로">구로구</div>
					<div class="btn btn-default" value="금천">금천구</div>
					<div class="btn btn-default" value="노원">노원구</div>
					<div class="btn btn-default" value="도봉">도봉구</div>
					<div class="btn btn-default" value="동대문">동대문구</div>
					<div class="btn btn-default" value="동작">동작구</div>
					<div class="btn btn-default" value="마포">마포구</div>
					<div class="btn btn-default" value="서대문">서대문구</div>
					<div class="btn btn-default" value="서초">서초구</div>
					<div class="btn btn-default" value="성동">성동구</div>
					<div class="btn btn-default" value="성북">성북구</div>
					<div class="btn btn-default" value="송파">송파구</div>
					<div class="btn btn-default" value="양천">양천구</div>
					<div class="btn btn-default" value="영등포">영등포구</div>
					<div class="btn btn-default" value="용산">용산구</div>
					<div class="btn btn-default" value="은평">은평구</div>
					<div class="btn btn-default" value="종로">종로구</div>
					<div class="btn btn-default" value="중구">중구</div>
					<div class="btn btn-default" value="중랑">중랑구</div>
				</div>
				<div class="region_list gyeonggi">
					<input type="hidden" name="region" value="경기도"/>
					<div class="btn btn-default" value="가평">가평군</div>
					<div class="btn btn-default" value="고양">고양시</div>
					<div class="btn btn-default" value="과천">과천시</div>
					<div class="btn btn-default" value="광명">광명시</div>
					<div class="btn btn-default" value="광주">광주시</div>
					<div class="btn btn-default" value="구리">구리시</div>
					<div class="btn btn-default" value="군포">군포시</div>
					<div class="btn btn-default" value="김포">김포시</div>
					<div class="btn btn-default" value="남양주">남양주시</div>
					<div class="btn btn-default" value="동두천">동두천시</div>
					<div class="btn btn-default" value="부천">부천시</div>
					<div class="btn btn-default" value="성남">성남시</div>
					<div class="btn btn-default" value="수원">수원시</div>
					<div class="btn btn-default" value="시흥">시흥시</div>
					<div class="btn btn-default" value="안산">안산시</div>
					<div class="btn btn-default" value="안성">안성시</div>
					<div class="btn btn-default" value="안양">안양시</div>
					<div class="btn btn-default" value="양주">양주시</div>
					<div class="btn btn-default" value="양평">양평군</div>
					<div class="btn btn-default" value="여주">여주시</div>
					<div class="btn btn-default" value="연천">연천군</div>
					<div class="btn btn-default" value="오산">오산시</div>
					<div class="btn btn-default" value="용인">용인시</div>
					<div class="btn btn-default" value="의왕">의왕시</div>
					<div class="btn btn-default" value="의정부">의정부시</div>
					<div class="btn btn-default" value="이천">이천시</div>
					<div class="btn btn-default" value="파주">파주시</div>
					<div class="btn btn-default" value="평택">평택시</div>
					<div class="btn btn-default" value="포천">포천시</div>
					<div class="btn btn-default" value="하남">하남시</div>
					<div class="btn btn-default" value="화성">화성시</div>
				</div>
				<div class="region_list sejong">
					<input type="hidden" name="region" value=""/>
					<div class="btn btn-default" value="세종">세종시</div>
				</div>
				<div class="region_list gangwon">
					<input type="hidden" name="region" value="강원도"/>
					<div class="btn btn-default" value="강릉">강릉시</div>
					<div class="btn btn-default" value="고성">고성군</div>
					<div class="btn btn-default" value="동해">동해시</div>
					<div class="btn btn-default" value="삼척">삼척시</div>
					<div class="btn btn-default" value="속초">속초시</div>
					<div class="btn btn-default" value="양구">양구군</div>
					<div class="btn btn-default" value="양양">양양군</div>
					<div class="btn btn-default" value="영월">영월군</div>
					<div class="btn btn-default" value="원주">원주시</div>
					<div class="btn btn-default" value="인제">인제군</div>
					<div class="btn btn-default" value="정선">정선군</div>
					<div class="btn btn-default" value="철원">철원군</div>
					<div class="btn btn-default" value="춘천">춘천시</div>
					<div class="btn btn-default" value="태백">태백시</div>
					<div class="btn btn-default" value="평창">평창군</div>
					<div class="btn btn-default" value="홍천">홍천군</div>
					<div class="btn btn-default" value="화천">화천군</div>
					<div class="btn btn-default" value="횡성">횡성군</div>
				</div>
				<div class="region_list gyeongsangbuk-do">
					<input type="hidden" name="region" value="경상북도"/>
					<div class="btn btn-default" value="경산">경산시</div>
					<div class="btn btn-default" value="경주">경주시</div>
					<div class="btn btn-default" value="고령">고령군</div>
					<div class="btn btn-default" value="구미">구미시</div>
					<div class="btn btn-default" value="군위">군위군</div>
					<div class="btn btn-default" value="김천">김천시</div>
					<div class="btn btn-default" value="문경">문경시</div>
					<div class="btn btn-default" value="봉화">봉화군</div>
					<div class="btn btn-default" value="상주">상주시</div>
					<div class="btn btn-default" value="성주">성주군</div>
					<div class="btn btn-default" value="안동">안동시</div>
					<div class="btn btn-default" value="영덕">영덕군</div>
					<div class="btn btn-default" value="양양">양양군</div>
					<div class="btn btn-default" value="영주">영주시</div>
					<div class="btn btn-default" value="영천">영천시</div>
					<div class="btn btn-default" value="예천">예천군</div>
					<div class="btn btn-default" value="울릉">울릉군</div>
					<div class="btn btn-default" value="울진">울진군</div>
					<div class="btn btn-default" value="의성">의성군</div>
					<div class="btn btn-default" value="청도">청도군</div>
					<div class="btn btn-default" value="청송">청송군</div>
					<div class="btn btn-default" value="칠곡">칠곡군</div>
					<div class="btn btn-default" value="포항">포항시</div>
				</div>
				<div class="region_list gyeongsangnam-do">
					<input type="hidden" name="region" value="경상남도"/>
					<div class="btn btn-default" value="거제">거제시</div>
					<div class="btn btn-default" value="거창">거창군</div>
					<div class="btn btn-default" value="고성">고성군</div>
					<div class="btn btn-default" value="김해">김해시</div>
					<div class="btn btn-default" value="남해">남해군</div>
					<div class="btn btn-default" value="밀양">밀양시</div>
					<div class="btn btn-default" value="사천">사천시</div>
					<div class="btn btn-default" value="산청">산청군</div>
					<div class="btn btn-default" value="양산">양산시</div>
					<div class="btn btn-default" value="의령">의령군</div>
					<div class="btn btn-default" value="진주">진주시</div>
					<div class="btn btn-default" value="창녕">창녕군</div>
					<div class="btn btn-default" value="창원">창원시</div>
					<div class="btn btn-default" value="통영">통영시</div>
					<div class="btn btn-default" value="하동">하동군</div>
					<div class="btn btn-default" value="함안">함안군</div>
					<div class="btn btn-default" value="함양">함양군</div>
					<div class="btn btn-default" value="합천">합천군</div>
				</div>
				<div class="region_list gwangju">
					<input type="hidden" name="region" value="광주"/>
					<div class="btn btn-default" value="광산">광산구</div>
					<div class="btn btn-default" value="동구">동구</div>
					<div class="btn btn-default" value="서구">서구</div>
					<div class="btn btn-default" value="남구">남구</div>
					<div class="btn btn-default" value="북구">북구</div>
				</div>
				<div class="region_list daegu">
					<input type="hidden" name="region" value="대구"/>
					<div class="btn btn-default" value="달서">달서구</div>
					<div class="btn btn-default" value="달성">달성군</div>
					<div class="btn btn-default" value="수성">수성구</div>
					<div class="btn btn-default" value="중구">중구</div>
					<div class="btn btn-default" value="동구">동구</div>
					<div class="btn btn-default" value="서구">서구</div>
					<div class="btn btn-default" value="남구">남구</div>
					<div class="btn btn-default" value="북구">북구</div>
				</div>
				<div class="region_list daejeon">
					<input type="hidden" name="region" value="대전"/>
					<div class="btn btn-default" value="유성">유성구</div>
					<div class="btn btn-default" value="대덕">대덕구</div>
					<div class="btn btn-default" value="중구">중구</div>
					<div class="btn btn-default" value="동구">동구</div>
					<div class="btn btn-default" value="서구">서구</div>
				</div>
				<div class="region_list busan">
					<input type="hidden" name="region" value="부산"/>
					<div class="btn btn-default" value="강서">강서구</div>
					<div class="btn btn-default" value="금정">금정구</div>
					<div class="btn btn-default" value="기장">기장군</div>
					<div class="btn btn-default" value="동래">동래구</div>
					<div class="btn btn-default" value="부산진">부산진구</div>
					<div class="btn btn-default" value="사상">사상구</div>
					<div class="btn btn-default" value="사하">사하구</div>
					<div class="btn btn-default" value="수영">수영구</div>
					<div class="btn btn-default" value="연제">연제구</div>
					<div class="btn btn-default" value="영도">영도구</div>
					<div class="btn btn-default" value="해운대">해운대구</div>
					<div class="btn btn-default" value="중구">중구</div>
					<div class="btn btn-default" value="동구">동구</div>
					<div class="btn btn-default" value="서구">서구</div>
					<div class="btn btn-default" value="남구">남구</div>
					<div class="btn btn-default" value="북구">북구</div>
				</div>
				<div class="region_list ulsan">
					<input type="hidden" name="region" value="울산"/>
					<div class="btn btn-default" value="울주">울주군</div>
					<div class="btn btn-default" value="중구">중구</div>
					<div class="btn btn-default" value="남구">남구</div>
					<div class="btn btn-default" value="동구">동구</div>
					<div class="btn btn-default" value="북구">북구</div>
				</div>				
				<div class="region_list incheon">
					<input type="hidden" name="region" value="인천"/>
					<div class="btn btn-default" value="강화">강화군</div>
					<div class="btn btn-default" value="계양">계양구</div>
					<div class="btn btn-default" value="남동">남동구</div>
					<div class="btn btn-default" value="미추홀">미추홀구</div>
					<div class="btn btn-default" value="부평">부평구</div>
					<div class="btn btn-default" value="연수">연수구</div>
					<div class="btn btn-default" value="옹진">옹진군</div>
					<div class="btn btn-default" value="중구">중구</div>
					<div class="btn btn-default" value="동구">동구</div>
					<div class="btn btn-default" value="서구">서구</div>
				</div>				
				<div class="region_list jeollanam-do">
					<input type="hidden" name="region" value="전라남도"/>
					<div class="btn btn-default" value="강진">강진군</div>
					<div class="btn btn-default" value="고흥">고흥군</div>
					<div class="btn btn-default" value="곡성">곡성군</div>
					<div class="btn btn-default" value="광양">광양시</div>
					<div class="btn btn-default" value="구례">구례군</div>
					<div class="btn btn-default" value="나주">나주시</div>
					<div class="btn btn-default" value="담양">담양군</div>
					<div class="btn btn-default" value="목포">목포시</div>
					<div class="btn btn-default" value="무안">무안군</div>
					<div class="btn btn-default" value="보성">보성군</div>
					<div class="btn btn-default" value="순천">순천시</div>
					<div class="btn btn-default" value="신안">신안군</div>
					<div class="btn btn-default" value="여수">여수시</div>
					<div class="btn btn-default" value="영광">영광군</div>
					<div class="btn btn-default" value="영암">영암군</div>
					<div class="btn btn-default" value="완도">완도군</div>
					<div class="btn btn-default" value="장성">장성군</div>
					<div class="btn btn-default" value="장흥">장흥군</div>
					<div class="btn btn-default" value="진도">진도군</div>
					<div class="btn btn-default" value="함평">함평군</div>
					<div class="btn btn-default" value="해남">해남군</div>
					<div class="btn btn-default" value="화순">화순군</div>
				</div>				
				<div class="region_list jeollabuk-do">
					<input type="hidden" name="region" value="전라북도"/>
					<div class="btn btn-default" value="고창">고창군</div>
					<div class="btn btn-default" value="군산">군산시</div>
					<div class="btn btn-default" value="김제">김제시</div>
					<div class="btn btn-default" value="남원">남원시</div>
					<div class="btn btn-default" value="무주">무주군</div>
					<div class="btn btn-default" value="부안">부안군</div>
					<div class="btn btn-default" value="순창">순창군</div>
					<div class="btn btn-default" value="완주">완주군</div>
					<div class="btn btn-default" value="익산">익산시</div>
					<div class="btn btn-default" value="임실">임실군</div>
					<div class="btn btn-default" value="장수">장수군</div>
					<div class="btn btn-default" value="전주">전주시</div>
					<div class="btn btn-default" value="정읍">정읍시</div>
					<div class="btn btn-default" value="진안">진안군</div>
				</div>				
				<div class="region_list jeju">
					<input type="hidden" name="region" value="제주도"/>
					<div class="btn btn-default" value="제주">제주시</div>
					<div class="btn btn-default" value="서귀포">서귀포시</div>
				</div>				
				<div class="region_list chungcheongbuk-do">
					<input type="hidden" name="region" value="충청북도"/>
					<div class="btn btn-default" value="괴산">괴산군</div>
					<div class="btn btn-default" value="단양">단양군</div>
					<div class="btn btn-default" value="보은">보은군</div>
					<div class="btn btn-default" value="영동">영동군</div>
					<div class="btn btn-default" value="옥천">옥천군</div>
					<div class="btn btn-default" value="음성">음성군</div>
					<div class="btn btn-default" value="제천">제천시</div>
					<div class="btn btn-default" value="증평">증평군</div>
					<div class="btn btn-default" value="진천">진천군</div>
					<div class="btn btn-default" value="청주">청주시</div>
					<div class="btn btn-default" value="충주">충주시</div>
				</div>				
				<div class="region_list chungcheongnam-do">
					<input type="hidden" name="region" value="충청남도"/>
					<div class="btn btn-default" value="계룡">계룡시</div>
					<div class="btn btn-default" value="공주">공주시</div>
					<div class="btn btn-default" value="금산">금산군</div>
					<div class="btn btn-default" value="논산">논산시</div>
					<div class="btn btn-default" value="당진">당진시</div>
					<div class="btn btn-default" value="보령">보령시</div>
					<div class="btn btn-default" value="부여">부여군</div>
					<div class="btn btn-default" value="서산">서산시</div>
					<div class="btn btn-default" value="서천">서천군</div>
					<div class="btn btn-default" value="아산">아산시</div>
					<div class="btn btn-default" value="예산">예산군</div>
					<div class="btn btn-default" value="천안">천안시</div>
					<div class="btn btn-default" value="청양">청양군</div>
					<div class="btn btn-default" value="태안">태안군</div>
					<div class="btn btn-default" value="홍성">홍성군</div>
				</div>				
			</div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
        <button type="button" class="btn btn-default" id="region_modal_btn">필터 적용</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<div id="header">
	<jsp:include page="../../resources/template/header.jsp" flush="true"></jsp:include>
	<div id="search" class="row">
		<form class="form-inline" action="stores">
			<div class="col-md-12">
				<input type="text" name="keyword" class="" id="keyword2" placeholder="검색어를 입력해주세요." value="${keyword}"/>
				<button id="searchBtn2" class="btn btn-default" type="submit"><img style="weight:20px; height: 20px;" src="<c:url value="/resources/imgs/icons/search.svg"/>"></button><br/>
			</div>
			<div id="filter_sort" class="filter col-md-12">
				<div class="btn-group" data-toggle="buttons">
	                   <label class="btn btn-default">
						<input type="radio" name="filter" value="averageLevel" <c:if test="${filter eq 'averageLevel'}">checked="checked"</c:if>><span>평점순</span>
	                   </label>
	                   <label class="btn btn-default">
						<input type="radio" name="filter" value="reviewCnt" <c:if test="${filter eq 'reviewCnt'}">checked="checked"</c:if>><span>리뷰순</span>
	                   </label>
	                   <label class="btn btn-default">
						<input type="radio" name="filter" value="viewCnt" <c:if test="${filter eq 'viewCnt'}">checked="checked"</c:if>><span>조회순</span>
	                   </label>
	                   <label class="btn btn-default">
						<input type="radio" name="filter" value="distance" <c:if test="${filter eq 'distance'}"> checked="checked"</c:if>><span>거리순</span>
	                   </label>
	               </div>
				<!-- 모달 트리거 버튼-->
				<button type="button" class="btn btn-default" data-toggle="modal" data-target="#region_modal"><img style="weight:10px; height: 10px;" src="<c:url value="/resources/imgs/icons/filter.svg"/>">지역필터</span></button>
			</div>
			<input type="hidden" name="region" id="region1" disabled="disabled"/>
			<input type="hidden" name="region" id="region2" disabled="disabled"/>
			<c:if test="${not empty msg_changedFilter}"><p>원하는 결과가 없나요? ${keyword }를 장소명으로 <a id="re-search" href="#">재검색</a>해보세요😉</p></c:if>		
		</form>
	</div>

</div>
<div id="content" class="container-fluid" style="padding-top : 0">
	<div class="row">			
		<c:if test="${empty storeList}"><div style="margin-top:30px" class="warning col-md-12">검색 결과가 없습니다😥</div></c:if>
		<c:if test="${not empty storeList }">
			<div id="mapContainer" class="col-xs-12 col-md-6">
				<div id="map"></div>
				<button id="map_re-search" class="btn btn-default" style="display:none">이 지역에서 재검색</button>	
			</div>			
		</c:if>
		<div id="result_stores" class="col-xs-12 col-md-6">
			<div class="warning">
				<span id="warning_changedFilter"><small>${msg_changedFilter}</small></span>
				<span id="warning_noResult"></span>
				<!-- <span id="warning_geo">
					<strong>정확한 검색을 위해 위치 정보 접근을 허용해주세요:)</strong><br/>
					<small>(현재 위치 정보가 없을 시, 강남역을 기준으로 검색됩니다!)</small>
				</span> -->	
			</div>			
			<div style="display:none" class="links_container col-xs-6 col-md-6">
					<div class="links">
						<form action="stores" method="post">
							<img alt="대표 이미지" src="resources/imgs/logo/stampLogo.png">
							<input type="hidden" name="store_Id" value="">
							<input type="hidden" name="kakaoId" value="">
							<input type="hidden" class="name" name="name" value=""><span class="bold"></span>&nbsp;<span class="score"></span><br/>
							<img style="width:12px; height:12px;" src="<c:url value="/resources/imgs/icons/edit.svg"/>">&nbsp;<span></span>&nbsp;&nbsp;<img style="width:12px; height:12px;" src="<c:url value="/resources/imgs/icons/eye.svg"/>">&nbsp;<span></span><br/>
							<input type="hidden" class="roadAddress" name="roadAddress" value=""><span class="span_roadAddress"></span><br/>
							<input type="hidden" name="address" value="">
							<input type="hidden" name="tel" value="">
							<input type="hidden" name="category" value="">				
							<input type="hidden" name="url" value="">
							<input type="hidden" name="xLocation" value="">
							<input type="hidden" name="yLocation" value="">	
						</form>	
					</div>
			</div>
			<div class= row>	
			<c:forEach items="${storeList}" var="bean" varStatus="status">
				<c:if test="${bean.distance ge 1000.0}"><fmt:formatNumber var="distance" value="${bean.distance/1000}" pattern="#.0km"></fmt:formatNumber></c:if>
				<c:if test="${bean.distance lt 1000.0}"><fmt:formatNumber var="distance" value="${bean.distance}" pattern="#m"></fmt:formatNumber></c:if>
				<div class="links_container col-xs-6 col-md-6 page-${status.index }">
					<div class="links">
						<form action="stores" method="post">
							<c:if test="${bean.storeImg1 ne null}">
								<img alt="${bean.name} 대표 이미지" src="${bean.storeImg1}"/>
							</c:if>
							<c:if test="${bean.storeImg1 eq null}">
								<c:if test="${bean.logoImg ne null}">
									<img alt="${bean.name} 대표 이미지" src="${bean.logoImg}"/>
								</c:if>
								<c:if test="${bean.logoImg eq null}">
									<img alt="${bean.name} 대표 이미지" src="resources/imgs/logo/stampLogo.png"/>
								</c:if>
							</c:if>
							<br/>
							
							<input type="hidden" name="store_Id" value="${bean.store_Id}">
							<input type="hidden" name="kakaoId" value="${bean.kakaoId}">
							<input type="hidden" class="name" name="name" value="${bean.name}"><span class="bold">${bean.name }</span>&nbsp;<span class="score">${bean.averageLevel}</span><br/>
							<img style="width:12px; height:12px;" src="<c:url value="/resources/imgs/icons/edit.svg"/>">&nbsp;<span>${bean.reviewCnt}</span>&nbsp;&nbsp;<img style="width:12px; height:12px;" src="<c:url value="/resources/imgs/icons/eye.svg"/>">&nbsp;<span>${bean.viewCnt}</span><br/>
							<input type="hidden" class="roadAddress" name="roadAddress" value="${bean.roadAddress}"><span class="span_roadAddress">${distance} ${bean.roadAddress }</span><br/>
							<input type="hidden" name="address" value="${bean.address}">
							<input type="hidden" name="tel" value="${bean.tel}">
							<input type="hidden" name="category" value="${bean.category}">				
							<input type="hidden" name="url" value="${bean.url}">
							<input type="hidden" name="xLocation" value="${bean.xLocation}">
							<input type="hidden" name="yLocation" value="${bean.yLocation}">	
						</form>
					</div>	
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