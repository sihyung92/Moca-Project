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
<table class="table">
	<div class="row">
		<div class="col-md-4">
			<div class="reviewer-info">
			  	<label for="nick-name">$(닉네임 )</label>
			  	<label for="nick-name">$(팔로워 수 )</label>
			  	<label for="nick-name">$(리뷰 수 )</label>
			</div>
		</div>
		<div class="col-md-8">
			<div class="review-info">
			  	<label for="nick-name">$(닉네임 )</label>
			  	<label for="nick-name">$(팔로워 수 )</label>
			  	<label for="nick-name">$(리뷰 수 )</label>
			</div>
		</div>
		
	</div>
</table>


<!-- Button trigger modal -->
<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal">
  리뷰 작성
</button>

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">$(상호 명)에 대한 리뷰</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" data-role="content">
        <form> 
		  <div class="form-group reviewer-info" style="display: none;">
		  	<label for="nick-name">$(닉네임 )</label>
		  	<label for="nick-name">$(팔로워 수 )</label>
		  	<label for="nick-name">$(리뷰 수 )</label>
		  	<label for="nick-name">$(좋아요 수 )</label>
		  	<label for="nick-name">$(싫어요) 수 )</label>
		  </div>
		  <div class="form-group">
		    <label for="review-content">내용</label>
		    <textarea class="form-control" id="review-content" placeholder="리뷰내용을 입력해 주세요"></textarea>
		  </div>
		  <div class="form-group" >
		    <label for="taste-level">맛</label>
		    <input type="range" min="0" max="5" id="taste-level">
		  </div>
		  <div class="form-group" >
		    <label for="price-level">가격</label>
		    <input type="range" min="0" max="5" id="price-level">
		  </div>
		  <div class="form-group" >
		    <label for="mode-level">분위기</label>
		    <input type="range" min="0" max="5" id="mode-level">
		  </div>
		  <div class="form-group" >
		    <label for="service-level">서비스</label>
		    <input type="range" min="0" max="5" id="service-level">
		  </div>
		  <div class="form-group" >
		    <label for="convinient-level">편의성</label>
		    <input type="range" min="0" max="5" id="convinient-level">
		  </div>
		  <div class="form-group" >
		    <label for="convinient-level">편의성</label>
		    <input type="range" min="0" max="5" id="convinient-level">
		  </div>
		  
		  <div class="form-group">
		    <label for="picture-file">사진 선택</label>
		    <input type="file" id="picture-file"><!-- 다중으로 입력 하는 방법을 생각해야 할듯 -->
		  </div>
		  <div class="form-group like-hate" >
		    <div class="btn-group" data-toggle="buttons">
			  <label class="btn btn-primary">
			    좋아요<input type="radio" name="options" id="option2">
			  </label>
			  <input type="number" id="like-count" value=1>
			  <label class="btn btn-primary">
			    싫어요<input type="radio" name="options" id="option3">
			  </label>
			  <input type="number" id="hate-count" value=1>
			</div>
		  </div>
		</form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>
</body>
</html>
