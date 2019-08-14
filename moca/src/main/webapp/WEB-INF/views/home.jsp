<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="resources/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="resources/css/bootstrap-theme.min.css">
	<script type="text/javascript" src="resources/js/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="resources/js/bootstrap.min.js"></script>
<!-- 
	<script type="text/javascript" src="resources/js/jquery.mobile-1.4.5.js"></script>
 -->
	<script type="text/javascript">
	
		$(function(){


			//리뷰 받아오기
			$.ajax({
				type:"GET",
				url:"reviews/1",
				datatype: "json",
				error : function(errorMsg){
					console.log("리뷰 받아오기 실패",errorMsg);
				},
				success: function(reviewsJson){
					console.log("리뷰 받아오기 성공", reviewJson);

					//리뷰 데이터 띄우기
					displayReviews(reviewsJson);
				}
			})
			
		})
		
		//리뷰 데이터 띄우기
		function displayReviews(json){
			
		}
	</script>
	<title>Home</title>
</head>
<body>
<h1>
	Hello world!  
</h1>
<!-- 목록 예시 -->
<!-- 
{
      "address_name": "제주특별자치도 서귀포시 성산읍 고성리 238",
      "category_group_code": "CE7",
      "category_group_name": "카페",
      "category_name": "음식점 > 카페 > 커피전문점 > 스타벅스",
      "distance": "",
      "id": "414395112",
      "phone": "064-782-3273",
      "place_name": "스타벅스 제주성산DT점",
      "place_url": "http://place.map.kakao.com/414395112",
      "road_address_name": "제주특별자치도 서귀포시 성산읍 일출로 80",
      "x": "126.920676533644",
      "y": "33.4496930061935"
    },
 -->
<form method="post" action="store">
	<input type="number" name="kakaoId" value="414395112"/>
	<input type="number" name="store_Id" value="0"/>
	<input type="text" name="category" value="음식점 > 카페 > 커피전문점 > 스타벅스"/>
	<input type="text" name="name" value="스타벅스 제주성산DT점"/>
	<input type="tel" name="tel" value="064-782-3273"/>
	<input type="text" name="address" value="제주특별자치도 서귀포시 성산읍 고성리 238"/>
	<input type="text" name="roadAddress" value="제주특별자치도 서귀포시 성산읍 일출로 80"/>
	<input type="text" name="xLocation" value="126.920676533644"/>
	<input type="text" name="yLocation" value="33.4496930061935"/>
	<input type="text" name="distance" value="50"/>
	<button type="submit">상세</button>
</form>
</body>
</html>
