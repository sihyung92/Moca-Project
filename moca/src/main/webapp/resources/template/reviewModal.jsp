<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!-- Modal -->
	<div class="modal fade" id="reviewModal" tabindex="-1" role="dialog" aria-labelledby="reviewModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="reviewModalLabel">
						${storeVo.name}에 대한 리뷰
					</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body" data-role="content">
					<form id="reviewForm">
						<input name="storeId" id="storeId" value="${storeVo.store_Id}" style="display:none;" >
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
						<div class="form-group">
							<label for="taste-level">맛</label>
							<select id="taste-level" name="tasteLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>
						<div class="form-group">
							<label for="price-level">가격</label>
							<select id="price-level" name="priceLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>	
						<div class="form-group">
							<label for="service-level">서비스</label>
							<select id="service-level" name="serviceLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>
						<div class="form-group">
							<label for="mood-level">분위기</label>
							<select id="mood-level" name="moodLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>
						<div class="form-group">
							<label for="convenience-level">편의성</label>
							<select id="convenience-level" name="convenienceLevel" class="form-control">
								<option>1</option>
								<option>2</option>
								<option>3</option>
								<option>4</option>
								<option>5</option>
								<option>6</option>
								<option>7</option>
								<option>8</option>
								<option>9</option>
								<option>10</option>
							</select>
						</div>

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

	<!-- 리뷰작성 모달 끝-->
	
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
	
	<!-- 리뷰 이미지 디테일 -->
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