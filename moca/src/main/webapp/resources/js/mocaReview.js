//변수 선언부
var likeHateButton;
var btnGroup;
var likeHateCount;
var reviewId;
var clickedLikeHateButton;
var likeBtn;
var hateBtn;
var likeCount;
var hateCount;


var reviewModal;
var reviewForm;
var reviewModalBtn;
var saveReviewBtn;
var editReviewBtn;
var imgFiles;

var editReviewRow
var editBtn;
var deleteBtn;
var clickedEditBtn;
var thumbnailDeleteSpan;

var reviewFormObj;

//리뷰 개수 더보기
var quotient; //몫
var remainder; //나머지
var callNum=1; //호출 넘버

//리뷰 수정시 삭제된 이미지
let delThumbnail="";

////////////////////////////
//함수부

//변수 바인딩
var bindReviewVariable = function(){
	reviewModalBtn = $('#reviewModalBtn');
	reviewModal = $('#reviewModal');
	reviewForm = $('#reviewModal form');
	saveReviewBtn = $('#saveReviewBtn');
	editReviewBtn = $('#editReviewBtn');
	imgFiles = $('#files');
	
	editBtn = $('.btn-edit')
	deleteBtn = $('.btn-delete')
	thumbnailDeleteSpan = $('.thumbnailDeleteSpan');

	likeHateButton = $('.like-hate>.btn-group>button')
	
	//리뷰 더보기
	quotient = $('.reviewCnt').length/3;
	remainder = $('.reviewCnt').length%3;
}


//리뷰 저장
var saveReview = function(fileBuffer){
	console.log("saveReviewBtn clicked",fileBuffer)
	var form = $('#reviewForm')[0];

	var reviewFormData = new FormData(form);
	
	reviewFormData.delete('file');
	
	var fileSize = fileBuffer.length;
	console.log("fileSize"+fileSize);
	console.log("save",fileBuffer);
	
	
	$.ajax({
		type: 'POST',
		enctype : 'multipart/form-data',
		url: '/moca/reviews',
		data : reviewFormData,
		dataType : "json",
		contentType : false,  
		processData : false,
		cache : false,
		timeout : 600000,
		beforeSend:function(){
			if(fileSize >0){
				for(var i=0 ; i < fileSize ; i ++){
					reviewFormData.append("file",fileBuffer[i]);
					console.log(i,fileBuffer[i]);
				}
			}
	    },
		success: function(reviewVo) {
			console.log('ajax 통신 성공');
			console.log(reviewVo);
			
			//리뷰 추가(최상단에)
			addReviewInReviewContent(reviewVo);
	
			$('#reviewModal').modal("hide");		//모달창 닫기
		
			//수정 삭제 버튼 바인딩 해줄것 
			
		},
		error: function(error) {
			console.log('ajax 통신 실패', error);
		}
	})
}

var addReviewInReviewContent = function(reviewVo) {
	var newReview = $('#reviewTemplate').clone(true);
	newReview.css('display', '');
	newReview.removeAttr('id')
	
	var reviewerInfo = newReview.find('.reviewer-info')
	var reviewInfo = newReview.find('.review-info')
	var reviewLevel = newReview.children(".review-level")
	
	// 나중에 사진 추가할때 사용
	var reviewThumbnail = reviewInfo.children('.reviewThumbnailGroup');
	for(var i=0; i<reviewVo.imageList.length; i++){
		var oldReviewThumbnail = reviewThumbnail.html();
		reviewThumbnail.html(oldReviewThumbnail+'<div class="reviewThumbnail"><img src="'+
				reviewVo.imageList[i].thumbnailUrl
				+'" alt="Image" class="img-thumbnail" id="'+
				reviewVo.imageList[i].uu_id
				+'"></div>');
	}
	
	newReview.find('.review-id').eq(0).val(''+reviewVo.review_id);
	newReview.find('.review-id').eq(1).val(''+reviewVo.review_id);
	
	reviewerInfo.find('.reviewer-nickName').text(reviewVo.nickName) 	//닉네임
	reviewerInfo.find('.reviewer-followers').text(reviewVo.followCount) //팔로워수
	reviewerInfo.find('.reviewer-reviewse').text(reviewVo.reviewCount) 	//리뷰수
	
	/// label 옆에 input 같은거 추가할 필요가 있음
	reviewInfo.find('.reviewInfo-write-date').text((new Date(reviewVo.writeDate)).toLocaleDateString())
	reviewInfo.find('.reviewInfo-review-content').text(reviewVo.reviewContent)
	
	var likehateFormGroup = reviewInfo.children('.like-hate')
	
	//eq(0) 리뷰id, eq(1) 좋아요수, eq(2) 싫어요수
	likehateFormGroup.find('input').eq(0).val(reviewVo.review_id)
	likehateFormGroup.find('input').eq(1).val(0)
	likehateFormGroup.find('input').eq(2).val(0)
	
	
	reviewLevel.find('.taste-level').text(reviewVo.tasteLevel)
	reviewLevel.find('.price-level').text(reviewVo.priceLevel)
	reviewLevel.find('.service-level').text(reviewVo.serviceLevel)
	reviewLevel.find('.mood-level').text(reviewVo.moodLevel)
	reviewLevel.find('.convenience-level').text(reviewVo.convenienceLevel)
	reviewLevel.find('.average-level').text(reviewVo.averageLevel)

	$('.review-content').prepend(newReview);	//리뷰에 추가
}


//리뷰 데이터를 리뷰 모달로 이동 (수정 때 사용)
var reviewData2ReviewModal = function(clickedEditBtn){
	clearReviewModalData();

	reviewModal.modal("show");		//리뷰 모달창 show

	editReviewRow = $(clickedEditBtn).parents('.row').eq(0);

	//리뷰 아이디
	reviewModal.find('#review_id').val(editReviewRow.find('.review-id').eq(0).val());
				
	///사진(나중에 정해지면)
	console.log(editReviewRow);
	var reviewImg = editReviewRow.find('.reviewThumbnailGroup').clone();
	console.log("reviewImg : ",reviewImg);
	console.log(reviewImg);
	reviewModal.find('#files').after(reviewImg);
	reviewImg.find('.reviewThumbnail img').attr('class','oldThumbnail');
	$('#reviewModal').find('.reviewThumbnail').append('<span class="glyphicon glyphicon-remove thumbnailDeleteSpan" aria-hidden="true" onclick="deleteReviewImg(this)"></span>');		
	$('.thumbnailDeleteSpan').css('position','relative').css('left','-95px').css('top','-30px').css('cursor','pointer')
	.css('background-color','rgb(255,255,255,0.5)');
	
	//리뷰 내용
	reviewModal.find('#review-content').val(editReviewRow.find('.reviewInfo-review-content').text());
	
	//평점
	reviewModal.find('#taste-level').val( editReviewRow.find('.taste-level').text())
	reviewModal.find('#price-level').val( editReviewRow.find('.price-level').text())
	reviewModal.find('#service-level').val( editReviewRow.find('.service-level').text())
	reviewModal.find('#mood-level').val( editReviewRow.find('.mood-level').text())
	reviewModal.find('#convenience-level').val( editReviewRow.find('.convenience-level').text())
	reviewModal.find('#average-level').val( editReviewRow.find('.average-level').text())
}

//리뷰 수정
var editReview = function(){
	//delete한 썸네일 추가
	$(reviewForm).append('<input type="hidden" name="delThumbnail" value="'+delThumbnail+'"/>');
	
	//파일 추가
	var form = $('#reviewForm')[0];

	var reviewFormData = new FormData(form);
	
	reviewFormData.delete('file');
	
	var fileSize = fileBuffer.length;
	
	if(fileSize >0){
		for(var i=0 ; i < fileSize ; i ++){
			reviewFormData.append("file",fileBuffer[i]);
			console.log(i,fileBuffer[i]);
		}
	}
	
	reviewFormObj = $(reviewForm).serializeObject();
	//console.log(reviewFormObj.review_id,reviewFormObj);
	console.log(reviewFormObj.review_id,reviewFormData);
	

	//ajax 통신 - post방식으로 추가
	$.ajax({
		type: 'PUT',
		url: '/moca/reviews/'+reviewFormObj.review_id,
		enctype : 'multipart/form-data',
//		data: reviewFormObj,
		data: reviewFormData,
		dataType : "json",
		contentType : false,  
		processData : false,
		cache : false,
		timeout : 600000,
		success: function(reviewVo) {
			console.log('ajax 통신 성공')
			//리뷰 내용
			editReviewRow.find('.reviewInfo-review-content').text(reviewFormObj.reviewContent);

			//평점
			editReviewRow.find('.taste-level').text(reviewFormObj.tasteLevel);
			editReviewRow.find('.price-level').text(reviewFormObj.priceLevel);
			editReviewRow.find('.service-level').text(reviewFormObj.serviceLevel);
			editReviewRow.find('.mood-level').text(reviewFormObj.moodLevel);
			editReviewRow.find('.convenience-level').text(reviewFormObj.convenienceLevel);
			editReviewRow.find('.average-level').text(reviewVo.averageLevel);
			
			$('#reviewModal').modal("hide");	//모달창 닫기
			
			delThumbnail = "" //delThumbnail 초기화
			
		},
		error: function(error) {
			console.log('ajax 통신 실패', error)
			
		}
	})

}

var clearReviewModalData = function(){
				
	///사진(나중에 정해지면)
	imgFiles.val('');
	reviewModal.find('.reviewThumbnailGroup').remove();

	//리뷰 내용
	reviewModal.find('#review-content').val('');

	//평점
	reviewModal.find('#taste-level').val('1')
	reviewModal.find('#price-level').val('1')
	reviewModal.find('#service-level').val('1')
	reviewModal.find('#mood-level').val('1')
	reviewModal.find('#convenience-level').val('1')
	reviewModal.find('#average-level').val('1')
	
}

//리뷰 삭제
var deleteReview = function(review_id) {
	console.log(review_id);
	$.ajax({
		type: 'DELETE',
		url: '/moca/reviews/'+review_id,
		success: function() {
			console.log('ajax 통신 성공')
		},
		error: function() {
			console.log('ajax 통신 실패')
			alert("리뷰 삭제 실패")
		}
	})
}


//리뷰 사진 삭제 버튼 클릭시
var deleteReviewImg = function(deleteBtn){
	console.log(deleteBtn);
	var temp = delThumbnail;
	if(delThumbnail != ""){		
		delThumbnail = temp+","+$(deleteBtn).prev().attr('src');		
	}else{
		delThumbnail = temp+$(deleteBtn).prev().attr('src');		
	}
	console.log(delThumbnail);
	$(deleteBtn).parent().hide();
}

//리뷰 개수 더보기
var reviewCnt = function(q,r,n){
	//먼저 3개만 보여주고 나머지는 더보기 버튼으로 클릭시 +3개씩 보여주기
	if(3*n<=q*3){
		for(var i=(n-1)*3; i<3*n; i++){ //몫*3 or 나머지
			$('.reviewCnt').eq(i).show();
		}
		if(3*n==q*3){
			$('#moreReview').hide();
		}
	}else{
		if(n!=1){
			for(var i=(n-1)*3; i<((n-1)*3)+r; i++){ //몫*3
				$('.reviewCnt').eq(i).show();
			}
			$('#moreReview').hide();
		}else{
			for(var i=0; i<r; i++){ //나머지
				$('.reviewCnt').eq(i).show();
			}
			$('#moreReview').hide();
		}
	}
};

//리뷰 내용 더보기
var callReviewDataMore = function(){
	var reviewData = $('.more-review-content');
    reviewData.each( function() {
       
       var btnMoreReview = $(this).parent().siblings('.more-review-content-btn');

       if( $(this).outerHeight() > 41 ){
           
       	$(this).css({ 'height': '3em', 'overflow':'hidden' ,'text-overflow': 'ellipsis', 'display':'block' });
          $(this).addClass('moreData');
          btnMoreReview.show();
          btnMoreReview.on("click",function(){
       	   console.log("outerHeight"+$( this ).outerHeight());
             $(this).siblings('.review-content-div').find('.more-review-content').toggleClass('moreData').promise().done(function(){
                  console.log($(this).hasClass("moreData"));
                  if($(this).hasClass("moreData") === false){
                	  btnMoreReview.text("접기");
                  	$(this).css({ 'height': '100%', 'overflow':'default' ,'text-overflow': 'ellipsis', 'display':'block' });
	              }else{
	            	  btnMoreReview.text("더보기");
	            	 $(this).css({ 'height': '3em', 'overflow':'hidden' ,'text-overflow': 'ellipsis', 'display':'block' });
		          }
             });
          });
          
       }else{
           
       	btnMoreReview.hide();
       	
       }
    });
};

//좋아요 또는 싫어요 추가
var addLikeHate = function(reviewId, isLike){
	//ajax 통신 - post방식으로 추가
	$.ajax({
		type: 'POST',
		url: '/moca/likeHates/' + reviewId,
		data: {
			"isLike": isLike
		},
		success: function() {
			console.log('ajax 통신 성공 - 좋아요')
			//ajax 통신 성공시
			
			if(isLike ==1){
				likeBtn.addClass('clicked')
				likeCount.val(Number(likeCount.val()) + 1);
			}else if(isLike == -1){
				hateBtn.addClass('clicked')
				hateCount.val(Number(hateCount.val()) + 1);
			}
		},
		error: function() {
			console.log('ajax 통신 실패')
			alert("좋아요 싫어요 추가 실패")
		}
	})

}

//좋아요 또는 싫어요 변경
var changeLikeHate = function(reviewId, isLike){
	//ajax 통신 - put 방식으로 수정
	$.ajax({
		type: 'PUT',
		url: '/moca/likeHates/' + reviewId,
		data: {
			"isLike": isLike
		},
		success: function() {
			console.log('ajax 통신 성공')
			
			if(isLike ==1){
				hateBtn.removeClass('clicked')
				hateCount.val(Number(hateCount.val()) - 1);
				likeBtn.addClass('clicked')
				likeCount.val(Number(likeCount.val()) + 1);
			}else if( isLike == -1){
				likeBtn.removeClass('clicked')
				likeCount.val(Number(likeCount.val()) - 1);
				hateBtn.addClass('clicked')
				hateCount.val(Number(hateCount.val()) + 1);
			}
			

		},
		error: function() {
			console.log('ajax 통신 실패')
			alert("좋아요 싫어요 변경 실패")
		}

	})
}

//좋아요 또는 싫어요 취소
var cancelLikeHate = function(reviewId, isLike){

	//ajax 통신 - delete 방식으로 삭제
	$.ajax({
		type: 'DELETE',
		url: '/moca/likeHates/' + reviewId,
		data: {
			"isLike": isLike
		},
		success: function() {
			console.log('ajax 통신 성공')
			if(isLike ==1){
				likeBtn.removeClass('clicked')
				likeCount.val(Number(likeCount.val()) - 1);
			}else if(isLike == -1){
				hateBtn.removeClass('clicked')
				hateCount.val(Number(hateCount.val()) - 1);
			}
			
		},
		error: function() {
			console.log('ajax 통신 실패')
			alert("취소 실패")
		}

	})

}



//form 형식의 내용을 js Object 형태로 변경
jQuery.fn.serializeObject = function() {
    var obj = null;
    try {
        if (this[0].tagName && this[0].tagName.toUpperCase() == "FORM") {
            var arr = this.serializeArray();
            if (arr) {
                obj = {};
                jQuery.each(arr, function() {
                    obj[this.name] = this.value;
                });
            }//if ( arr ) {
        }
    } catch (e) {
        alert(e.message);
    } finally {
    }
 
    return obj;
};