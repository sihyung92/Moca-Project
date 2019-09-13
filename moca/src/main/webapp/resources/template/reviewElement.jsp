<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- MODAL -->

<!-- reviewModal -->
<div class="modal fade" id="reviewModal" tabindex="-1" role="dialog" aria-labelledby="reviewModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="reviewModalLabel">
					${storeVo.name}에 대한 리뷰</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" data-role="content">
				<form id="reviewForm">
					<input name="store_id" id="storeId" value="${storeVo.store_Id}" style="display:none;" >
					<input name="review_id" id="review_id" value="0" style="display:none;" >
					<div class="form-group">
						<label for="picture-file">사진 선택</label>
						<!-- <input type="file" name="file" id="picture-file" multiple="multiple"> --><!-- 다중으로 입력 하는 방법을 생각해야 할듯 -->
						<input multiple="multiple" name="file" id="files" type="file"/>
						
					</div> 
					<div class="form-group">
						<label for="review-content">후기</label>
						<textarea class="form-control" name="reviewContent" id="review-content" placeholder="자세한 후기는 다른 고객의 이용에 많은 도움이 됩니다."></textarea>
					</div>
					<div class="form-group storeLevel level">
						<label for="level">평점</label>
						<div id="level"></div>
					</div>	
					<div class="form-group storeLevel">
						<label for="taste-level">맛</label>
						<div id="taste-level"></div>
					</div>
					<div class="form-group storeLevel">
						<label for="price-level">가격</label>
						<div id="price-level"></div>
					</div>	
					<div class="form-group storeLevel">
						<label for="service-level">서비스</label>
						<div id="service-level"></div>
					</div>
					<div class="form-group storeLevel">
						<label for="mood-level">분위기</label>
						<div id="mood-level"></div>
					</div>
					<div class="form-group storeLevel">
						<label for="convenience-level">편의성</label>
						<div id="convenience-level"></div>
					</div>
					
					<div class="form-group tagsCheckbox">
						<c:forEach items="${tagNameList}" var="tagName">
							<label class="checkbox-inline">
								<input type="checkbox" name="tag" value="<c:out value="${tagName}"/>"><c:out value="${tagName}"/>
							</label>
						</c:forEach>
					</div>
					<textarea class="form-control" name="tags" id="review-tags" style="display: none;"></textarea>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
				<button type="button" class="btn btn-primary" id="saveReviewBtn">작성</button>
				<button type="button" class="btn btn-primary" id="editReviewBtn">수정</button>
			</div>
		</div>
	</div>
</div>
	
<!-- 삭제 확인 모달 -->
<div id="confirm" class="modal fade" aria-hidden="true" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" >
	<div class="modal-dialog" role="document">
		<div class="modal-content">
	<div class="modal-body">정말 삭제하시겠습니까?</div>
	<div class="modal-footer">
		<button type="button" data-dismiss="modal" class="btn btn-danger"
			id="delete">삭제</button>
		<button type="button" data-dismiss="modal" class="btn">취소</button>
	</div>
	</div>
	</div>
</div>
	
<!-- 리뷰 이미지 디테일 모달 -->
<div id="reviewsDetailModal" class="modal fade" tabindex="-1">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div id= "reviewDetailDiv" class="modal-body">
        <p>원본 이미지</p>
      </div>
      
      
      <div class="leftRightBtns">
        <button id="preReviewImgBtn" type="button" class="btn btn-default" aria-label="Left Align">
		  <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
		</button>
        <button id="nextReviewImgBtn" type="button" class="btn btn-default" aria-label="Left Align">
		  <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
		</button>
		<div id="reviewThumbnailGroup" class="reviewThumbnailGroup">
			
		</div>
      </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal -->
	
	
	
	
<!-- CLONE -->

<!-- clone할 review element -->
<div class="row"  id="reviewTemplate" style="display : none;">
	<div class="editDeleteGroup btn-group" role="group">
		<input type="number" class="review-id" style="display: none;">
		<input type="number" class="store-id" style="display: none;">
		<img class="btn-edit" src="<c:url value="/resources/imgs/icons/compose.svg"/>"> 
		<img class="btn-delete" src="<c:url value="/resources/imgs/icons/trash.svg"/>">
	</div>
	<div class="reviewer-info col-md-2">
		<div class="profile-div">
			<c:if test="${empty accountVo.thumbnailImage}">
				<img class="accountProfile img-circle" src="<c:url value="/resources/imgs/basicProfile.png"/>" alt="profile" style="width:100px;">
			</c:if>
			<c:if test="${not empty accountVo.thumbnailImage}">
				<img class="accountProfile img-circle"  src="<c:url value="${accountVo.thumbnailImage }" />" alt="profile" style="width:100px;">
			</c:if>
		</div>
		<div class="nickName-div">
			<label>별명</label>	
			<span class="reviewer-nickName">${accountVo.nickname }</span>
		</div>
		<div class="follows-div">
			<label>팔로워 수</label>
			<span class="reviewer-followers">${accountVo.followCount }</span>
		</div>
		<div class="reviews-div">
			<label>리뷰 수</label>
			<span class="reviewer-reviews">${accountVo.reviewCount }</span>
		</div>
	</div>
	<div class="store-info col-md-2" style="cursor:pointer;">
		<div class="storeLogo-div">
			<!-- store logo 이미지 -->
			<img src="<c:url value="/resources/imgs/logoDefault.png"/>"	alt="logo" class="img-circle" style="width: 100px;">
		</div>
		<div class="storeName-div">
			<!-- store 이름 -->
			<span class="storeName">${reviewVo.storeName}</span>
		</div>
	</div>
	<div class="review-info col-md-8">
		<div class="reviewThumbnailGroup">
		</div>
		<div class="review-level col-md-2">
			<div class="taste-level-div">
				<label>맛</label>
				<span class="taste-level"></span>점
			</div>
			<div class="price-level-div">
				<label>가격</label>
				<span class="price-level"></span>점
			</div>
			<div class="service-level-div">
				<label>서비스</label>
				<span class="service-level"></span>점
			</div>
			<div class="taste-level-div">
				<label>분위기</label>
				<span class="mood-level"></span>점
			</div>
			<div class="taste-level-div">
				<label>편의성</label>
				<span class="convenience-level"></span>점
			</div>
		</div>
		<div class="review-data">
			<div class="write-date-div">
				<label>작성일</label>
				<span class="reviewInfo-write-date"></span>
			</div>
			<div class="review-content-div">
				<label>리뷰 내용</label>
				<span class="reviewInfo-review-content"></span>
				<span class="more-review-content-btn">더보기</span>
			</div>
			<div class="review-tags-div"></div>
		</div>
		<div class="form-group like-hate">
			<div class="btn-group" data-toggle="buttons">
				<input type="number" class="review-id" style="display: none;">
				<img class="like-btn" src="<c:url value="/resources/imgs/icons/thumbs-up.svg"/>">
				<input type="number" class="like-count" value=0 >
				<img class="hate-btn" src="<c:url value="/resources/imgs/icons/thumbs-down.svg"/>">
				<input type="number" class="hate-count" value=0>
			</div>
		</div>
	</div>
	<div class="average-level-div  col-md-2">
		<label for="average_level">평균</label>
		<div class="reviewAverageLevel"></div><span class="average-level"></span>점
	</div>								
	<br><br><br>
	
	<!-- clone할 tag element -->
	<a class="review-tag" id="review-tag-div" href="#" style="display:none;"></a>	
</div>