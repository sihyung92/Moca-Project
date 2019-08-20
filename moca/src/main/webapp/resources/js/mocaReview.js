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

var editReviewRow
var editBtn;
var deleteBtn;
var clickedEditBtn;

var reviewFormObj;

//리뷰 개수 더보기
var quotient; //몫
var remainder; //나머지
var callNum=1; //호출 넘버


////////////////////////////
//함수부

//변수 바인딩
var bindReviewVariable = function(){
	reviewModal = $('#reviewModal');
	reviewForm = $('#reviewModal form');
	saveReviewBtn = $('#saveReviewBtn');
	editReviewBtn = $('#editReviewBtn');
	
	editBtn = $('.btn-edit')
	deleteBtn = $('.btn-delete')

	likeHateButton = $('.like-hate>.btn-group>button')
	
	//리뷰 더보기
	quotient = $('.reviewCnt').length/3;
	remainder = $('.reviewCnt').length%3;
}


//리뷰 저장
var saveReview = function(){
	console.log("saveReviewBtn clicked")

	console.log($(reviewForm).serializeArray());

	

	//ajax 통싱 - post방식으로 추가
	$.ajax({
		type: 'POST',
		url: '/moca/reviews',
		data: $(reviewForm).serializeArray(),
		success: function(reviewVo) {
			console.log('ajax 통신 성공')
			
			
			//리뷰 추가(최상단에)
			console.log(reviewVo);
			
			//var newReview = $('#reviewTemplate');
			var newReview = $('#reviewTemplate').clone(true);
			newReview.css('display', '');
			newReview.removeAttr('id')
			
			var reviewerInfo = newReview.find('.reviewer-info')
			var reviewInfo = newReview.find('.review-info')
			var reviewLevel = newReview.children(".review-level")
			
			var carouselSlide = reviewInfo.children('.carousel') // 나중에 사진 추가할때 사용
			
			reviewerInfo.find('.reviewer-nickName').text(reviewVo.nickName) 	//닉네임
			reviewerInfo.find('.reviewer-followers').text(reviewVo.followCount) //팔로워수
			reviewerInfo.find('.reviewer-reviewse').text(reviewVo.reviewCount) 	//리뷰수
			
			//id에 review_id 추가
			carouselSlide.attr('id', 'carousel-example-generic' + reviewVo.review_id);
			
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
			$('#reviewModal').modal("hide");		//모달창 닫기


			//수정 삭제 버튼 바인딩 해줄것 
			
			
		},
		error: function(error) {
			console.log('ajax 통신 실패', error)
			
		}
	})
}


//리뷰 데이터를 리뷰 모달로 이동 (수정 때 사용)
var reviewData2ReviewModal = function(clickedEditBtn){
	$('#reviewModal').modal("show");		//리뷰 모달창 show

	editReviewRow = $(clickedEditBtn).parents('.row').eq(0);


	//리뷰 아이디
	reviewModal.find('#review_id').val( editReviewRow.find('.review-id').eq(0).val() );
				
	///사진(나중에 정해지면)

	//리뷰 내용
	reviewModal.find('#review-content').text( editReviewRow.find('.reviewInfo-review-content').text() )

	//평점
	reviewModal.find('#taste-level').val( editReviewRow.find('.taste-level').text() )
	reviewModal.find('#price-level').val( editReviewRow.find('.price-level').text() )
	reviewModal.find('#service-level').val( editReviewRow.find('.service-level').text() )
	reviewModal.find('#mood-level').val( editReviewRow.find('.mood-level').text() )
	reviewModal.find('#convenience-level').val( editReviewRow.find('.convenience-level').text())
	reviewModal.find('#average-level').val( editReviewRow.find('.average-level').text() )
}

//리뷰 수정
var editReview = function(){
	reviewFormObj = $(reviewForm).serializeObject();
	console.log(reviewFormObj.review_id,reviewFormObj);

	//ajax 통싱 - post방식으로 추가
	$.ajax({
		type: 'PUT',
		url: '/moca/reviews/'+reviewFormObj.review_id,
		data: reviewFormObj,
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
			
			
		},
		error: function(error) {
			console.log('ajax 통신 실패', error)
			
		}
	})

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
			alert("취소 실패")
		}
	})
}

//리뷰 개수 더보기
var reviewCnt = function(q,r,n){
	//먼저 3개만 보여주고 나머지는 더보기 버튼으로 클릭시 +3개씩 보여주기
	console.log(q+":"+r+":"+n);
	console.log(3*n+":"+q*3);
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
       //console.log("outerHeight"+$( this ).outerHeight());
       //console.log($(this).parent().siblings('.more-review-content-btn'));
       
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